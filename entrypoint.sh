#!/bin/bash

if [ -z "$WSS" ]; then echo "WSS variable is not defined"; exit 1;fi
envsubst < /srv/studio/index.html > /tmp/index.html
cat /tmp/index.html > /srv/studio/index.html

exec "$@"
