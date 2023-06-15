import json
from bitcoinutils.setup import setup
from bitcoinutils.keys import P2pkhAddress, PrivateKey, PublicKey


def main():
    # Open the JSON file and load its content into a dictionary
    with open('data.json', 'r') as file:
        json_content = file.read()
        tx_input_data = json.loads(json_content)

    file.close()

    # Print the value of each key in the tx_input_data dictionary
    for key, value in tx_input_data.items():
        globals()[key] = value

    # always remember to setup the network
    setup('regtest')

    priv = PrivateKey.from_wif(input_priv_key)

    # get the public key
    pub = priv.get_public_key()

    # compressed is the default
    print("Public key:", pub.to_hex(compressed=True))

    # get address from public key
    address = pub.get_address()

    # print the address and hash160 - default is compressed address
    print("Address new:", address.to_string())
    print("Address from data:", input_addr_unconf)
    # print("Hash160:", address.to_hash160())

    # print("\n--------------------------------------\n")

    # # sign a message with the private key and verify it
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
