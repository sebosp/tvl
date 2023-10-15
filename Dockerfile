<<<<<<< Updated upstream
FROM alpine:3.18.2
LABEL MAINTAINER Seb Osp <kraige@gmail.com>
ENV L0_REFRESHED_AT 20230711
ADD files/pack.tar.gz /home/sre/.config/nvim/pack/main/
RUN set -xe \
    && apk add --update \
       bash terraform bind-tools ca-certificates curl file \
       findutils findutils-locate git grep yq less man-pages py3-pip \
       mtr ncurses-terminfo nmap-ncat neovim helm su-exec \
       openssh-client openssl perl perl-utils postgresql-client \
       screen shadow tar zip ripgrep starship ansible fzf bat fd \
    && echo https://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories \
    && apk add --update git-flow kubectl \
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
=======
FROM ubuntu:mantic-20231011
LABEL MAINTAINER Seb Osp <kraige@gmail.com>
ENV L0_REFRESHED_AT 20231015
COPY files/plug-install.vim /root/.config/nvim/plug-install.vim
COPY files/init.vim /root/.config/nvim/init.vim
COPY files/starship.toml /root/.config/starship.toml
COPY files/coc-settings.json /root/.config/nvim/coc-settings.json
RUN set -xe \
    && apt-get update \
    && apt-get install -y \
        ansible bash bat bind9utils ca-certificates curl \
        fd-find file findutils fzf git git-flow gosu grep \
        gzip jq less librust-gdk-sys-dev locate mtr ncurses-term \
        nodejs npm openssl pkg-config postgresql-client \
        python3-pip ripgrep rust-all rust-src screen tar \
        vim yq zip pkg-config \
    && apt-get install -y cmake \
    && cargo install --locked cargo-add \
    && cargo install --locked cargo-watch \
    && cargo install --locked starship \
    && cargo install --locked trunk \
    && cargo install --locked wasm-bindgen-cli \
    && rustc --print sysroot
RUN set -xe \
    && mkdir -p /root/.local/bin \
    && curl -L https://github.com/rust-lang/rust-analyzer/releases/download/2023-10-09/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer \
    && chmod +x /root/.local/bin/rust-analyzer \
    && apt-get clean \
    && curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && curl -sLo /tmp/nvim0.9.4.tar.gz https://github.com/neovim/neovim/releases/download/v0.9.4/nvim-linux64.tar.gz \
    && cd /tmp \
    && tar -xzf nvim0.9.4.tar.gz \
    && cp -r nvim-linux64/bin/* /usr/local/bin/ \
    && cp -r nvim-linux64/man/* /usr/local/man/ \
    && cp -r nvim-linux64/share/* /usr/local/share/
RUN set -xe \
    && nvim -E -s -u "/root/.config/nvim/plug-install.vim" +PlugInstall +qall \
    && npm install --global yarn \
    && yarn global add neovim \
    && mkdir -p "/root/.config/coc/extensions" \
    && cd /root/.config/coc/extensions \
    && if [ ! -f package.json ] ; then echo '{"dependencies": {}}' > package.json ; fi \
    && npm install \
      coc-eslint \
      coc-prettier \
      coc-pairs \
      coc-ultisnips \
      coc-tsserver \
      coc-json \
      coc-html \
      coc-css \
      coc-fzf-preview \
      coc-rust-analyzer \
      --install-strategy=shallow --ignore-scripts --no-bin-links --no-package-lock --omit=dev \
    && nvim -E -s -u "/root/.config/nvim/init.vim" +"CocInstall coc-rust-analyzer" +qall \
    && mkdir /usr/share/fzf \
    && curl -sLo /usr/share/fzf/key-bindings.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash \
    && updatedb
COPY files/bashrc /root/.bashrc
COPY files/screenrc /root/.screenrc
>>>>>>> Stashed changes
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
CMD ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
