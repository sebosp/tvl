FROM alpine:3.6
MAINTAINER Seb Osp <kraige@gmail.com>
ENV L0_REFRESHED_AT 20170414
ENV KUBECTL_VERSION 1.8.4
ENV GOROOT="/usr/lib/go"
ENV GOBIN="$GOROOT/bin"
ENV GOPATH="/home/sre/go"
ENV PATH="$PATH:$GOBIN:$GOPATH/bin"
COPY files/vim /home/sre/.vim
RUN set -ex \
    && apk add --update \
       ansible bash build-base ca-certificates ctags curl file findutils git go grep groff jq less llvm4 man-pages \
       mdocml-apropos mtr mysql-client maven ncurses-terminfo nmap-ncat openssh-client openssl perl python \ 
       python-dev python3 py3-pip ruby ruby-bundler ruby-json screen strace shadow vim vimdiff zip \
    && echo http://dl-4.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories \
    && apk add --update gosu py-boto py-boto3 py-passlib py-mysqldb \
    && curl -sL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl\
    && chmod a+x /usr/bin/kubectl \
    && mkdir /home/sre/.vim/autoload/ \
    && curl -o /home/sre/.vim/autoload/pathogen.vim -sL "https://tpo.pe/pathogen.vim" \
    && mkdir /home/sre/.vim/bundle \
    && cd /home/sre/.vim/bundle \
    && git clone --depth 1 https://github.com/bling/vim-airline \
    && git clone --depth 1 https://github.com/ekalinin/Dockerfile.vim \
    && git clone --depth 1 https://github.com/tpope/vim-fugitive \
    && git clone --depth 1 https://github.com/pangloss/vim-javascript \
    && git clone --depth 1 https://github.com/elzr/vim-json \
    && git clone --depth 1 https://github.com/plasticboy/vim-markdown \
    && git clone --depth 1 https://github.com/scrooloose/syntastic \
    && git clone --depth 1 https://github.com/chase/vim-ansible-yaml \
    && git clone --depth 1 https://github.com/SirVer/ultisnips \
    && git clone --depth 1 https://github.com/honza/vim-snippets \
    && git clone --depth 1 https://github.com/Valloric/YouCompleteMe \
    && cd YouCompleteMe \
    && git submodule update --init --recursive \
    && ./install.py \
    && pip3 install --upgrade pip \
    && pip3 install --upgrade awscli awsebcli flake8 \
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
COPY files/ret-prompt.sh /home/sre/
COPY files/vimrc /home/sre/.vimrc
RUN apk del build-base python python-dev llvm4 \
    && apk del build-base cmake python python-dev llvm \
    && rm -rf /var/cache/apk/* \
    && rm -rf /home/sre/.vim/bundle/YouCompleteMe/third_party/ycmd/clang_includes \
    && rm -rf /home/sre/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk \
    && /usr/sbin/makewhatis -a -T utf8 /usr/share/man \
    && updatedb
COPY files/utils.sh /home/sre/utils.sh
COPY files/list_instances /usr/bin/list_instances
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
