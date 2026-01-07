#!/bin/bash

COLUMNS=$(stty size | awk '{ print $2 }')
ROWS=$(stty size | awk '{ print $1 }')
echo ${USER}@$(hostname)
for i in $(seq 1 ${COLUMNS}); do echo -n "="; done

echo Terminal: ${ROWS}x${COLUMNS}
echo Kernel: $(uname -sr)
echo OS: $(lsb_release -ds)
echo CPU: $(uname -p)
