#!/bin/bash

# NB: do brew install jq, on mac or sudo apt-get install jq on ubuntu

# create python environment
python3 -m venv .qla 

# activate the environment
source .qla/bin/activate 

# install the requirements
pip3 install -r requirement.txt 

# run the deployment script
cd basic_aws_S3/
sh script.sh