FROM kalilinux/kali-rolling:latest

RUN sed -i "s/http.kali.org/mirror.twds.com.tw/g" /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    sudo \
    openssh-server \
    python2 \
    dialog \
    inetutils-ping \
    htop \
    nano \
    net-tools 
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    kali-linux-headless && \
    apt-get -y full-upgrade
RUN apt-get -y autoremove && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -c "Kali Linux" -s /bin/bash -d /home/kali kali && \
    sed -i "s/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g" /etc/ssh/sshd_config && \
    sed -i "s/#PasswordAuthentication yes/PasswordAuthentication yes/g" /etc/ssh/sshd_config && \
    echo "kali ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir /var/run/sshd && \
    ssh-keygen -A
USER kali
WORKDIR /home/kali
ENV PASSWORD=kalilinux
ENV SHELL=/bin/bash

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]