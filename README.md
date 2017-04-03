# tvl 0.0.7 (hotfix 2)
Docker setup with my common work tools
| Base | version | size |
| --- | --- | --- |
|Alpine3.5 | 0.0.7 | 518 MB|
|Alpine3.5 | 0.0.6 | 796 MB|
|Debian8.7 | 0.0.5 | 657 MB|

Part of the motivation for using alpine was passing quay.io security tests.
The Debian based had 99 vulnerabilities, whereas alpine passes.
Debian package has 150 packages, alpine ends up with with 91 packages.
Alpine ends up being bigger tho...

## Current issues
- git diff opens up LESS even when the output is less than a page.
  When setting -F less won't open at all (regardless of output length).
  I suspect this could somethig to do with TERM capabilities,size,etc...

## Utils included
The purpose is to have an env with:
- Puppet (With Lint)
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
$ docker run --rm -v $HOME/:/home/sre/work/ -e LOCAL_USER_ID=`id -u $USER` -it tvl:0.0.7 /bin/bash
```

## TODO
- All links in the Prerequisites can be downloaded from the Dockerfile
- Document explicit versions of included tools a la .so.X.Y.Z files to cope with different environment setup.

## Prerequisites for building
```bash
$ cd files
$ curl -sLO https://releases.hashicorp.com/terraform/0.9.1/terraform_0.9.1_linux_amd64.zip
$ unzip terraform_0.9.1_linux_amd64.zip && rm terraform_0.9.1_linux_amd64.zip
$ curl -sLO https://releases.hashicorp.com/packer/0.12.3/packer_0.12.3_linux_amd64.zip
$ unzip packer_0.12.3_linux_amd64.zip && rm packer_0.12.3_linux_amd64.zip
$ curl -sLO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
```
