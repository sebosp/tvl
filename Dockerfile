FROM alpine:3.8
MAINTAINER Seb Osp <kraige@gmail.com>
ENV L0_REFRESHED_AT 20180730
ENV KUBECTL_VERSION 1.10.5
ENV ANSIBLE_VERSION 2.6.2
ENV GOROOT "/usr/lib/go"
ENV GOBIN "$GOROOT/bin"
ENV GOPATH "/home/sre/go"
ENV PATH "$PATH:$GOBIN:$GOPATH/bin"
ENV RUSTUP_TOOLCHAIN stable-x86_64-unknown-linux-musl
ENV HELM_VERSION v2.10.0-rc.1
ENV HELM_FILENAME helm-${HELM_VERSION}-linux-amd64.tar.gz
ENV JAVA_VERSION 8.171.11-r0
ENV PATH "$PATH:/home/sre/.jx/bin"
ENV TERRAFORM_VERSION 0.11.7
ENV KOPS_VERSION 1.9.1
ENV PY_REQUESTS_VERSION 2.19.1
RUN set -ex \
    && apk add --update \
       bash build-base bind-tools ca-certificates cmake ctags curl file \
       findutils git go grep groff jq less llvm4 man-pages mdocml-apropos mtr \
       mysql-client ncurses-terminfo nmap-ncat openssh-client openssl perl \
       perl-utils postgresql-client python py2-cffi python2-dev py2-openssl \
       py2-pip py-mysqldb ruby ruby-bundler ruby-json screen strace shadow tar zip
RUN echo http://dl-4.alpinelinux.org/alpine/edge/main/ >> /etc/apk/repositories \
    && echo http://dl-4.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories \
    && pip install --upgrade pip \
    && pip install awscli flake8 ansible==${ANSIBLE_VERSION} \
    && apk add --update gosu cargo rust \
    && curl -sL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl \
    && chmod a+x /usr/bin/kubectl
COPY files/vim-8.1.0115-r0.apk /var/cache/vim-8.1.0115-r0.apk
COPY files/jsonnet-0.11.2-r0.apk /var/cache/jsonnet-0.11.2-r0.apk
RUN apk add --allow-untrusted /var/cache/vim-8.1.0115-r0.apk /var/cache/jsonnet-0.11.2-r0.apk \
    && apk add vimdiff \
    && mkdir -p /home/sre/.vim/pack/main/start \
    && cd /home/sre/.vim/pack/main/start \
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
    && git clone --depth 1 https://github.com/sebosp/vim-snippets-terraform \
    && mv vim-snippets-terraform/terraform.snippets vim-snippets/UltiSnips/ \
    && git clone --depth 1 https://github.com/airblade/vim-gitgutter \
    && git clone --depth 1 https://github.com/google/vim-jsonnet \
    && git clone --depth 1 https://github.com/martinda/Jenkinsfile-vim-syntax \
    && git clone --depth 1 https://github.com/tpope/vim-commentary \
    && git clone --depth 1 https://github.com/junegunn/fzf/ \
    && git clone --depth 1 https://github.com/fatih/vim-go \
    && grep -A25 '^let s:packages = {' vim-go/plugin/go.vim|grep -e github.com -e golang.org|grep '^      \\ '|cut -d"'" -f4|while read repoLocation; do go get -u $repoLocation;done \
    && git clone --depth 1 https://github.com/AndrewRadev/splitjoin.vim \
    && git clone --depth 1 https://github.com/Valloric/YouCompleteMe \
    && cd YouCompleteMe \
    && git submodule update --init --recursive \
    && ./install.py --rust-completer --go-completer
RUN curl -sLO https://raw.github.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh \
    && sh gitflow-installer.sh install stable \
    && sed -i 's/readlink -e/readlink -f/g' /usr/local/bin/git-flow \
    && rm -rf gitflow-installer.sh /usr/local/share/doc/gitflow \
    && ln -s /home/sre/work/.gitconfig /home/sre/.gitconfig \
    && ln -s /home/sre/work/.kube /home/sre/.kube \
    && ln -s /home/sre/work/.aws /home/sre/.aws \
    && ln -s /home/sre/work/.ssh /home/sre/.ssh \
    && rm -rf /var/cache/apk/* \
    && rm -rf /home/sre/.vim/pack/start/YouCompleteMe/third_party/ycmd/clang_includes \
    && rm -rf /home/sre/.vim/pack/start/YouCompleteMe/third_party/ycmd/cpp \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk \
    && /usr/sbin/makewhatis -a -T utf8 /usr/share/man \
    && updatedb
RUN pip install --upgrade boto boto3 s3transfer configparser passlib requests==$PY_REQUESTS_VERSION \
    && curl -o /tmp/$HELM_FILENAME https://storage.googleapis.com/kubernetes-helm/${HELM_FILENAME} \
    && tar -zxvf /tmp/${HELM_FILENAME} -C /tmp \
    && mv /tmp/linux-amd64/helm /bin/helm \
    && rm -rf /tmp/* \
    && apk add --update openjdk8-jre-base=${JAVA_VERSION} \
    && curl -sLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && curl -sLO https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 \
    && mv kops-linux-amd64 /usr/local/bin/kops \
    && chmod a+x /usr/local/bin/kops
# JX should be installed outside as it changes so often and needs to be updated.
# mkdir -p /var/tmp/jx \
# cd /var/tmp/jx \
# curl -sLO https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz \
# tar -vxzf jx-linux-amd64.tar.gz \
# mv jx /usr/local/bin
COPY files/vimrc /home/sre/.vimrc
COPY files/vim /home/sre/.vim
COPY files/bashrc /home/sre/.bashrc
COPY files/screenrc /home/sre/.screenrc
COPY files/preexec.bash.sh /home/sre/
COPY files/screen-preexec.sh /home/sre/
COPY files/git-prompt.sh /home/sre/
COPY files/k8s-prompt.sh /home/sre/
COPY files/aws-prompt.sh /home/sre/
COPY files/ret-prompt.sh /home/sre/
COPY files/utils.sh /home/sre/utils.sh
COPY files/list_instances /usr/bin/list_instances
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
# Quick dirty fix for vim's :GoInstallBinaries
RUN grep -A25 '^let s:packages = {' plugin/go.vim|grep -e github.com -e golang.org|grep '^      \\ '|cut -d"'" -f4|while read repoLocation; do go get $repoLocation;done
CMD ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
