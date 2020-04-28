---
title: "Dockerized Traefik Host Using ACME DNS-01 Challenge"
publishdate: 2020-04-27
lastmod: 2020-04-27T16:15:20-05:00
draft: false
tags:
  - Docker
  - Traefik
  - Portainer
  - dockerized-server
  - traefik.frontend.rule
  - ACME
  - DNS-01
---

This post builds on [My dockerized-server Config](https://dlad.summittdweller.com/en/posts/042-my-dockerized-server-config/) and changes what was a problematic [ACME HTTP-01 or httpChallenge](https://docs.traefik.io/https/acme/#httpchallenge) in [Traefik](https://traefik.io) and [Let's Encrypt](https://letsencrypt.org) to an [ACME DNS-01 or dnsChallenge](https://docs.traefik.io/https/acme/#dnschallenge). The problem with the old _HTTP-01_ or _httpChallenge_ is that it requires the creation of a valid and widely accessible "A" record in our DNS _before_ the creation of a cert; the record has to be in place so that the _Let's Encrypt_ CA-server can find it to confirm that the request is valid.  However, doing this puts the cart-before-the-horse, so-to-speak, since we like to have a valid cert in place _before_ we put add a new DNS record.

Just like my old [dockerized-server](https:/github.com/McFateM/dockerized-server) configuration, this project revolves around a workflow that will setup a "Dockerized" server complete with _Traefik_, _Portainer_, and _Who Am I_. Like its predecessor, it should be relatively easy to add additional services or application stacks to any server that is initially configured using this package.  For "static" servers have a look at my [docker-bootstrap Workflow ](https://dlad.summittdweller.com/en/posts/posts/008-docker-bootstrap-workflow/) for an example.

And that's a good place to break... I'll be back to complete this post after a little development and testing.  :smile:
