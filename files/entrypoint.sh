#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

#echo "Starting with UID : $USER_ID"
groupadd -g 1000 sre
useradd --shell /bin/bash -u $USER_ID -g 1000 -o -c "" -M -r sre

exec /usr/bin/gosu sre /bin/bash
