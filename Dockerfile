FROM alpine:20230329
LABEL MAINTAINER Seb Osp <kraige@gmail.com>
ENV L0_REFRESHED_AT 20230530
ENV KUBECTL_VERSION 1.25.10
ENV RUSTUP_TOOLCHAIN stable-x86_64-unknown-linux-musl
ENV TERRAFORM_VERSION 0.11.11
RUN set -ex \
    && apk add --no-cache --update \
       bash build-base bind-tools ca-certificates cmake ctags curl file \
       findutils findutils-locate git grep groff jq less man-pages py3-pip \
       mtr mysql-client ncurses-terminfo nmap-ncat helm \
       openssh-client openssl perl perl-utils postgresql-client \
       screen strace shadow tar zip ripgrep starship ansible fzf bat \
    && echo http://dl-4.alpinelinux.org/alpine/edge/main/ >> /etc/apk/repositories \
    && echo http://dl-4.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories \
    && pip install --upgrade pip \
    && pip install kubernetes awscli flake8 ansible \
    && apk add --update cargo rust gosu \
    && curl -sL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl \
    && chmod a+x /usr/bin/kubectl \
    && apk add vim neovim \
    && mkdir -p /home/sre/.config/nvim/pack/main/start \
    && cd /home/sre/.config/nvim/pack/main/start \
    && git clone --depth 1 https://github.com/ciaranm/securemodelines \
    && git clone --depth 1 https://github.com/editorconfig/editorconfig-vim \
    && git clone --depth 1 https://github.com/justinmk/vim-sneak \
    && git clone --depth 1 https://github.com/itchyny/lightline.vim \
    && git clone --depth 1 https://github.com/andymass/vim-matchup \
    && git clone --depth 1 https://github.com/airblade/vim-rooter \
    && git clone --depth 1 https://github.com/junegunn/fzf.vim \
    && git clone --depth 1 https://github.com/neovim/nvim-lspconfig \
    && git clone --depth 1 https://github.com/nvim-lua/lsp_extensions.nvim \
    && git clone --depth 1 https://github.com/hrsh7th/cmp-nvim-lsp \
    && git clone --depth 1 https://github.com/hrsh7th/cmp-buffer \
    && git clone --depth 1 https://github.com/hrsh7th/cmp-path \
    && git clone --depth 1 https://github.com/hrsh7th/nvim-cmp \
    && git clone --depth 1 https://github.com/ray-x/lsp_signature.nvim \
    && git clone --depth 1 https://github.com/hrsh7th/cmp-vsnip \
    && git clone --depth 1 https://github.com/hrsh7th/vim-vsnip \
    && git clone --depth 1 https://github.com/cespare/vim-toml \
    && git clone --depth 1 https://github.com/stephpy/vim-yaml \
    && git clone --depth 1 https://github.com/rust-lang/rust.vim \
    && git clone --depth 1 https://github.com/rhysd/vim-clang-format \
    && git clone --depth 1 https://github.com/dag/vim-fish \
    && git clone --depth 1 https://github.com/godlygeek/tabular \
    && git clone --depth 1 https://github.com/plasticboy/vim-markdown \
    && git clone --depth 1 https://github.com/folke/tokyonight.nvim \
    && curl -sLO https://raw.github.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh \
    && sh gitflow-installer.sh install stable \
    && sed -i 's/readlink -e/readlink -f/g' /usr/local/bin/git-flow \
    && rm -rf gitflow-installer.sh /usr/local/share/doc/gitflow \
    && ln -s /home/sre/work/.gitconfig /home/sre/.gitconfig \
    && ln -s /home/sre/work/.kube /home/sre/.kube \
    && ln -s /home/sre/work/.aws /home/sre/.aws \
    && ln -s /home/sre/work/.ssh /home/sre/.ssh \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk \
    && updatedb \
    && apk add postgresql-libs \
    && apk add --virtual .build-deps gcc musl-dev postgresql-dev \
    && pip install --upgrade boto boto3 s3transfer configparser passlib \
    && rm -rf /tmp/* \
    && curl -sLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && apk --purge del .build-deps
COPY files/vimrc /home/sre/.vimrc
COPY files/init.vim /home/sre/.config/nvim/init.vim
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
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN pip install gitpython
CMD ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
