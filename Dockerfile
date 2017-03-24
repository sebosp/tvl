FROM debian:8.7
MAINTAINER Seb Osp <kraige@gmail.com>
ENV L0_REFRESHED_AT 20170324
COPY files/puppetlabs-release-pc1-jessie.deb /tmp/
COPY files/bashrc /home/sre/.bashrc
COPY files/preexec.bash.sh /home/sre/preexec.bash.sh
COPY files/screen-preexec.sh /home/sre/screen-preexec.sh
COPY files/screenrc /home/sre/.screenrc
COPY files/git-prompt.sh /home/sre/
COPY files/vimrc /home/sre/.vimrc
COPY files/vim /home/sre/.vim
COPY files/kubectl /usr/bin/
COPY files/packer /usr/bin/
COPY files/terraform /usr/bin/
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN apt-get update && apt-get -y --no-install-recommends install \
    ca-certificates curl vim-puppet vim-scripts vim-syntastic vim-puppet ruby-rspec-puppet mlocate python python-pip \
    ansible puppet-lint screen awscli ruby2.1 git libyaml-dev pkg-config build-essential libpython-dev python-dev awscli \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && dpkg -i /tmp/puppetlabs-release-pc1-jessie.deb \
    && rm /tmp/puppetlabs-release-pc1-jessie.deb \
    && chmod a+x /usr/bin/kubectl
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
