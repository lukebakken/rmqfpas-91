.PHONY: setup

HOSTNAME ?= $(shell hostname -s)

setup:
	sed -i'' -e "s#@@CURDIR@@#$(CURDIR)#g" -e "s#@@HOSTNAME@@#$(HOSTNAME)#g" inter_node_tls.config.in > inter_node_tls.config
