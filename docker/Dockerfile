#syntax=docker/dockerfile:1.3-labs

FROM node:lts-alpine
LABEL org.opencontainers.image.source https://github.com/kameshsampath/drone-release-please
LABEL org.opencontainers.image.authors="Kamesh Sampath<kamesh.sampath@hotmail.com>"

ARG TARGETARCH

LABEL description="A Drone plugin to create releases using googleapis/release-please"

RUN apk -Uuv add curl ca-certificates git bash

RUN npm i --location=global release-please

ADD run.sh /bin/
RUN chmod +x /bin/run.sh

CMD ["/bin/run.sh"]