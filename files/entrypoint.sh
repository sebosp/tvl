#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

#echo "Starting with UID : $USER_ID"
groupadd -g 1000 sre
useradd --shell /bin/bash -u $USER_ID -g 1000 -o -c "" -M -r sre

if [[ -d "/home/sre/work" ]]; then
	if [[ ! -d "/home/sre/work/.aws" ]]; then
		echo "Missing host's .aws directory, creating..."
		mkdir /home/sre/work/.aws
		chmod 700 /home/sre/work/.aws
	fi
	if [[ ! -d "/home/sre/work/.kube" ]]; then
		echo "Missing host's .kube directory, creating..."
		mkdir /home/sre/work/.kube
		chmod 700 /home/sre/work/.aws
	fi
	if [[ ! -f "/home/sre/work/.gitconfig" ]]; then
		echo "Missing host's .gitconfig file, please run: ";
		echo '$ git config --global user.name "John Doe"'
		echo '$ git config --global user.email johndoe@example.com"'
		touch /home/sre/work/.gitconfig
	fi
fi

exec /usr/bin/gosu sre /bin/bash
