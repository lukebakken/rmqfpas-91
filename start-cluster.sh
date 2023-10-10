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
readonly rmq_plugins_cmd="$rmq_sbin_dir/rabbitmq-plugins"
readonly rmq_ctl_cmd="$rmq_sbin_dir/rabbitmqctl"
readonly rmq_server_cmd="$rmq_sbin_dir/rabbitmq-server"

export RABBITMQ_NODENAME='rabbit1'
export RABBITMQ_CONFIG_FILE="$script_dir/rabbit1.conf"
"$rmq_plugins_cmd" enable rabbitmq_stream
"$rmq_server_cmd" -detached
sleep 5
"$rmq_ctl_cmd" await_startup
"$rmq_ctl_cmd" status
