#!/bin/bash
set -x

MESSAGE=1
STUDIO=17
STORE=1
IDENT=1
DUMB=1

pushd ../message
sed -i "s/version:            .*/version:            0.$MESSAGE.0.0/" modelyz-message.cabal
./build.sh
git diff-index --quiet HEAD -- || git ci -a -m "new version $MESSAGE"
git tag | grep ^$MESSAGE$ || git tag $MESSAGE
popd

pushd ../studio
sed -i "s/export APPVERSION=.*/export APPVERSION=$STUDIO/" front/build.sh
sed -i "s/version:            .*/version:            0.$STUDIO.0.0/" back/modelyz-studio.cabal
./build.sh
git diff-index --quiet HEAD -- || git ci -a -m "new version $STUDIO"
git tag | grep ^$STUDIO$ || git tag $STUDIO
popd

pushd ../store
sed -i "s/version:            .*/version:            0.$STORE.0.0/" modelyz-store.cabal
./build.sh
git diff-index --quiet HEAD -- || git ci -a -m "new version $STORE"
git tag | grep ^$STORE$ || git tag $STORE
popd

pushd ../ident
sed -i "s/version:            .*/version:            0.$IDENT.0.0/" modelyz-ident.cabal
./build.sh
git diff-index --quiet HEAD -- || git ci -a -m "new version $IDENT"
git tag | grep ^$IDENT$ || git tag $IDENT
popd

pushd ../dumb
sed -i "s/version:            .*/version:            0.$DUMB.0.0/" modelyz-dumb.cabal
./build.sh
git diff-index --quiet HEAD -- || git ci -a -m "new version $DUMB"
git tag | grep ^$DUMB$ || git tag $DUMB
popd


for projects in message studio store ident dumb deployment; do
    pushd ../$projects
    git push
    git push --tags
done
