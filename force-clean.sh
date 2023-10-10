#!/bin/bash

set -o xtrace

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly script_dir

readonly rmq_version='3.11.23'

killall -9 beam.smp
killall -9 epmd
rm -rf "$script_dir/rabbitmq_server-$rmq_version/var/lib/rabbitmq/mnesia/"*
rm -vf "$script_dir/rabbitmq_server-$rmq_version/etc/rabbitmq/enabled_plugins"
