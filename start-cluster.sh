#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly script_dir

hostname="$(hostname -s)"
readonly hostname

echo "[INFO] script_dir: '$script_dir'"
echo "[INFO] hostname: '$hostname'"

readonly rmq_version='3.11.23'
readonly rmq_dir="$script_dir/rabbitmq_server-$rmq_version"
readonly rmq_sbin_dir="$rmq_dir/sbin"
readonly rmq_plugins_cmd="$rmq_sbin_dir/rabbitmq-plugins"
readonly rmq_ctl_cmd="$rmq_sbin_dir/rabbitmqctl"
readonly rmq_server_cmd="$rmq_sbin_dir/rabbitmq-server"

# export LOG='debug'
# export RABBITMQ_ALLOW_INPUT='true'

export RABBITMQ_CONF_ENV_FILE="$script_dir/rabbitmq-env.conf"
export RABBITMQ_NODENAME='rabbit1'
export RABBITMQ_CONFIG_FILE="$script_dir/rabbit1.conf"
"$rmq_plugins_cmd" enable rabbitmq_stream rabbitmq_management rabbitmq_stream_management
"$rmq_server_cmd" -detached
sleep 5
"$rmq_ctl_cmd" -n "$RABBITMQ_NODENAME" await_startup
"$rmq_ctl_cmd" -n "$RABBITMQ_NODENAME" status

for idx in 2 3
do
    node="rabbit$idx"
    declare -i stream_port="$((5551 + idx))" # 5553 5554
    declare -i dist_port="$((25671 + idx))" # 25673 25674
    export RABBITMQ_NODENAME="$node"
    export RABBITMQ_DIST_PORT="$dist_port"
    export RABBITMQ_CONFIG_FILE="$script_dir/$node.conf"
    export RABBITMQ_SERVER_START_ARGS="-rabbitmq_stream tcp_listen_options [{port,$stream_port}] -rabbitmq_stream advertised_port $stream_port"
    "$rmq_server_cmd" -detached
    sleep 5
    "$rmq_ctl_cmd" await_startup
    "$rmq_ctl_cmd" status
    "$rmq_ctl_cmd" stop_app
    "$rmq_ctl_cmd" join_cluster "rabbit1@$hostname"
    "$rmq_ctl_cmd" start_app
done
