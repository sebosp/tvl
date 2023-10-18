# tvl 3.1.1-ubuntu

![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/sebosp/tvl/3.1.1-ubuntu)
[![tvl 3.1.1-ubuntu rust/wasm asciicast](https://asciinema.org/a/614757.svg)](https://asciinema.org/a/614757)

Docker setup with my common work tools for IaC, ConfigManagement, neovim, rust tooling.

Initially the idea was to use alpine for security, but using musl and rust sometimes brings problems due to glibc requirements for certain crates.
Additionally, at the time of this writing, the ubuntu image had no critical vuln and the alpine:3.18.2 had a few.

The container drops privilege to a user that mirrors the UID of the Host OS UID, so that writing files to disk is done through the same UID permissions.
Dropping privileges is done by `gosu`.

## Versions
Docker image tagged 3.1.1-ubuntu
Docker image tagged 3.1.1-musl (Altho may be worked-on in the future)

## Pulling
```bash
$ docker pull sebOsp/tvl:3.1.1-ubuntu
```

## Main Components
- Based on Ubuntu Mantic
- neoVim 0.9 with coc-rust-analyzer, etc. code completion tooling, vim-plug with pre-installed settings, etc.
- Ansible
- Python
- Git-flow
- Everyday shell utils such as bat, fd, fzf, ripgrep, starship
- Terraform
- Rust 1.73 with rust-analyzer, wasm32 target, trunk for serving/watching wasm, cargo watch, etc.

## Running

In the ubuntu version, if the outside user id is 1000, it has to use `/home/ubuntu`
Otherwise `/home/sre` needs to be used, this is so that we can preserve the user id inside the container.

```bash
$ mkdir -p rust-root/git/
$ docker run --network none --rm --name test -v $HOME/rust-root:/home/sre/work/ -e LOCAL_USER_ID=$(id -u $USER) -it sebosp/tvl:3.1.3-ubuntu
$ cat <project/>.cargo/config.toml
[source.crates-io]
replace-with = "vendored-sources"

[source.vendored-sources]
directory = "/home/sre/vendored/vendor"

```

## Workarounds
if strace is needed for a debugging something, you can use `--cap-add=SYS_PTRACE` as part of the docker run flags.

## TODO
...
