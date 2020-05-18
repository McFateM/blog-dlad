---
title: "Dockerized Traefik Host Using ACME DNS-01 Challenge"
publishdate: 2020-04-27
draft: false
tags:
  - Docker
  - Traefik
  - Portainer
  - Watchtower
  - dockerized-server
  - traefik.frontend.rule
  - ACME
  - DNS-01
  - HTTP-01
  - docker-traefik2-host
  - docker-compose
  - service-stack
---

This post builds on [My dockerized-server Config](https://dlad.summittdweller.com/en/posts/042-my-dockerized-server-config/) and attempts to change what was a problematic [ACME HTTP-01 or httpChallenge](https://docs.traefik.io/https/acme/#httpchallenge) in [Traefik](https://traefik.io) and [Let's Encrypt](https://letsencrypt.org) to an [ACME DNS-01 or dnsChallenge](https://docs.traefik.io/https/acme/#dnschallenge). The problem with the old _HTTP-01_ or _httpChallenge_ is that it requires the creation of a valid and widely accessible "A" record in our DNS _before_ the creation of a cert; the record has to be in place so that the _Let's Encrypt_ CA-server can find it to confirm that the request is valid.  However, doing this puts the cart-before-the-horse, so-to-speak, since we like to have a valid cert in place _before_ we add a new DNS record.

Just like my old [dockerized-server](https:/github.com/McFateM/dockerized-server) configuration, this project revolves around a workflow that will setup a "Dockerized" server complete with _Traefik_, _Portainer_, and _Who Am I_. Like its predecessor, it should be relatively easy to add additional services or application stacks to any server that is initially configured using this package.  For "static" servers have a look at my [docker-bootstrap Workflow ](https://dlad.summittdweller.com/en/posts/posts/008-docker-bootstrap-workflow/) for an example.

| All of my associated research and testing for this issue can be found in a _OneTab_ at https://www.one-tab.com/page/9E_29YLjSGa9iAeckxMbIQ |
| --- |

To overcome the _HTTP-01 challenge_ issue mentioned above, a colleague of mine at _Grinnell College_ suggested we move to a _DNS-01 challenge_, and formulated a propsal to do so.

## DNS-01 Proposal

My colleague's proposal reads like this:

```
The proposed design uses CNAME following so that TXT records can be created for the grinnell.edu domain in a custom (non-grinnell.edu) domain.  On your side, the initial steps will be similar to what we do now.  When you need a new host record, a ticket should be created requesting example.grinnell.edu, and with a note that you will need Let’s Encrypt verification.  In order for CNAME following to work, a CNAME in the college’s external DNS must first be created.  This record will follow the format of _acme-challenge.example.grinnell.edu, and will point to a custom domain (le-verify.info or something similar).  We will register this custom domain name with Azure DNS and utilize a service principal account in Azure that will have permission to create TXT records in that custom domain.  We will then give you a key to that service principal account so that you can configure Traefik to create the TXT records automatically as a part of the Let’s Encrypt verification process.  When Let’s Encrypt goes to find the _acme-challenge.example.grinnell.edu record, it will be forwarded to the custom domain, see the TXT record, and then approve and sign the certificate for example.grinnell.edu.
 
I have tested this using an NGINX ingress controller, but the documentation for Traefik shows that it supports the same kind of configuration.
...
Here is some documentation that may explain things better than I have:
 
CNAME Following
https://letsencrypt.org/2019/10/09/onboarding-your-customers-with-lets-encrypt-and-acme.html
 
An Example Ingress Controller’s Implementation of DNS verification:
https://docs.traefik.io/https/acme/#dnschallenge
```

## April: DNS-01 Troubles

When attempting to implement the proposal outlined above we got back some odd errors. My record of the result can be found [in this Gist](https://gist.github.com/McFateM/095eb6cd798f8c9807de7e0c0024cf62).

## May: Moving to Traefik v2

All of the above material was generated using [My dockerized-server Config](https://dlad.summittdweller.com/en/posts/042-my-dockerized-server-config/) running [Traefik](https://traefik.io) version 1.x. Since the Traefik community has moved on it seemed prudent to try upgrading the server to Traefik v2.x before posting a lot of debug info involving the previous version. So, that's what I did, upgrade to Traefik 2.2.1.

## docker-traefik2-host

Our move to _Traefik v2.2.1_ is captured in a new Dockerized-server configuration I call [docker-traefik2-host](https://github.com/DigitalGrinnell/docker-traefik2-host). The key to obtaining certs in [docker-traefik2-host](https://github.com/DigitalGrinnell/docker-traefik2-host) lies in the [./traefik/data/traefik.yml](https://github.com/DigitalGrinnell/docker-traefik2-host/blob/master/traefik/data/traefik.yml) file and corresponding _.env_ file which is NOT stored in GitHub. _traefik.yml_ inlcudes a section of configuration like this:

```
# ## for HTTP-01 challeng
# certificatesResolvers:
#   http:
#     acme:
#       # - Uncomment caServer line below to run on the staging let's encrypt server.  Leave comment to go to prod.
#       caServer: https://acme-staging-v02.api.letsencrypt.org/directory
#       email: digital@grinnell.edu
#       storage: acme.json
#       httpChallenge:
#         entryPoint: http

## for DNS-01 challenge
certificatesResolvers:
 http:
   acme:
     # - Uncomment caServer line below to run on the staging Let's Encrypt server.  Leave comment to go to prod.
     #caServer: https://acme-staging-v02.api.letsencrypt.org/directory
     email: digital@grinnell.edu
     storage: acme.json
     dnsChallenge:
       provider: azure
```

The above configuration is intended to implement either an _HTTP-01_ or _DNS-01_ challenge, but never both. In the above example the host is being configured to use a _DNS-01_ challenge, and it uses the _Let's Encrypt_ production server since the "caServer" declaration of "staging" is commented out.

## Failure on Static.Grinnell.edu

Unfortunately, the configuration shown above, when applied to the _static.grinnell.edu_ host, failed even after being tweaked and tested several times. Along the way I eventually ran into _Let's Encrypt's_ rate limit and got shut out of further testing for one week. During that week I attempted to implement this configuration on a different host, namely _dgdocker3.grinnell.edu_, where I encountered different failures.

## Testing on DGDocker3.Grinnell.edu

_DGDocker3.Grinnell.edu_ is a CentOS 7.8 host running Docker with my [docker-traefik2-host](https://github.com/DigitalGrinnell/docker-traefik2-host) resident in `/opt/containers`. It sits behind the college firewall so VPN access is required, and it's configured to provide the following services:

| Stack and Service | Details | Address |
| ---               | ---     | ---     |
| landing-landing   | Dockerized Hugo static site | https://dgdocker3.grinnell.edu/ |
| traefik           | Traefik v2.2.1 with dashboard | https://dgdocker3.grinnell.edu/dashboard/ |
| portainer         | Portainer v1.23.2 dashboard | https://dgdocker3.grinnell.edu/portainer/ |

Each service has its own subdirectory and `docker-compose.yml` file located there. All can be found in [docker-traefik2-host](https://github.com/DigitalGrinnell/docker-traefik2-host). The all-important [./traefik/data/traefik.yml](https://github.com/DigitalGrinnell/docker-traefik2-host/blob/master/traefik/data/traefik.yml) is also there.

### Scripts

The [docker-traefik2-host](https://github.com/DigitalGrinnell/docker-traefik2-host) project also features a pair of scripts to help facilitate testing. They are:

| Script | Purpose |
| ---    | ---     |
| destroy.sh | Stops and removes all running containers, images and networks. Destroys the `./traefik/data/acme.json` file and restores it to pristine condition. |
| restart.sh | Restarts all the services with verbose (`--debug`) logs echoed from Traefik's `/var/log/traefik.log` file. |

### Test 1 - HTTP-01 Challenge Using LE's Staging Server

My first test will attempt a clean restart of all services using LE's **staging** CA-server and **HTTP-01 challenge**. The './traefik/data/traefik.yml' file for this test is reflected in [this gist](https://gist.github.com/McFateM/1d15b4e2bd992d1883de5f12e31dc6c3).

I initiated this test as _root_ using:

```
cd /opt/containers
./destroy.sh
./restart.sh
```

The result of this test shows all three services are working and are reachable via VPN at the addresses listed above, but **none have valid certs** so they all require an exception. This is to be expected when using LE's "staging" CA-server, but it seems there is more to this outcome since some errors are present.

The log and resulting _acme.json_ from this test can be seen in [this gist](https://gist.github.com/McFateM/dd5e7b016ccfd3d71b91f5c8602c3f33), and the first errors encountered state that:

```
time="2020-05-17T13:09:14-04:00" level=debug msg="http: TLS handshake error from 132.161.249.251:51447: remote error: tls: bad certificate"
time="2020-05-17T13:09:14-04:00" level=debug msg="http: TLS handshake error from 132.161.249.251:51448: remote error: tls: bad certificate"
```

| Since this test appears to have failed "unexpectedly", I'm going forego the next test that would attempt the same but using LE's "production" CA-server, and proceed straight to DNS-01 testing. |
| --- |

### Test 2 - DNS-01 Challenge Using LE's Staging Server

My next test will attempt a clean restart of all services using LE's **staging** CA-server and **DNS-01 challenge**. The './traefik/data/traefik.yml' file for this test is reflected in [this gist](https://gist.github.com/McFateM/4b093a4f7e0ba29723495f4a0458717f).


I initiated this test as _root_ using:

```
cd /opt/containers
./destroy.sh
./restart.sh
```

The result of this test shows all three services are working and are reachable via VPN at the addresses listed above, but **none have valid certs** so they all require an exception. This is to be expected when using LE's "staging" CA-server, but it seems there is more to this outcome since some errors are present.

The log from this test can be seen in [this gist](The result of this test shows all three services are working and are reachable via VPN at the addresses listed above, but **none have valid certs** so they all require an exception. This is to be expected when using LE's "staging" CA-server, but it seems there is more to this outcome since some errors are present.

The log from this test can be seen in [this gist](https://gist.github.com/McFateM/dd5e7b016ccfd3d71b91f5c8602c3f33), and the first error encountered states that:

```
time="2020-05-17T13:43:01-04:00" level=debug msg="No ACME certificate generation required for domains [\"dgdocker3.grinnell.edu\"]." providerName=http.acme routerName=traefik-secure@docker rule="Host(`dgdocker3.grinnell.edu`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))"
time="2020-05-17T13:43:01-04:00" level=debug msg="http: TLS handshake error from 132.161.249.251:52136: remote error: tls: bad certificate"
```

| Since this test appears to have failed in same "unexpected" manner as Test 1, I'm going forego subsequent tests until this can be resolved. |
| --- |

## Returning to Static.Grinnell.edu

Since more than a week has passed since I hit LE's rate limit, I thought that this evening I'd try my luck with `static.grinnell.edu` again, this time with an HTTP-01 challenge and LE's production server. It worked, except that some of my stack_service names were incorrect. What I really wanted to learn from this is what an `acme.json` file should look like when valid certs have been created. The answer can be found in [this gist](https://gist.github.com/McFateM/4f1524627a5ebbcbeae299d43d002640).

Note that I was ultimately able to get all the services on `static.grinnell.edu` working properly, with valid certs, by stopping (see below) those containers that had incorrect names, fixing the router's service name in each corresponding `docker-compose.yml`, then doing a new `docker-compose up -d` to restart things. No additional cert validation or modification of _Traefik_ was needed.

  - Stopping containers... `docker stop [id]; docker rm -v [id]`
  - Correct `service-stack` names... the correct name convention is `service-stack` where _service_ is the name of the service, not the container name, and _stack_ is the name of the sub-directory


And that's a good place to break... I'll be back to complete this post after a little more development and testing.  :smile:
