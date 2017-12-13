[![Docker Repository on Quay](https://quay.io/repository/sebosp/tvl/status?token=84ddb0a8-9059-4c43-9125-6d3949ad3e7f "Docker Repository on Quay")](https://quay.io/repository/sebosp/tvl)
# tvl 1.0.7
[![tvl asciicast](https://asciinema.org/a/119550.png)](https://asciinema.org/a/119550)

Docker setup with my common work tools for Infrastructure As Code, Configuration Management, vIM

| Base | version | size |
| --- | --- | --- |
|Alpine3.7 | 1.0.7 | 1. GB 0.0.9 + perl)|
|Alpine3.5 | 0.0.9 | 1.15 GB (Adding Go and YouCompleteMe wow)|
|Alpine3.5 | 0.0.8 | 489 MB|
|Alpine3.5 | 0.0.7 | 518 MB|
|Alpine3.5 | 0.0.6 | 796 MB|
|Debian8.7 | 0.0.5 | 657 MB|

Part of the motivation for using alpine was passing quay.io security tests.
The Debian based had 99 vulnerabilities, whereas alpine passes.
Debian package has 150 packages, alpine ends up with with 91 packages.
The current version is incredibly big (twice as big as the previous one), will dedicate some time to find a way to make it smaller soon.

## Tools versions
| Tool | version |
| --- | --- |
| kubectl | 1.8.5 |
| perl | 5.26.0 |

## Pulling
```bash
$ docker pull sebosp/tvl:1.0.7
```

- Vim (With PaperColor, syntastic, airline, pathogen, vim-snippets)
- Ansible
- AWS CLI
- Git
- Git-flow
- Bash with git-prompt setup
- kubectl for kubernetes.
- Bash with kubectl context
- Bash with Current AWS Profile (AWS_DEFAULT_PROFILE)
- Everyday shell utils.
- Perl setup with perl-critic

## Running
```bash
 # If you want to have history for docker separately, do this:
$ touch $HOME/.docker_bash_hist
 # Otherwise, you can do this to have bash_history shared
$ ln -s $HOME/.bash_history $HOME/.docker_bash_hist
$ docker run --rm -v $HOME/:/home/sre/work/ -e LOCAL_USER_ID=`id -u $USER` -it sebosp/tvl:1.0.7 
 # For isolating different AWS accounts, you can use -e ENV=<proj1_dev|proj1_qa|...>
 # The "ENV" must map to a file in $HOME/envs/ (i.e. $HOME/envs/proj1_qa)with contains source'able files for AWS credentials.
$ docker run --rm --cap-add=SYS_PTRACE -v $HOME/:/home/sre/work/ -e ENV=proj1_qa -e LOCAL_USER_ID=`id -u $USER` -it sebosp/tvl:1.0.7 
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
if strace is needed for a debugging something, you can use `--cap-add=SYS_PTRACE` as part of the docker run flags.

## Current issues
- git diff opens up LESS even when the output is less than a page.
  When setting -F less won't open at all (regardless of output length).
  I suspect this could somethig to do with TERM capabilities,size,etc...

## TODO
- mount docker socket so that we can manage Docker within Docker?
