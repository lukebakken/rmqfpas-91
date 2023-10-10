#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly script_dir
echo "[INFO] script_dir: '$script_dir'"

readonly rmq_version='3.11.23'
readonly rmq_dir="$script_dir/rabbitmq_server-$rmq_version"
readonly rmq_sbin_dir="$rmq_dir/sbin"
readonly rmq_ctl_cmd="$rmq_sbin_dir/rabbitmqctl"

export RABBITMQ_CONF_ENV_FILE="$script_dir/rabbitmq-env.conf"

set +o errexit
for node in rabbit1 rabbit2 rabbit3
do
    "$rmq_ctl_cmd" -n "$node" shutdown
done
