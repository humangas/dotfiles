################################################################### 
# Installation tool for macOS setup
#
# See also: https://github.com/humangas/dotfiles
################################################################### 
.DEFAULT_GOAL := help

.PHONY: all help install update

all:

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "target:"
	@echo " - install:   \"setup\" command becomes available"
	@echo " - update:    Update dotfiles repository"
	@echo ""

install:
	@chmod u+x $(PWD)/roles/setup.sh
	@rm -f /usr/local/bin/setup
	@ln -s $(PWD)/roles/setup.sh /usr/local/bin/setup
	
update:
	@git pull origin master
