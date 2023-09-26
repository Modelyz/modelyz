FROM haskell:9.2 AS build
#########################

ARG STORE=main
ARG STUDIO=main
ARG IDENT=main
ARG ELM=0.19.1

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

ADD cabal.project /srv/

ADD https://api.github.com/repos/Modelyz/message/git/refs/heads/$STORE message.json
RUN git clone --depth 1 --branch $STORE https://github.com/Modelyz/message

ADD https://api.github.com/repos/Modelyz/store/git/refs/heads/$STORE store.json
RUN git clone --depth 1 --branch $STORE https://github.com/Modelyz/store

ADD https://api.github.com/repos/Modelyz/studio/git/refs/heads/$STUDIO studio.json
RUN git clone --depth 1 --branch $STUDIO https://github.com/Modelyz/studio

ADD https://api.github.com/repos/Modelyz/ident/git/refs/heads/$IDENT ident.json
RUN git clone --depth 1 --branch $IDENT https://github.com/Modelyz/ident

ADD https://api.github.com/repos/Modelyz/dumb/git/refs/heads/$IDENT dumb.json
RUN git clone --depth 1 --branch $IDENT https://github.com/Modelyz/dumb

RUN cabal build message --enable-library-stripping --enable-executable-static --enable-executable-static
RUN cabal build store --enable-library-stripping --enable-executable-static --enable-executable-static
RUN cabal install store --installdir=store/build
RUN cabal build studio/back --enable-library-stripping --enable-executable-static --enable-executable-static
RUN cabal install studio/back --installdir=studio/build
RUN cabal build ident --enable-library-stripping --enable-executable-static --enable-executable-static
RUN cabal install ident --installdir=ident/build 
RUN cabal build dumb --enable-library-stripping --enable-executable-static --enable-executable-static
RUN cabal install dumb --installdir=dumb/build 

RUN cd studio/front  && ./build.sh -o


FROM debian:bullseye
####################

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gettext-base

RUN mkdir -p /srv/studio/data /srv/store/data /srv/ident/data /srv/dumb/data
COPY --from=build /srv/studio/build/ /srv/studio
COPY --from=build /srv/store/build/ /srv/store
COPY --from=build /srv/ident/build/ /srv/ident
COPY --from=build /srv/dumb/build/ /srv/dumb
COPY entrypoint.sh /srv/
WORKDIR /srv/
VOLUME /srv/store/data
VOLUME /srv/studio/data
VOLUME /srv/ident/data
VOLUME /srv/dumb/data
ENTRYPOINT ["/srv/entrypoint.sh"]
