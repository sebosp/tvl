FROM alpine:3.5
MAINTAINER Seb Osp <kraige@gmail.com>
ENV L0_REFRESHED_AT 20170414
ENV PUPPET_VERSION 4.8.2
ENV FACTER_VERSION 2.4.6
ENV TERRAFORM_VERSION 0.9.3
ENV PACKER_VERSION 0.12.3
ENV KUBECTL_VERSION 1.6.1
ENV GOROOT="/usr/lib/go"
ENV GOBIN="$GOROOT/bin"
ENV GOPATH="/home/sre/go"
ENV PATH="$PATH:$GOBIN:$GOPATH/bin"
COPY files/vim /home/sre/.vim
RUN apk add --update \
       ansible bash build-base ca-certificates cmake ctags curl file findutils go git jq less llvm mtr \
       ncurses-terminfo openssh-client perl python python-dev python3 py3-pip ruby ruby-bundler screen shadow vim vimdiff \
    && echo http://dl-4.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories \
    && apk add --update gosu \
    && curl -sLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && curl -sLO https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    && unzip packer_${PACKER_VERSION}_linux_amd64.zip \
    && mv packer /usr/bin/ \
    && rm packer_${PACKER_VERSION}_linux_amd64.zip \
    && curl -sL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl\
    && chmod a+x /usr/bin/kubectl \
    && gem install --no-rdoc --no-ri --no-document puppet:${PUPPET_VERSION} facter:${FACTER_VERSION} puppet-lint \
    && /usr/bin/puppet module install puppetlabs-apk \
    && rm /usr/lib/ruby/gems/2.3.0/gems/facter-${FACTER_VERSION}/lib/facter/blockdevices.rb \
    && mkdir /home/sre/.vim/autoload/ \
    && curl -o /home/sre/.vim/autoload/pathogen.vim -SL "https://tpo.pe/pathogen.vim" \
    && mkdir /home/sre/.vim/bundle \
    && cd /home/sre/.vim/bundle \
    && git clone --depth 1 https://github.com/bling/vim-airline \
    && git clone --depth 1 https://github.com/ekalinin/Dockerfile.vim \
    && git clone --depth 1 https://github.com/tpope/vim-fugitive \
    && git clone --depth 1 https://github.com/pangloss/vim-javascript \
    && git clone --depth 1 https://github.com/elzr/vim-json \
    && git clone --depth 1 https://github.com/plasticboy/vim-markdown \
    && git clone --depth 1 https://github.com/rodjek/vim-puppet \
    && git clone --depth 1 https://github.com/scrooloose/syntastic \
    && git clone --depth 1 https://github.com/chase/vim-ansible-yaml \
    && git clone --depth 1 https://github.com/SirVer/ultisnips \
    && git clone --depth 1 https://github.com/honza/vim-snippets \
    && git clone --depth 1 https://github.com/sebosp/vim-snippets-terraform \
    && mv vim-snippets-terraform/terraform.snippets vim-snippets/UltiSnips/ \
    && git clone --depth 1 https://github.com/Valloric/YouCompleteMe \
    && cd YouCompleteMe \
    && git submodule update --init --recursive \
    && ./install.py \
    && pip3 install --upgrade pip \
    && pip3 install --upgrade awscli flake8 \
    && mkdir /home/sre/.puppetlabs \
    && chmod a+rw /home/sre/.puppetlabs \
    && curl -SLO https://raw.github.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh \
    && sh gitflow-installer.sh install stable \
    && sed -i 's/readlink -e/readlink -f/g' /usr/local/bin/git-flow \
    && rm -rf gitflow-installer.sh /usr/local/share/doc/gitflow /usr/share/vim/vim80/doc \
    && ln -s /home/sre/work/.gitconfig /home/sre/.gitconfig \
    && ln -s /home/sre/work/.kube /home/sre/.kube \
    && ln -s /home/sre/work/.aws /home/sre/.aws \
    && ln -s /home/sre/work/.ssh /home/sre/.ssh \
    && vim -E -c "execute pathogen#infect('~/.vim/bundle/{}')" -c "execute pathogen#helptags()" -c q ; return 0
COPY files/bashrc /home/sre/.bashrc
COPY files/screenrc /home/sre/.screenrc
COPY files/preexec.bash.sh /home/sre/
COPY files/screen-preexec.sh /home/sre/
COPY files/git-prompt.sh /home/sre/
COPY files/k8s-prompt.sh /home/sre/
COPY files/aws-prompt.sh /home/sre/
COPY files/vimrc /home/sre/.vimrc
RUN apk del build-base cmake python python-dev llvm \
    && rm -rf /var/cache/apk/* \
    && rm -rf /home/sre/.vim/bundle/YouCompleteMe/third_party/ycmd/clang_includes \
    && rm -rf /home/sre/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp \
    && rm -rf /usr/lib/go \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk \
    && updatedb
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
