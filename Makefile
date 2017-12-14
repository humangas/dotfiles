################################################################### 
# Installation tool for macOS setup
#
# See also: https://github.com/humangas/dotfiles
################################################################### 
DOTFILES := $(shell cat ./dotfiles.lst)
DOTFILESPATH := dotfiles
BASEPATH := roles

.DEFAULT_GOAL := help

.PHONY: all help install update dotfiles docs

all:

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "target:"
	@echo " - install:    \"setup\" command becomes available"
	@echo " - update:     Update dotfiles repository"
	@echo " - dotfiles:   Place the files in \"dotfiles.lst\" in the \"dotfiles\" directory"
	@echo " - docs:       Generate docs"
	@echo ""

install:
	@chmod u+x $(PWD)/roles/setup.sh
	@rm -f /usr/local/bin/setup
	@ln -s $(PWD)/roles/setup.sh /usr/local/bin/setup
	
update:
	@git pull origin master

dotfiles:
	@rm -rf $(DOTFILESPATH);
	@mkdir -p $(DOTFILESPATH);
	@for f in $(DOTFILES); do \
		if [ -e "./$(BASEPATH)/$$f" ]; then \
			echo "Copy dotfiles: $$f..."; \
			_dir=`dirname $$f | grep '/' | cut -d/ -f2-`; \
			mkdir -p "$(DOTFILESPATH)/$$_dir"; \
			cp -rf "./$(BASEPATH)/$$f" "$(DOTFILESPATH)/$$_dir"; \
		fi \
	done

docs:
	@bash scripts/docs.sh
