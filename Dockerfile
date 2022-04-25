FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -qyy \
     -o APT::Install-Recommendis=false -o APT::Install-Suggests=false \
     build-essential \
     texlive-xetex \
     pdftk

ADD https://github.com/jgm/pandoc/releases/download/2.17.1.1/pandoc-2.17.1.1-1-amd64.deb /tmp/pandoc-2.17.1.1-1-amd64.deb

RUN dpkg -i /tmp/pandoc-2.17.1.1-1-amd64.deb

WORKDIR /workspace

ENTRYPOINT ["make"]
