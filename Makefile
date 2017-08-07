DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .git 
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))


.DEFAULT_GOAL := help

all:

deploy:
	@$(foreach val, $(DOTFILES), ln -svf $(abspath $(val)) $(HOME)/$(val);)

