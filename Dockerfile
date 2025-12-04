FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
   apt-get install -qyy \
    -o APT::Install-Recommendis=false -o APT::Install-Suggests=false \
    make \
    texlive-xetex

ADD https://github.com/jgm/pandoc/releases/download/3.1.12/pandoc-3.1.12-1-amd64.deb /tmp/pandoc.deb

RUN dpkg -i /tmp/pandoc.deb

WORKDIR /workspace

ENTRYPOINT ["make"]
