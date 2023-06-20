FROM alpine:3.18.2
LABEL MAINTAINER Seb Osp <kraige@gmail.com>
ENV L0_REFRESHED_AT 20230620
RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
    && cat /etc/apk/repositories \
    && set -xe \
    && apk add --update --no-install-recommends \
       bash terraform bind-tools ca-certificates curl file \
       findutils findutils-locate git grep yq less man-pages py3-pip \
       mtr ncurses-terminfo nmap-ncat helm su-exec \
       openssh-client openssl perl perl-utils postgresql-client \
       screen shadow tar zip ripgrep starship ansible fzf bat fd \
    && apk add --update git-flow neovim kubectl \
    && mkdir -p /home/sre/.config/nvim/pack/main/start \
    && cd /home/sre/.config/nvim/pack/main/start \
    && git clone --depth 1 https://github.com/ciaranm/securemodelines \
    && git clone --depth 1 https://github.com/editorconfig/editorconfig-vim \
    && git clone --depth 1 https://github.com/itchyny/lightline.vim \
    && git clone --depth 1 https://github.com/airblade/vim-gitgutter \
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
    && git clone --depth 1 https://github.com/godlygeek/tabular \
    && git clone --depth 1 https://github.com/plasticboy/vim-markdown \
    && git clone --depth 1 https://github.com/folke/tokyonight.nvim \
    && ln -s /home/sre/work/.gitconfig /home/sre/.gitconfig \
    && ln -s /home/sre/work/.kube /home/sre/.kube \
    && ln -s /home/sre/work/.ssh /home/sre/.ssh \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk \
    && apk update \
    && updatedb
COPY files/vimrc /home/sre/.vimrc
COPY files/init.vim /home/sre/.config/nvim/init.vim
COPY files/starship.toml /home/sre/.config/starship.toml
COPY files/vim /home/sre/.vim
COPY files/bashrc /home/sre/.bashrc
COPY files/screenrc /home/sre/.screenrc
COPY files/starship.toml /home/sre/starship.toml
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
CMD ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
