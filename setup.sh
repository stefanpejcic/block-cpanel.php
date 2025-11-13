#!/bin/bash

#1. get pwd - should be /root/block-cpanel.php
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#2. pull from https://github.com/stefanpejcic/block-cpanel.php
cd $SCRIPT_DIR && git pull

#3. run.sh to add it once
bash "$SCRIPT_DIR/run.sh"

#4. setup.sh to re-add it after every cpanel update
line_to_add="cd /root/block-cpanel.php/ && git pull ; bash /root/block-cpanel.php/setup.sh #https://github.com/stefanpejcic/block-cpanel.php"
if ! grep -qF "$line_to_add" /scripts/postupcp; then
  echo "Adding to /scripts/postupcp file.."
  echo "$line_to_add" >> /scripts/postupcp
else
  echo "Already added to /scripts/postupcp"
fi

echo "DONE"
