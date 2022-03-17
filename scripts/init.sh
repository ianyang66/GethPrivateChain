#!/bin/bash
location=`dirname $0`
target="$location/../data/"

geth --datadir $target init "$location/../genesis.json"
