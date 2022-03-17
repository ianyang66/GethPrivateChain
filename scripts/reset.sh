#!/bin/bash
location=`dirname $0`

rm -rf "$location/../data/geth"
"$location/init.sh"
"$location/run.sh"
