#!/bin/bash

scp data/eventstore.txt studio:/tmp/
ssh studio docker cp /tmp/eventstore.txt modelyz-studio-1:/srv/data/eventstore.txt
ssh studio docker restart modelyz-studio-1
