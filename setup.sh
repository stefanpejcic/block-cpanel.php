#!/bin/bash

bash run.sh

line_to_add="cd /root/block-cpanel.php/ && git pull ; bash /root/block-cpanel.php/setup.sh #https://github.com/stefanpejcic/block-cpanel.php"

if ! grep -qF "$line_to_add" /scripts/postupcp; then
  echo "$line_to_add" >> /scripts/postupcp
fi
