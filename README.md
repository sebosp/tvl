[![Docker Repository on Quay](https://quay.io/repository/sebosp/tvl/status?token=84ddb0a8-9059-4c43-9125-6d3949ad3e7f "Docker Repository on Quay")](https://quay.io/repository/sebosp/tvl)
# tvl 3.0.0
[![tvl asciicast](https://asciinema.org/a/119550.png)](https://asciinema.org/a/119550)

Docker setup with my common work tools for Infrastructure As Code, Configuration Management, vIM

Part of the motivation for using alpine was passing quay.io security tests.
The Debian based had 99 vulnerabilities, whereas alpine passes.
Debian package has 150 packages, alpine ends up with with 91 packages.

## Versions
Docker image tagged 3.0.0

## Pulling
```bash
$ docker pull sebosp/tvl:3.0.0
```

## Main Components
- Based on alpine:20230523
- Vim (With PaperColor, syntastic, airline, vim-go, vim-snippets, YouCompleteMe, UltiSnips)
- Ansible
- AWS CLI
- Git
- Git-flow
- Bash with git-prompt setup
- kubectl
- Bash prompt with kubectl context/cluster.
- Bash prompt with Current AWS Profile (`AWS_DEFAULT_PROFILE`)
- Everyday shell utils.
- Perl setup with perl-critic
- Go with Go test utils.
- Rust/Cargo with vim shortcuts for asynchronous tests.
- Terraform

## Running
```bash
 # If you want to have history for docker separately, do this:
$ touch $HOME/.docker_bash_hist
 # Otherwise, you can do this to have bash_history shared
$ ln -s $HOME/.bash_history $HOME/.docker_bash_hist
$ docker run --rm -v $HOME/:/home/sre/work/ -e LOCAL_USER_ID=`id -u $USER` -it sebosp/tvl:2.0.0 
 # For isolating different AWS accounts, you can use -e ENV=<proj1_dev|proj1_qa|...>
 # The "ENV" must map to a file in $HOME/envs/ (i.e. $HOME/envs/proj1_qa)with contains source'able files for AWS credentials.
$ docker run --rm --cap-add=SYS_PTRACE -v $HOME/:/home/sre/work/ -e ENV=proj1_qa -e LOCAL_USER_ID=`id -u $USER` -it sebosp/tvl:2.0.0 
```

## Workarounds
if strace is needed for a debugging something, you can use `--cap-add=SYS_PTRACE` as part of the docker run flags.

## TODO
- Add gcloud
