#!/bin/sh

# here a llist of the rpc:
# https://elementsproject.org/en/doc/22.0.0/rpc/

# environment created following : https://elementsproject.org/elements-code-tutorial/working-environment

source ./env

alias b-dae="bitcoind -datadir=$HOME/bitcoindir"
alias b-cli="bitcoin-cli -datadir=$HOME/bitcoindir"
alias e1-dae="elementsd -datadir=$HOME/elementsdir1"
alias e1-cli="elements-cli -datadir=$HOME/elementsdir1"
alias e2-dae="elementsd -datadir=$HOME/elementsdir2"
alias e2-cli="elements-cli -datadir=$HOME/elementsdir2"
alias e1-qt="elements-qt -datadir=$HOME/elementsdir1"
alias e2-qt="elements-qt -datadir=$HOME/elementsdir2"

e1-cli stop
sleep 1

# remove old demos
rm -rf $HOME/elementsdir1
cp -r ./bootstrap_data/elementsdir1 $HOME

# from https://elementsproject.org/elements-code-tutorial/blockchain
STANDALONEARGS=("-validatepegin=0" "-defaultpeggedassetname=newasset" "-initialfreecoins=1000000000000000" "-initialreissuancetokens=200000000" "-addresstype=legacy")
e1-dae ${STANDALONEARGS[@]}

sleep 1

# Now we need to create default wallets and rescan the blockchain:
e1-cli createwallet ""
e1-cli rescanblockchain


function create_new_address() {
    rand=$(echo $RANDOM)
    new_addr=$(e1-cli getnewaddress "" legacy)
    echo $new_addr 
}

echo "{" > data.json

# get new address; print it and save it

miner_address=$(create_new_address)
e1-cli generatetoaddress 101 $miner_address
e1-cli getwalletinfo
input_addr_conf=$(create_new_address)
input_addr_unconf=$(e1-cli getaddressinfo $input_addr_conf | jq .unconfidential) # returns with ""
input_priv_key=$(e1-cli dumpprivkey $input_addr_conf)
echo the privatekey: $input_priv_key
echo "    \"input_priv_key\" : \"$input_priv_key\"," >> data.json
echo the address: $new_addr
echo "    \"input_addr_conf\" : \"$input_addr_conf\"," >> data.json
echo "    \"input_addr_unconf\" : $input_addr_unconf," >> data.json
echo "    \"miner_address\" : \"$miner_address\"," >> data.json

new_tx=$(e1-cli sendtoaddress $input_addr_conf  1 "" "" true)
e1-cli generatetoaddress 1 $miner_address
echo the tx hash: $new_tx
echo "    \"txhash\" : \"$new_tx\"," >> data.json


#  e1-cli getaddressinfo CTEuRWNa1W28HAxsdVh3ipsquTroCF1sWnKZu3kQUL6S3Lpq3Eta7kTxiH7at78DiTbyyBwicTxuYEEk|jq .pubkey    to get pubkey and other infoo

# inspect the transaction hash
vout=$(e1-cli gettxout $new_tx  1 |jq .scriptPubKey.asm |grep -q OP_DUP && echo 1 || echo 0)
tx_data=$(e1-cli gettxout $new_tx $vout)
echo "    \"vout\" : \"$vout\"," >> data.json
echo the vout is: $vout
echo $tx_data|jq




output_addr_conf=$(create_new_address)
output_addr_unconf=$(e1-cli getaddressinfo $output_addr_conf | jq .unconfidential) # returns with ""
output_priv_key=$(e1-cli dumpprivkey $output_addr_conf)
echo "    \"output_priv_key\" : \"$output_priv_key\"," >> data.json
echo "    \"output_addr_conf\" : \"$output_addr_conf\"," >> data.json
echo "    \"output_addr_unconf\" : $output_addr_unconf" >> data.json



echo "}" >> data.json

