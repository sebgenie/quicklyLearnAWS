#!/bin/bash
# create python environment
python3 -m venv .qla 

# activate the environment
source .qla/bin/activate 

# install the requirements
pip3 install -r requirement.txt 

