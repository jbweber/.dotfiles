#!/bin/bash

sudo dnf install \
	git \
	jq \
	sqlite \
	stow \
	tmux \
	vim-enhanced \
	wget \
	zsh \
	ansible-core \
	ansible-collection-ansible-posix \
	python3-ansible-lint \
	sshpass

sudo chsh -s /bin/zsh jweber
