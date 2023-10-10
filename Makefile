.PHONY: setup

HOSTNAME ?= $(shell hostname -s)

setup:
	sed -e "s#@@CURDIR@@#$(CURDIR)#g" -e "s#@@HOSTNAME@@#$(HOSTNAME)#g" $(CURDIR)/inter_node_tls.config.in > $(CURDIR)/inter_node_tls.config
	sed -e "s#@@CURDIR@@#$(CURDIR)#g" -e "s#@@HOSTNAME@@#$(HOSTNAME)#g" $(CURDIR)/rabbit1.conf.in > $(CURDIR)/rabbit1.conf
	sed -e "s#@@CURDIR@@#$(CURDIR)#g" -e "s#@@HOSTNAME@@#$(HOSTNAME)#g" $(CURDIR)/rabbit2.conf.in > $(CURDIR)/rabbit2.conf
	sed -e "s#@@CURDIR@@#$(CURDIR)#g" -e "s#@@HOSTNAME@@#$(HOSTNAME)#g" $(CURDIR)/rabbit3.conf.in > $(CURDIR)/rabbit3.conf
	sed -e "s#@@CURDIR@@#$(CURDIR)#g" $(CURDIR)/rabbitmq-env.conf.in > $(CURDIR)/rabbitmq-env.conf
