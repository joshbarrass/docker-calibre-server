FROM ubuntu:18.04

ARG VERSION=4.17.0

# install dependencies
RUN apt-get update \
  && apt-get install -y python wget tar xz-utils xvfb imagemagick libnss3 \
  && rm -rf /var/lib/apt/lists/*


# get glibc
#RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
#  && wget -q -O /tmp/glibc-2.31-r0.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-2.31-r0.apk \
#  && apk add --no-cache /tmp/glibc-2.31-r0.apk

# install calibre
RUN wget -q -O /tmp/calibre.txz https://download.calibre-ebook.com/$VERSION/calibre-$VERSION-x86_64.txz \
  && mkdir -p /opt/calibre \
  && rm -rf /opt/calibre/* \
  && tar xf /tmp/calibre.txz -C /opt/calibre \
  && rm /tmp/calibre.txz

# prepare post-install
WORKDIR /opt/calibre
RUN /opt/calibre/calibre_postinstall > /dev/null
COPY run.sh run.sh
RUN chmod +x run.sh

# set up library and configs
VOLUME /library
VOLUME /config
VOLUME /books

EXPOSE 8080
ENTRYPOINT ["./run.sh"]