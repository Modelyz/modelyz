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

if [ "$1" == "-o" ]; then
    # TODO stripping does not work
    cabal build all $OPT_OPTIMIZE
    cabal install $OPT_OPTIMIZE $OPT_INSTALL
    #cabal v1-install -O2 --enable-split-objs --enable-executable-static --enable-executable-stripping --bindir=$INSTALLDIR
else
    cabal build all $OPT_DEVEL
    cabal install $OPT_DEVEL $OPT_INSTALL
fi

which cabal-cache && cabal-cache sync-to-archive --threads 4 --archive-uri s3://cabal-store.prelab.fr --host-name-override=s3.fr-par.scw.cloud --host-port-override=443 --host-ssl-override=True --region fr-par

popd
