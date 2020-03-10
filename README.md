# dlad-blog

The GC Digital Library Application Developer's blog in Hugo using theme Zzo.

### History
  - 2020-03-10: Production launch after numerous changes committed.  Moving to _DigitalOcean_ in deployment below.
  - 2020-03-04: Launch of new blog using [Zzo theme](https://hugothemesfree.com/zzo-theme-for-hugo/). Initial `master` branch contains just a copy of the theme's `exampleSite` directory copied to the project root.

# Deploying this Blog

This blog is intended to be deployed using my [dockerized-server](https://github.com/McFateM/dockerized-server) approach, and the command stream used to launch [the blog](https://dlad.summittdweller.com) on my `summitt-dweller-DO-docker` droplet at _DigitalOcean_:

```
NAME=dlad-blog
HOST=dlad.summittdweller.com
IMAGE="mcfatem/dlad-blog"
docker container run -d --name ${NAME} \
    --label traefik.backend=${NAME} \
    --label traefik.docker.network=web \
    --label "traefik.frontend.rule=Host:${HOST}" \
    --label traefik.port=80 \
    --label com.centurylinklabs.watchtower.enable=true \
    --network web \
    --restart always \
    ${IMAGE}
```
