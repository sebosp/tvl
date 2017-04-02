FROM alpine:3.5
MAINTAINER Seb Osp <kraige@gmail.com>
ENV L0_REFRESHED_AT 20170401
COPY files/vim /home/sre/.vim
RUN apk add --update \
       ansible bash ca-certificates ctags curl findutils git less mtr ncurses-terminfo openssh-client \
       perl python py-pip ruby ruby-bundler screen shadow vim  \
    && echo http://dl-4.alpinelinux.org/alpine/edge/testing/ >> /etc/apk/repositories \
    && apk add --update gosu \
    && rm -rf /var/cache/apk/* \
    && gem install --no-rdoc --no-ri --no-document puppet:4.8.2 facter:2.4.6 puppet-lint \
    && /usr/bin/puppet module install puppetlabs-apk \
    && rm /usr/lib/ruby/gems/2.3.0/gems/facter-2.4.6/lib/facter/blockdevices.rb \
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
    && pip install --upgrade pip \
    && pip install --upgrade awscli flake8 \
    && mkdir /home/sre/.puppetlabs \
    && chmod a+rw /home/sre/.puppetlabs \
    && curl -SLO https://raw.github.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh \
    && sh gitflow-installer.sh install stable \
    && rm -rf gitflow-installer.sh /usr/local/share/doc/gitflow /usr/share/vim/vim80/doc
COPY files/bashrc /home/sre/.bashrc
COPY files/screenrc /home/sre/.screenrc
COPY files/preexec.bash.sh /home/sre/
COPY files/screen-preexec.sh /home/sre/
COPY files/git-prompt.sh /home/sre/
COPY files/kubectl /usr/bin/
COPY files/packer /usr/bin/
COPY files/terraform /usr/bin/
RUN vim -E -c "execute pathogen#infect('~/.vim/bundle/{}')" -c "execute pathogen#helptags()" -c q ; return 0
COPY files/vimrc /home/sre/.vimrc
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod a+x /usr/bin/kubectl && updatedb
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
