---
title: "Simplified Testing of Traefik 2 with ACME DNS-01 Challenge"
publishdate: 2020-05-19
draft: false
tags:
  - Docker
  - Traefik
  - ACME
  - DNS-01
  - docker-traefik2-host
  - docker-compose
---

This post is a simplified and focused follow-up to [Dockerized Traefik Host Using ACME DNS-01 Challenge](/en/posts/071-dockerized-traefik-using-acme-dns-01/).

## Simplify

Today, 19-May-2020, I'm going to take a shot at simplifying my testing on `dgdocker3.grinnell.edu` by removing unnecessary things and consolidating as much as possible to reduce clutter in the logs and get right to the point. I'm also going to have a look to see if there are additional logs that can tell give me more detail.  **Everything** used here, and everything that takes place here, will be found in a new directory, `/opt/containers/test` on _DGDocker3_.

And that's a good place to break, but I'll be baaaaak. :smile:
