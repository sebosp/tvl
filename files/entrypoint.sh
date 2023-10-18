#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback to 9001, this only support group ID 1000

# The goal is to have a user with ID matching file-system level permission UID/GID
USER_ID=${LOCAL_USER_ID:-9001}
CNT_GROUPNAME="sre"
CNT_USERNAME="sre"

if grep -q 1000 /etc/group; then
    echo "Group 1001 already exists, skipping creation..."
    CNT_GROUPNAME=$(id -gn 1000)
else
    groupadd -g 1000 sre
    echo "Creating group 1000..."
fi

#echo "Starting with UID : $USER_ID"
if grep -q $USER_ID /etc/passwd; then
    echo "User $USER_ID already exists, skipping creation..."
    CNT_USERNAME=$(id -un 1000)
else
    useradd --shell /bin/bash -u $USER_ID -g 1000 -o -c "" -M -r $CNT_USERNAME
    echo "Creating user $USER_ID..."
fi

if [[ -d "/home/$CNT_USERNAME/work" ]]; then
	if [[ ! -f "/home/$CNT_USERNAME/work/.gitconfig" ]]; then
		touch /home/$CNT_USERNAME/work/.gitconfig
		git config --global --add alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit --all"
	fi
fi
touch /home/$CNT_USERNAME/.rnd
for config in .fzf .screenrc .bashrc .cargo .config .npm .local .rustup vendored; do [[ -e /root/$config ]] && mv /root/$config /home/$CNT_USERNAME/ && chown -R $CNT_USERNAME:$CNT_GROUPNAME /home/$CNT_USERNAME/$config;done

mkdir -p /home/$CNT_USERNAME/.cache
chown -R $CNT_USERNAME:$CNT_GROUPNAME /home/$CNT_USERNAME/.cache
chown $CNT_USERNAME:$CNT_GROUPNAME /home/$CNT_USERNAME/.rnd
exec gosu $CNT_USERNAME /bin/bash
