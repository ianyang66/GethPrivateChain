#!/bin/bash
location=`dirname $0`
target="$location/../data/"

geth --mine --datadir $target --nodiscover --identity "mainNode" --networkid 9351 --rpcapi="eth, net, web3, personal, miner" --rpc --rpcaddr "0.0.0.0" --rpccorsdomain "*"
