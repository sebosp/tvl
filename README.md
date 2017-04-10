[![Docker Repository on Quay](https://quay.io/repository/sebosp/tvl/status?token=84ddb0a8-9059-4c43-9125-6d3949ad3e7f "Docker Repository on Quay")](https://quay.io/repository/sebosp/tvl)
# tvl 0.0.8
Docker setup with my common work tools for Infrastructure As Code, Configuration Management, vIM

| Base | version | size |
| --- | --- | --- |
|Alpine3.5 | 0.0.8 | 489 MB|
|Alpine3.5 | 0.0.7 | 518 MB|
|Alpine3.5 | 0.0.6 | 796 MB|
|Debian8.7 | 0.0.5 | 657 MB|

Part of the motivation for using alpine was passing quay.io security tests.
The Debian based had 99 vulnerabilities, whereas alpine passes.
Debian package has 150 packages, alpine ends up with with 91 packages.

## Tools versions
| Tool | version |
| --- | --- |
| puppet | 4.8.2 |
| facter | 2.4.6 |
| terraform | 0.9.1 |
| packer | 0.12.3 |
| kubectl | 1.6.1 |

## Pulling
```bash
$ docker pull sebosp/tvl:0.0.8
```

- Vim (With PaperColor, syntastic, airline, pathogen, etc)
- Ansible
- Terraform
- Packer
- AWS CLI
- Git
- Git-flow
- Bash with git-prompt setup
- kubectl for kubernetes.

## Running
```bash
 # If you want to have history for docker separately, do this:
$ touch $HOME/.docker_bash_hist
 # Otherwise, you can do this to have bash_history shared
$ ln -s $HOME/.bash_history $HOME/.docker_bash_hist
$ docker run --rm -v $HOME/:/home/sre/work/ -e LOCAL_USER_ID=`id -u $USER` -it sebosp/tvl:0.0.8 /bin/bash
```

## Workarounds

### AWS login fails
Sometimes the clock synchronization with the OS is broken due to sleep)
- Docker for Mac: internal clock doesn't update on docker images after sleep. Woraround:
```shell
$ brew install sleepwatcher
$ brew services start sleepwatcher
$ echo /usr/local/bin/docker run --rm --privileged alpine hwclock -s > ~/.wakeup
$ chmod +x ~/.wakeup
```

## Current issues
- git diff opens up LESS even when the output is less than a page.
  When setting -F less won't open at all (regardless of output length).
  I suspect this could somethig to do with TERM capabilities,size,etc...

## TODO
- mount docker socket so that we can manage Docker within Docker?
