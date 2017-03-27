# tvl 0.0.3
Docker setup with common work tools

## Use
The purpose is to have an env with:
- Puppet
- Vim (With PaperColor, syntastic, etc)
- Terraform
- Packer
- AWS CLI
- Git
```bash
$ docker run --rm -v $HOME/:/home/sre/work/ -e LOCAL_USER_ID=`id -u $USER` -it tvl:0.0.3 /bin/bash
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
