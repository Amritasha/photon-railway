FROM photon:5.0

RUN tdnf update -y && \
    tdnf install -y \
        bash curl wget git python3 python3-pip \
        vim nano \
        net-tools iproute2 iputils \
        htop tree unzip zip \
        gcc make \
        openssh \
        jq less sudo lsof \
        procps-ng file ca-certificates \
        openssl-devel zlib-devel libffi-devel \
        readline-devel ncurses-devel \
        libxml2-devel libxslt-devel \
        sqlite-devel linux-api-headers && \
    tdnf clean all

RUN wget -qO /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

RUN echo "cd /root" >> /root/.bashrc

EXPOSE 7681

CMD ["/bin/bash", "-c", "\
    echo \"export PS1='\\[\\033[01;36m\\]$USERNAME@photon\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ '\" >> /root/.bashrc && \
    /usr/local/bin/ttyd -p 7681 -c $USERNAME:$PASSWORD /bin/bash"]
