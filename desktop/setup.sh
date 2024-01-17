#!/bin/sh

. ./utils.sh

# TODO Make this not hardcoded...
# step "Installing the custom desktop suite (suckless)..."
# cd "$repositories_location"
# for soft in dmenu dwm st
# do
# 	if has $soft; then
# 		info "$soft is already installed"
# 		continue
# 	fi
# 	call git clone https://github.com/duketuxem/"$soft".git -b my_fork \
# 		&& cd $soft \
# 		&& call "$privilege_escalation" make install \
# 		&& success "$soft successfully installed!\n" \
# 		&& git remote set-url origin git@github.com:duketuxem/$soft.git \
# 		&& success "Repository set to use SSH." \
# 		&& cd ..
# done

