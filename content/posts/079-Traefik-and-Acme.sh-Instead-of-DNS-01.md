---
title: "Traefik and Acme.sh Instead of DNS-01"
publishdate: 2020-06-02
draft: false
tags:
  - Docker
  - Traefik
  - ACME
  - DNS-01
  - docker-traefik2-host
  - docker-compose
---

This post is a follow-up to [Dockerized Traefik Host Using ACME DNS-01 Challenge](/en/posts/071-dockerized-traefik-using-acme-dns-01).  It introduces an alternative to the failed process that was proposed in that earlier post.

> Note that the following config-specific elements have been replaced below:
>   - 6 occurances of `?.grinnell.edu` now say `example-1.grinnell.edu`, and
>   - 2 occurances of `?.info` now say `example-2.info`.

## New Proposal

On June 1 my colleage, Matt, suggested the following...

> As much as I would like to resolve the DNS-01 challenge using Traefik alone, I don't believe it will support what we're trying to do here.  I'm a bit disappointed by that as Nginx makes this process very easy, and my reading through the Traefik documentation and my own tests lead me to believe that CNAME following is not currently supported in Traefik, and is basically impossible.  Until the they allow for the verification domain to be specified as a provider option (in this case, specifying example-2.info as the domain for the Azure DNS provider), using the built-in ACME functionality in Traefik won't work, no matter which DNS provider is in use.
>
> However, I believe I have a solution.  Acme.sh is another tool that is commonly used to generate certificates using Let's Encrypt and the ACME protocol, and it does support domain aliasing.  There is a containerized version of this, and I was able to build a docker-compose file that launches Traefik, a simple Whoami app, and the acme.sh container for creating certificates using the DNS-01 challenge.  It's not fully automated in that you have to run a docker exec command after the first run, but I think automating that part of it should be possible.  The acme.sh container will renew certificates every 60 days as long as the acme.sh container is running.  Traefik is configured to watch the certificate directory for changes and will reload when the certificate is renewed.

> It's a fairly simple set up and I hope it can work for your use case.


```yaml
version: "3.3"

services:

  acme:
    image: neilpang/acme.sh:latest
    volumes:
      - ./certs:/certs
    environment:
      # Azure
      - AZUREDNS_SUBSCRIPTIONID=
      - AZUREDNS_TENANTID=
      - AZUREDNS_APPID=
      - AZUREDNS_CLIENTSECRET=

    command: daemon
    container_name: acme


  traefik:
    image: "traefik:v2.2.1"
    container_name: "traefik"
    command:
      # --log.level=DEBUG
      --api.insecure=true
      --providers.docker=true
      --providers.docker.exposedbydefault=false
      --providers.file.directory=/certs/
      --providers.file.watch=true
      --entrypoints.web.address=:80
      --entrypoints.websecure.address=:443

    ports:
      - 80:80
      - 443:443
      - 8080:8080

    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./letsencrypt:/letsencrypt
      - ./certs/:/certs/

  whoami:
    image: containous/whoami
    container_name: simple-service
    labels:
      traefik.enable: "true"
      traefik.http.routers.whoami.rule: "Host(`example-1.grinnell.edu`)"
      traefik.http.routers.whoami.entrypoints: "websecure"
      traefik.http.routers.whoami.tls: "true"
```

> In my 'certs' directory, I have a certs.toml file with this:

```toml
[[tls.certificates]]
    certFile = "/certs/example-1.grinnell.edu.cert"
    keyFile = "/certs/example-1.grinnell.edu.key"
```
>
> Just add an additional [[tls.certificates]] section for every additional certificate you will want generated.

> Netcentos is the name of my test machine, so just change that where you see it.
>
> You will also want to move your Azure environment variables from the Traefik section to the Acme.sh container section (without quotes).
>
> After running docker-compose up -d, you will need to run the acme.sh command within the container once, changing the hostname for your own.  If you want an additional hostname include another -d flag and then the FQDN.

```
docker exec -it acme --issue --dns dns_azure -d example-1.grinnell.edu --domain-alias _acme-challenge.example-2.info --key-file /certs/example-1.grinnell.edu.key --cert-file /certs/example-1.grinnell.edu.cert --standalone
```
>
> Here's the documentation that I followed to get here, but feel free to send me questions if you have any.
>
> - https://containo.us/blog/traefik-2-tls-101-23b4fbee81f1/
> - https://github.com/acmesh-official/acme.sh/wiki/DNS-alias-mode
> - https://hub.docker.com/r/neilpang/acme.sh

## McFateM/docker-traefik2-acme-host

I started work on this proposal by cloning [https://github.com/DigitalGrinnell/docker-traefik2-host](https://github.com/DigitalGrinnell/docker-traefik2-host), reinitializing it, and pushing back an unmodified new copy to [https://github.com/McFateM/docker-traefik2-acme-host](https://github.com/McFateM/docker-traefik2-acme-host).


And that's a good place to break...  :smile:
