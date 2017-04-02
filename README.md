# tvl 0.0.6
Docker setup with my common work tools
Alpine based: tvl                       0.0.6                         d061e3e151c4        14 minutes ago      796 MB
Debian based: tvl                       0.0.5                         739559042d96        17 hours ago        657 MB

Part of the motivation for using alpine was passing quay.io security tests.
The Debian based had 99 vulnerabilities, whereas alpine passes.
Debian package has 150 packages, alpine ends up with with 91 packages.
Alpine ends up being bigger tho...

## Utils included
The purpose is to have an env with:
- Puppet
- Vim (With PaperColor, syntastic, etc)
- Terraform
- Packer
- AWS CLI
- Git

## Running
```bash
 # If you want to have history for docker separately, do this:
$ touch $HOME/.docker_bash_hist
 # Otherwise, you can do this to have bash_history shared
$ ln -s $HOME/.bash_history $HOME/.docker_bash_hist
$ docker run --rm -v $HOME/:/home/sre/work/ -e LOCAL_USER_ID=`id -u $USER` -it tvl:0.0.6 /bin/bash
```

## Prerequisites for building
```bash
$ cd files
$ curl -sLO https://releases.hashicorp.com/terraform/0.9.1/terraform_0.9.1_linux_amd64.zip
$ unzip terraform_0.9.1_linux_amd64.zip && rm terraform_0.9.1_linux_amd64.zip
$ curl -sLO https://releases.hashicorp.com/packer/0.12.3/packer_0.12.3_linux_amd64.zip
$ unzip packer_0.12.3_linux_amd64.zip && rm packer_0.12.3_linux_amd64.zip
$ curl -sLO https://apt.puppetlabs.com/puppetlabs-release-pc1-jessie.deb
$ curl -sLO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
```
