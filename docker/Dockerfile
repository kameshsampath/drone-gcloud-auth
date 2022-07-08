FROM --platform=linux/amd64 gcr.io/google.com/cloudsdktool/google-cloud-cli:alpine
LABEL org.opencontainers.image.source https://github.com/kameshsampath/drone-gcloud-auth
LABEL org.opencontainers.image.authors="Kamesh Sampath<kamesh.sampath@hotmail.com>"

LABEL description="A Drone plugin to initialize gcloud authentication"

RUN apk -Uuv add curl ca-certificates

RUN adduser --system --uid 1001 -G root dev \
    && mkdir -p  /home/dev/.config/gcloud \
    && chown 1001:0  /home/dev/.config/gcloud

ADD run.sh /bin/
RUN chmod +x /bin/run.sh

USER dev

CMD ["/bin/run.sh"]