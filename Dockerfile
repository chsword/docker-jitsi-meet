FROM debian

MAINTAINER Claudio Ferreira Filho <filhocf@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm

ARG PKG_PROXY

# add Jisti repository, import them key and install a tool set
RUN \
    # Set a package proxy in next line
    echo ${PKG_PROXY} > /etc/apt/apt.conf; \
    apt-get update; \
    apt-get install -y wget gnupg2; \
    echo 'deb http://download.jitsi.org unstable/' >> /etc/apt/sources.list; \
    wget -qO - http://download.jitsi.org/jitsi-key.gpg.key | apt-key add - ; \
    apt-get update; \
    apt-get install -y vim less curl multitail tmux git telnet net-tools \
                       unzip links nmap jitsi-meet dialog; \
		apt-get clean

# Adjust some env points
RUN echo 'syntax on' >> /etc/vim/vimrc; \
    echo 'set background=dark' >> /etc/vim/vimrc; \
    echo 'set number' >> /etc/vim/vimrc; \
    echo 'PS1="\[\e[36m\]DOCKER:\[\e[m\] \[\e[34m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\] \[\e[31m\]\d\[\e[m\] - \A\[\e[33m\]\n\w\[\e[m\]\\n# "' >> /root/.bashrc; \
    echo 'umask 022'  >> /root/.bashrc; \
    echo 'export LS_OPTIONS="--color=auto"'  >> /root/.bashrc; \
    echo 'eval "`dircolors`"'  >> /root/.bashrc; \
    echo 'alias ls="ls $LS_OPTIONS"'  >> /root/.bashrc


#ENV PUBLIC_HOSTNAME=192.168.59.103

#/etc/jitsi/meet/localhost-config.js = bosh: '//localhost/http-bind',
#RUN sed s/JVB_HOSTNAME=/JVB_HOSTNAME=$PUBLIC_HOSTNAME/ -i /etc/jitsi/videobridge/config && \
#	sed s/JICOFO_HOSTNAME=/JICOFO_HOSTNAME=$PUBLIC_HOSTNAME/ -i /etc/jitsi/jicofo/config

# Monitore ports use
# reference: http://www.cyberciti.biz/faq/what-process-has-open-linux-port/
# nmap -sT -O localhost
# netstat -tulpn

EXPOSE 80 443 5347
EXPOSE 10000:10010/udp

COPY run.sh /run.sh

CMD ["/run.sh"]

LABEL version="20160925"
