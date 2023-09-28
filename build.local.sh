#!/bin/bash

OPT_DEVEL='--ghc-options="-Wall"'
OPT_OPTIMIZE=' -O2 --ghc-options="-Wall" --enable-executable-stripping --enable-library-stripping --enable-executable-static'
INSTALLDIR=build
DATADIR=data
OPT_INSTALL="--installdir=$INSTALLDIR --overwrite-policy=always --install-method=copy"

set -e

pushd $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mkdir -p $INSTALLDIR
mkdir -p $DATADIR

[ -f ./dist-newstyle/cache/plan.json ] && which cabal-cache && cabal-cache sync-from-archive --threads 4 --archive-uri s3://cabal-store.prelab.fr --host-name-override=s3.fr-par.scw.cloud --host-port-override=443 --host-ssl-override=True --region fr-par

    cabal build message -O2 --ghc-options="-Wall" --enable-library-stripping
    cabal build studio store ident dumb -O2 --ghc-options="-Wall" --enable-library-stripping --enable-executable-static
    cabal install studio store ident dumb --installdir=build

which cabal-cache && cabal-cache sync-to-archive --threads 4 --archive-uri s3://cabal-store.prelab.fr --host-name-override=s3.fr-par.scw.cloud --host-port-override=443 --host-ssl-override=True --region fr-par

popd
