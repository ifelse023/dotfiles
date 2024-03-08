#!/bin/bash

# Stop the execution if any command fails
set -e

bash setup.sh

# Execute packages.py (assuming it's a Python script)
python packages.py

# Execute uwf.sh
bash uwf.sh

# Execute misc.sh
bash misc.sh
