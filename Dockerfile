FROM ubuntu:mantic-20231011
LABEL MAINTAINER Seb Osp <kraige@gmail.com>
ENV L0_REFRESHED_AT 20231016
RUN set -xe \
    && apt-get update \
    && apt-get install -y \
        ansible bash bat bind9utils ca-certificates curl \
        fd-find file findutils fzf git git-flow gosu grep \
        gzip jq less librust-gdk-sys-dev locate mtr ncurses-term \
        nodejs npm openssl pkg-config postgresql-client \
        python3-pip ripgrep rust-all rust-src screen tar \
        vim yq zip pkg-config \
    && apt-get remove -y rustc \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh \
    && chmod +x /tmp/rustup.sh \
    && /tmp/rustup.sh -y \
    && . /root/.cargo/env \
    && rustup target add wasm32-unknown-unknown \
    && rustup toolchain install 1.73.0-x86_64-unknown-linux-gnu \
    && rustup component add rust-src \
    && rustup component add --toolchain 1.73.0-x86_64-unknown-linux-gnu --target wasm32-unknown-unknown rust-std \
    && apt-get install -y cmake \
    && cargo install --locked cargo-watch \
    && cargo install --locked starship \
    && cargo install --locked trunk \
    && cargo install --locked wasm-bindgen-cli \
    && rustc --print sysroot \
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
COPY files/plug-install.vim /root/.config/nvim/plug-install.vim
COPY files/init.vim /root/.config/nvim/init.vim
COPY files/starship.toml /root/.config/starship.toml
COPY files/coc-settings.json /root/.config/nvim/coc-settings.json
RUN set -xe \
    && . /root/.cargo/env \
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
    && nvim -E -s -u "/root/.config/nvim/plug-install.vim" +"CocInstall coc-rust-analyzer" +qall \
    && mkdir /usr/share/fzf \
    && curl -sLo /usr/share/fzf/key-bindings.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash \
    && updatedb
COPY files/bashrc /root/.bashrc
COPY files/sampleCargo.toml /root/vendored/Cargo.toml
COPY files/hello.rs /root/vendored/src/main.rs
RUN set -xe \
    && . /root/.cargo/env \
    && cd /root/vendored/ \
    && cargo vendor
COPY files/screenrc /root/.screenrc
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
CMD ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
