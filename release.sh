#!/bin/bash
set -ex

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

for projects in deployment studio store ident dumb; do
    pushd ../$projects
    git ci -a -m "new version $VERSION"
done

for projects in deployment studio store ident dumb; do
    pushd ../$projects
    git push
done
