#/bin/bash

docker build --target build --cache-from modelyz-build -t modelyz-build .
docker build --cache-from modelyz-build -t rg.fr-par.scw.cloud/prelab/modelyz .
