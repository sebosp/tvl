FROM alpine:3.9
LABEL MAINTAINER Seb Osp <kraige@gmail.com>
ENV L0_REFRESHED_AT 20190408
ENV KUBECTL_VERSION 1.13.12
ENV GOROOT "/usr/lib/go"
ENV GOBIN "$GOROOT/bin"
ENV GOPATH "/home/sre/go"
ENV PATH "$PATH:$GOBIN:$GOPATH/bin"
ENV RUSTUP_TOOLCHAIN stable-x86_64-unknown-linux-musl
ENV HELM_VERSION v2.13.1
ENV HELM_FILENAME helm-${HELM_VERSION}-linux-amd64.tar.gz
ENV JAVA_VERSION 8.201.08-r1
ENV TERRAFORM_VERSION 0.11.13
ENV KOPS_VERSION 1.11.1
RUN set -ex \
    && apk add --no-cache --update \
       bash build-base bind-tools ca-certificates cmake ctags curl file \
       findutils git go grep groff jq less libffi-dev man-pages \
       mdocml-apropos mtr mysql-client ncurses-terminfo nmap-ncat \
       openssh-client openssl perl perl-utils postgresql-client python py2-cffi \
       python2-dev py2-openssl py2-pip py-mysqldb ruby ruby-bundler ruby-json \
       screen strace shadow tar zip
RUN echo http://dl-4.alpinelinux.org/alpine/edge/main/ >> /etc/apk/repositories \
    && echo http://dl-4.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories \
    && pip install --upgrade pip \
    && pip install kubernetes awscli flake8 \
    && apk add --update gosu cargo rust \
    && curl -sL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl \
    && chmod a+x /usr/bin/kubectl
RUN apk add neovim \
    && mkdir -p /home/sre/.fzf/ \
    && git clone --depth 1 https://github.com/junegunn/fzf /home/sre/.fzf/ \
    && cd /home/sre/.fzf/ \
    && ./install --all \
    && mkdir -p /home/sre/.local/share/nvim/site/pack/main/start \
    && cd /home/sre/.local/share/nvim/site/pack/main/start \
    && git clone --depth 1 https://github.com/ciaranm/securemodelines \
    && git clone --depth 1 https://github.com/vim-scripts/localvimrc \
    && git clone --depth 1 https://github.com/justinmk/vim-sneak \
    && git clone --depth 1 https://github.com/itchyny/lightline.vim \
    && git clone --depth 1 https://github.com/w0rp/ale \
    && git clone --depth 1 https://github.com/machakann/vim-highlightedyank \
    && git clone --depth 1 https://github.com/andymass/vim-matchup \
    && git clone --depth 1 https://github.com/airblade/vim-rooter \
    && git clone --depth 1 https://github.com/airblade/vim-gitgutter \
    && git clone --depth 1 https://github.com/junegunn/fzf.vim \
    && git clone --depth 1 https://github.com/autozimu/LanguageClient-neovim --single-branch --branch next \
    && git clone --depth 1 https://github.com/ncm2/ncm2 \
    && git clone --depth 1 https://github.com/roxma/nvim-yarp \
    && git clone --depth 1 https://github.com/ncm2/ncm2-bufword \
    && git clone --depth 1 https://github.com/ncm2/ncm2-tmux \
    && git clone --depth 1 https://github.com/ncm2/ncm2-path \
    && git clone --depth 1 https://github.com/cespare/vim-toml \
    && git clone --depth 1 https://github.com/rust-lang/rust.vim \
    && git clone --depth 1 https://github.com/fatih/vim-go \
    && git clone --depth 1 https://github.com/dag/vim-fish \
    && git clone --depth 1 https://github.com/godlygeek/tabular \
    && git clone --depth 1 https://github.com/plasticboy/vim-markdown \
    && git clone --depth 1 https://github.com/tikhomirov/vim-glsl \
    && git clone --depth 1 https://github.com/tpope/vim-fugitive \
    && git clone --depth 1 https://github.com/maximbaz/lightline-ale \
    && git clone --depth 1 https://github.com/lepture/vim-jinja \
    && git clone --depth 1 https://github.com/ekalinin/Dockerfile.vim \
    && git clone --depth 1 https://github.com/pangloss/vim-javascript \
    && git clone --depth 1 https://github.com/elzr/vim-json \
    && git clone --depth 1 https://github.com/chase/vim-ansible-yaml \
    && git clone --depth 1 https://github.com/SirVer/ultisnips \
    && git clone --depth 1 https://github.com/honza/vim-snippets \
    && git clone --depth 1 https://github.com/sebosp/vim-snippets-terraform \
    && mv vim-snippets-terraform/terraform.snippets vim-snippets/UltiSnips/ \
    && git clone --depth 1 https://github.com/google/vim-jsonnet \
    && git clone --depth 1 https://github.com/martinda/Jenkinsfile-vim-syntax \
    && git clone --depth 1 https://github.com/tpope/vim-commentary \
    && git clone --depth 1 https://github.com/AndrewRadev/splitjoin.vim \
    && cd LanguageClient-neovim \
    && bash install.sh
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
RUN apk add postgresql-libs \
    && apk add --virtual .build-deps gcc musl-dev postgresql-dev \
    && pip install --upgrade boto boto3 s3transfer psycopg2 configparser passlib \
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
    && chmod a+x /usr/local/bin/kops \
    && apk --purge del .build-deps
COPY files/vimrc /home/sre/.vimrc
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
CMD ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
