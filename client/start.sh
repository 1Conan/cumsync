#!/bin/bash

# Your device's IP address
export DEVICE_IP=10.0.13.17
# this is fine
export SSH_USERNAME=mobile
# change this ffs
export SSH_PASSWORD=alpine

# uncomment this if you wanna use ssh keys
# export SSH_PRIVATEKEY=/home/conan/.ssh/id_rart
# uncomment this if your ssh key has a passphrase
# export SSH_PRIVATEKEY_PASSPHRASE=alpine

./client