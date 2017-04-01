FROM debian:8.7
MAINTAINER Seb Osp <kraige@gmail.com>
ENV L0_REFRESHED_AT 20170401
COPY files/puppetlabs-release-pc1-jessie.deb /tmp/
COPY files/vim /home/sre/.vim
RUN apt-get update && apt-get -y --no-install-recommends install \
    ca-certificates curl vim vim-scripts ruby-rspec-puppet mlocate python python-pip \
    ansible screen ruby2.1 git openssh-client pylint python-flake8 \
    && mkdir /home/sre/.vim/autoload/ \
    && curl -o /home/sre/.vim/autoload/pathogen.vim -SL "https://tpo.pe/pathogen.vim" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && dpkg -i /tmp/puppetlabs-release-pc1-jessie.deb \
    && rm /tmp/puppetlabs-release-pc1-jessie.deb \
    && gem install puppet-lint \
    && mkdir /home/sre/.vim/bundle \
    && cd /home/sre/.vim/bundle \
    && git clone --depth 1 https://github.com/elzr/vim-json \
    && git clone --depth 1 https://github.com/scrooloose/syntastic \
    && git clone --depth 1 https://github.com/ekalinin/Dockerfile.vim \
    && git clone --depth 1 https://github.com/rodjek/vim-puppet \
    && pip install --upgrade awscli
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
