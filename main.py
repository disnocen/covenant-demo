import json
from bitcoinutils.setup import setup
from bitcoinutils.utils import to_satoshis
from bitcoinutils.transactions import Transaction, TxInput, TxOutput
from bitcoinutils.keys import P2pkhAddress, PrivateKey, P2shAddress, Address
from bitcoinutils.script import Script

# some differences are in order
# https://elementsproject.org/features/confidential-transactions


def main():
    # Open the JSON file and load its content into a dictionary
    with open('data.json', 'r') as file:
        json_content = file.read()
        tx_input_data = json.loads(json_content)

    file.close()

    # save the value of each key in the tx_input_data dictionary into a variable
    for key, value in tx_input_data.items():
        globals()[key] = value

    # VARIABLE:
    # input_priv_key
    # input_addr_conf
    # input_addr_unconf
    # miner_address
    # txhash
    # vout
    # output_priv_key
    # output_addr_conf
    # output_addr_unconf

    # always remember to setup the network
    setup('regtest')

    txin = TxInput(txhash, vout)

    input_priv_key2 = PrivateKey.from_wif(input_priv_key)

    # get the public key
    input_pub_key = input_priv_key2.get_public_key()

    # compressed is the default
    print("Public key:", input_pub_key.to_hex(compressed=True))

    # p2sh script for test:

    redeem_script = Script(
        ['OP_DUP', 'OP_HASH160', 'f4b4414ceeff04c60ee0a2bf7b6831ff4c213124', 'OP_EQUALVERIFY', 'OP_CHECKSIG'])
    # from script
    # get address from public key
    address = input_pub_key.get_address()
    address_p2sh = P2shAddress.from_script(
        redeem_script.to_p2sh_script_pub_key())
    address_segwit = input_pub_key.get_segwit_address()
    address_taproot = input_pub_key.get_taproot_address()

    # print the address and hash160 - default is compressed address
    print("Address new:", address.to_string())
    print("Address P2new:", address_p2sh.to_string())
    # print("Address S new:", address_segwit.to_string())
    # print("Address T new:", address_taproot.to_string())
    print("Address from data:", input_addr_unconf)
    print("Hash160:", address.to_hash160())

    print("\n--------------------------------------\n")

    # sign a message with the private key and verify it
    # message = "The test!"
    # signature = priv.sign_message(message)
    # print("The message to sign:", message)
    # print("The signature is:", signature)

    # if PublicKey.verify_message(address.to_string(), signature, message):
    #     print("The signature is valid!")
    # else:
    #     print("The signature is NOT valid!")


if __name__ == "__main__":
    main()
