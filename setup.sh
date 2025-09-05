#!/bin/bash

sudo dnf install \
	zsh \
	git \
	stow \
	tmux \
	vim-enhanced \
	ansible-core \
	ansible-collection-ansible-posix

sudo chsh -s /bin/zsh jweber
