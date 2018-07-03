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
		chmod 700 /home/sre/work/.kube
	fi
	if [[ ! -d "/home/sre/work/.minikube" ]]; then
		echo "Missing host's .minikube directory, creating..."
		mkdir /home/sre/work/.minikube
		chmod 700 /home/sre/work/.minikube
	elif [[ -e /home/sre/work/.kube/config ]]; then
		# The paths in minikube are absolute, we need to create the fake root hierarchy then:
		minikubeHome=$(grep minikube /home/sre/work/.kube/config |grep client-cert|cut -d: -f2|cut -d' ' -f2|sed 's/\.minikube.*$//');
		if [[ ! -z "$minikubeHome" ]]; then
			mkdir -p $minikubeHome
			ln -s /home/sre/work/.minikube ${minikubeHome}/.minikube 
		fi
	fi
	if [[ ! -d "/home/sre/work/.ansible" ]]; then
		echo "Missing host's .ansible directory, creating..."
		mkdir /home/sre/work/.ansible
#		chmod 700 /home/sre/work/.ansible
	fi
	if [[ ! -f "/home/sre/work/.gitconfig" ]]; then
		echo "Missing host's .gitconfig file, please run: ";
		echo '$ git config --global user.name "John Doe"'
		echo '$ git config --global user.email johndoe@example.com"'
		touch /home/sre/work/.gitconfig
		git config --global --add alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit --all"
	fi
	if [[ ! -d "/home/sre/.m2/repository" ]]; then
		mkdir -p /home/sre/.m2/repository
		chown -R sre:sre /home/sre/.m2
        fi
	if [[ -d "/home/sre/.helm" ]]; then
		chown -R sre:sre /home/sre/.helm
        fi
	if [[ ! -d "/home/sre/work/.ssh" ]]; then
		mkdir /home/sre/work/.ssh
		chmod 700 /home/sre/work/.ssh
	fi
	ln -s /home/sre/work/.ansible /home/sre/.ansible
	ln -s /home/sre/work/.virtualenvs /home/sre/.virtualenvs
fi
touch /home/sre/.rnd
chown sre:sre /home/sre/.rnd
exec /usr/bin/gosu sre /bin/bash
