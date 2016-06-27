# Etherpad-Lite Dockerfile
#
# https://github.com/ether/etherpad-docker
#
# Developed from a version by Evan Hazlett at https://github.com/arcus-io/docker-etherpad 
#
# Version 1.0

# Use Docker's nodejs, which is based on ubuntu
FROM node:latest
MAINTAINER John E. Arnold, iohannes.eduardus.arnold@gmail.com

# Get Etherpad-lite's other dependencies
RUN apt-get update
RUN apt-get install -y gzip git-core curl python libssl-dev pkg-config build-essential

# Grab the latest Git version
RUN cd /opt && git clone https://github.com/ether/etherpad-lite.git etherpad

# Install node dependencies
RUN /opt/etherpad/bin/installDeps.sh

EXPOSE 9001

# non-root user needs to be able create api key and install plugins on the first run
RUN chmod -R 777 /opt/etherpad

# skip supervisord in this deployment
WORKDIR /opt/etherpad
CMD ["node", "node_modules/ep_etherpad-lite/node/server.js"]

RUN ln -sf /secrets/apikey.txt /opt/etherpad/APIKEY.txt
RUN ln -sf /secrets/sessionkey.txt /opt/etherpad/SESSIONKEY.txt

# Add conf files
ADD settings.json /opt/etherpad/settings.json
RUN chmod -R 777 /opt/etherpad/settings.json
