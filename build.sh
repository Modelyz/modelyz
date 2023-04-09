#/bin/bash

if [ "$1" == "--local" ]; then
    WSS="ws://localhost:8080"
elif [ "$1" == "--prod" ]; then
    DOMAIN=$2
    WSS="wss://$DOMAIN"
else
    echo "use --local or --prod <domain.tld>"
    exit 1
fi
docker build --target build --cache-from modelyz-build -t modelyz-build .
docker build --cache-from modelyz-build --build-arg WSS=$WSS -t rg.fr-par.scw.cloud/prelab/modelyz .
