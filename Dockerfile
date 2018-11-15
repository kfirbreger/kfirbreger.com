FROM ubuntu:18.04 AS build

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y wget

# Installing hugo using binary
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.51/hugo_0.51_Linux-64bit.tar.gz
RUN tar xvzf hugo_0.51_Linux-64bit.tar.gz
RUN mv hugo /usr/local/bin/hugo

# Coping the source
RUN mkdir /site
COPY . /site/
WORKDIR /site
RUN cd /site

# Build the site
RUN hugo

# Create the nginx deployable container
FROM nginx:alpine

COPY --from=build /site/public/* /usr/share/nginx/html/

