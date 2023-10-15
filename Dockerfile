FROM alpine:3.18.4
LABEL MAINTAINER Seb Osp <kraige@gmail.com>
ENV L0_REFRESHED_AT 20231015
COPY files/vimrc /home/sre/.vimrc
COPY files/init.vim /root/.config/nvim/init.vim
COPY files/plug-install.vim /root/.config/nvim/plug-install.vim
COPY files/vim /home/sre/.vim
COPY files/bashrc /home/sre/.bashrc
COPY files/screenrc /home/sre/.screenrc
COPY files/starship.toml /home/sre/starship.toml
RUN set -xe \
    && apk add --update \
        ansible bash bat bind-tools build-base ca-certificates curl fd file \
        findutils findutils-locate fzf git grep gzip helm jq less man-pages \
        mtr ncurses-terminfo neovim nodejs openssl perl perl-utils \
        postgresql-client py3-pip ripgrep screen shadow starship su-exec \
        tar terraform vim yq zip pkgconfig \
    && echo https://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories \
    && apk add --update git-flow kubectl npm rustup \
    && rustup-init -y \
    && source /root/.cargo/env \
    && rustup component add rust-src \
    && rustc --print sysroot \
    && mkdir -p /root/.local/bin \
    && curl -L https://github.com/rust-lang/rust-analyzer/releases/download/2023-10-09/rust-analyzer-x86_64-unknown-linux-musl.gz | gunzip -c - > ~/.local/bin/rust-analyzer \
    && chmod +x ~/.local/bin/rust-analyzer \
    && ln -s /home/sre/work/.gitconfig /home/sre/.gitconfig \
    && ln -s /home/sre/work/.kube /home/sre/.kube \
    && ln -s /home/sre/work/.ssh /home/sre/.ssh \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk \
    && apk update \
    && updatedb \
    && curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim -E -s -u "/root/.config/nvim/plug-install.vim" +PlugInstall +qall \
    && npm install --global yarn \
    && yarn global add neovim \
    && mkdir -p "/root/.config/coc/extensions" \
    && cd /root/.config/coc/extensions \
    && if [ ! -f package.json ] ; then echo '{"dependencies": {}}' > package.json ; fi && \
      npm install \
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
      --install-strategy=shallow --ignore-scripts --no-bin-links --no-package-lock --omit=dev
RUN nvim -E -s -u "/root/.config/nvim/init.vim" +CocInstall\ coc-rust-analyzer +qall \
    && echo "Moving .local to /home/sre" \
    && mv /root/.local /home/sre/ \
    && mv /root/.cargo /home/sre/ \
    && mv /root/.rustup /home/sre/ \
    && mv /root/.config /home/sre/
COPY files/starship.toml /home/sre/.config/starship.toml
COPY files/coc-settings.json /home/sre/.config/nvim/coc-settings.json
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
CMD ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
