# tvl 3.0.2

![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/sebosp/tvl/3.0.2)
[![tvl asciicast](https://asciinema.org/a/119550.png)](https://asciinema.org/a/119550)

Docker setup with my common work tools for Infrastructure As Code, Configuration Management, neovim

Part of the motivation for using alpine was passing quay.io security tests.
The Debian based had 99 vulnerabilities, whereas alpine passes.
Debian package has 150 packages, alpine ends up with with 91 packages.

## Versions
Docker image tagged 3.0.2

## Pulling
```bash
$ docker pull sebOsp/tvl:3.0.2
```

## Main Components
- Based on alpine:3.18.2
- neoVim
- Ansible
- Git
- Git-flow
- Bash with git-prompt setup
- kubectl
- Bash prompt with kubectl context/cluster.
- Everyday shell utils.
- Terraform

## Running
```bash
 # If you want to have history for docker separately, do this:
$ touch $HOME/.docker_bash_hist
 # Otherwise, you can do this to have bash_history shared
$ ln -s $HOME/.bash_history $HOME/.docker_bash_hist
$ docker run --rm -v $HOME/:/home/sre/work/ -e LOCAL_USER_ID=`id -u $USER` -it sebosp/tvl:3.0.2 
 # For isolating different AWS accounts, you can use -e ENV=<proj1_dev|proj1_qa|...>
 # The "ENV" must map to a file in $HOME/envs/ (i.e. $HOME/envs/proj1_qa)with contains source'able files for AWS credentials.
$ docker run --rm --cap-add=SYS_PTRACE -v $HOME/:/home/sre/work/ -e ENV=proj1_qa -e LOCAL_USER_ID=`id -u $USER` -it sebosp/tvl:3.0.2 
```

## Workarounds
if strace is needed for a debugging something, you can use `--cap-add=SYS_PTRACE` as part of the docker run flags.

## TODO
...
