#!/bin/bash

VERSION=16

pushd ../studio
sed -i "s/export APPVERSION=../export APPVERSION=$VERSION" front/build.sh
sed -i "s/version:            .*/version:            0.$VERSION.0.0/" back/modelyz-studio.cabal
./build.sh
popd

pushd ../store
sed -i "s/version:            .*/version:            0.$VERSION.0.0/" modelyz-store.cabal
./build.sh
popd

pushd ../ident
sed -i "s/version:            .*/version:            0.$VERSION.0.0/" modelyz-ident.cabal
./build.sh
popd

pushd ../dumb
sed -i "s/version:            .*/version:            0.$VERSION.0.0/" modelyz-dumb.cabal
./build.sh
popd

for service in studio store ident dumb; do
    pushd ../$service
    git ci -a -m "new version $VERSION"
done

for service in studio store ident dumb; do
    pushd ../$service
    git push
done
