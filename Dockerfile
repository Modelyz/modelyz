FROM haskell:9.2 AS build
#########################

ARG STORE=main
ARG STUDIO=main
ARG IDENT=main
ARG ELM=0.19.1
ARG WSS
ENV WSS $WSS

WORKDIR /srv
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gettext-base \
        git \
        gzip \
        markdown \
        npm \
        rsync \
        uglifyjs \
    && curl -L -o elm.gz https://github.com/elm/compiler/releases/download/$ELM/binary-for-linux-64-bit.gz \
    && gunzip elm.gz \
    && chmod +x elm \
    && mv elm /usr/local/bin/ \
    && cabal update

ADD https://api.github.com/repos/Modelyz/message/git/refs/heads/$STORE message.json
RUN git clone --depth 1 --branch $STORE https://github.com/Modelyz/message \
    && cd message \
    && ./build.sh -o \
    && cd ..

ADD https://api.github.com/repos/Modelyz/store/git/refs/heads/$STORE store.json
RUN git clone --depth 1 --branch $STORE https://github.com/Modelyz/store \
    && cd store \
    && ./build.sh -o \
    && cd ..

ADD https://api.github.com/repos/Modelyz/studio/git/refs/heads/$STUDIO studio.json
RUN git clone --depth 1 --branch $STUDIO https://github.com/Modelyz/studio \
    && cd studio \
    && ./build.sh \
    && cd ..

ADD https://api.github.com/repos/Modelyz/ident/git/refs/heads/$IDENT ident.json
RUN git clone --depth 1 --branch $IDENT https://github.com/Modelyz/ident \
    && cd ident \
    && ./build.sh -o \
    && cd ..


FROM debian:bullseye
####################

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN mkdir -p /srv/studio/data /srv/store/data /srv/ident/data
COPY --from=build /srv/studio/build/ /srv/studio
COPY --from=build /srv/store/build/ /srv/store
COPY --from=build /srv/ident/build/ /srv/ident
WORKDIR /srv/
VOLUME /srv/data
