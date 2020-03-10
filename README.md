# blog-dlad

The GC Digital Library Application Developer's blog in Hugo using theme Zzo.

### History
  - 2020-03-10: Production launch after numerous changes committed.  Note addition of '/en' suffix in deployment below.
  - 2020-03-04: Launch of new blog using [Zzo theme](https://hugothemesfree.com/zzo-theme-for-hugo/). Initial `master` branch contains just a copy of the theme's `exampleSite` directory copied to the project root.

# Deploying this Blog

This blog is intended to be deployed using my [dockerized-server](https://github.com/McFateM/dockerized-server) approach, and the command stream used to launch [the blog](https://static.grinnell.edu/blogs/McFateM/en) on Grinnell College's `static.Grinnell.edu` server is:

```
NAME=blogs-mcfatem
HOST=static.grinnell.edu
IMAGE="mcfatem/blogs-mcfatem"
docker container run -d --name ${NAME} \
    --label traefik.backend=${NAME} \
    --label traefik.docker.network=web \
    --label "traefik.frontend.rule=Host:${HOST};PathPrefixStrip:/blogs/McFateM/en" \
    --label traefik.port=80 \
    --label com.centurylinklabs.watchtower.enable=true \
    --network web \
    --restart always \
    ${IMAGE}
```
