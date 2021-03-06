#!/bin/bash
#
# setup sftp project dir
#

if [[ -z ${1} ]]; then
    echo "${0} <project>"
    exit 1
fi

source $(dirname ${0})/../.env

proj=${1}

mkdir -p ${jail}/home/${proj}
chown -R root:root ${jail}/home/${proj}
chmod -R 640 ${jail}/home/${proj}

mkdir -p ${jail}/home/${proj}/data
chown -R ${proj}:${proj} ${jail}/home/${proj}/data
chmod -R 664 ${jail}/home/${proj}/data

mkdir -p ${jail}/data/external/${proj}
chown -R ${proj}:${proj} ${jail}/data/external/${proj}
mkdir -p ${jail}/data/external/${proj}/delivery
chown -R sftp:sftp ${jail}/data/external/${proj}/delivery
chmod -R 664 ${jail}/data/external/${proj}

if mount --bind ${jail}/data/external/${proj} ${jail}/home/${proj}/data; then
    echo ${jail}/data/external/${proj}$'\t'${jail}/home/${proj}/data$'\tnone\tbind\t0\t0' \
        | tee -a /etc/fstab
fi
