#!/bin/sh

# environment created following : https://elementsproject.org/elements-code-tutorial/working-environment
source ./aliases.sh

# from https://elementsproject.org/elements-code-tutorial/blockchain
STANDALONEARGS=("-validatepegin=0" "-defaultpeggedassetname=newasset" "-initialfreecoins=100000000000000" "-initialreissuancetokens=200000000")
e1-dae ${STANDALONEARGS[@]}
e2-dae ${STANDALONEARGS[@]}

# remove old demos
rm -rf ~/elementsdir1/elementsregtest
rm -rf ~/elementsdir2/elementsregtest

# Now we need to create default wallets and rescan the blockchain:
e1-cli createwallet ""
e2-cli createwallet ""
e1-cli rescanblockchain
e2-cli rescanblockchain