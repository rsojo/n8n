#!/bin/sh

# This script is executed when the container is started.
# It can be used to install additional node modules.

# For example, to install the n8n-nodes-base64 node:
# npm install n8n-nodes-base64

# You can add more npm install commands here.

# Do not start n8n here; the official entrypoint will start n8n after running init scripts.
exit 0
