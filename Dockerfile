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
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
CMD ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
