FROM photon:5.0

# Core tools. These must all exist, so a missing one should fail the build.
RUN tdnf update -y && \
    tdnf install -y \
        bash curl wget git python3 python3-pip \
        vim nano \
        net-tools iproute2 iputils \
        htop tree unzip zip \
        gcc make \
        openssh \
        jq less sudo lsof \
        procps-ng file ca-certificates && \
    tdnf clean all

# Development headers, installed one at a time and allowed to be missing.
# Photon's repositories do not carry every -devel package under a predictable
# name -- postgresql-devel in particular is absent on Photon 5, and because the
# whole list was a single install, that one missing package failed the entire
# build. Every deploy of this template died here. Installing them individually
# means an absent package costs you that package, not the image.
RUN for pkg in \
        openssl-devel zlib-devel libffi-devel \
        readline-devel ncurses-devel \
        libxml2-devel libxslt-devel \
        sqlite-devel linux-api-headers \
        postgresql-devel mariadb-devel \
        libyaml-devel libpng-devel libjpeg-turbo-devel; do \
      tdnf install -y "$pkg" || echo "[build] $pkg unavailable on Photon 5 -- skipped"; \
    done; \
    tdnf clean all

RUN wget -qO /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

RUN echo "cd /root" >> /root/.bashrc

EXPOSE 7681

# Optional: Claude Code, installed on first boot when INSTALL_CLAUDE_CODE=true.
# Kept out of the image so this stays a small terminal for everyone who does not
# want it. See the script for why the install happens at boot and not here.
COPY install-claude-code.sh /usr/local/bin/install-claude-code.sh
RUN chmod +x /usr/local/bin/install-claude-code.sh

CMD ["/bin/bash", "-c", "\
    /usr/local/bin/install-claude-code.sh; \
    echo \"export PS1='\\[\\033[01;36m\\]$USERNAME@photon\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ '\" >> /root/.bashrc && \
    exec /usr/local/bin/ttyd -p 7681 -c \"$USERNAME:$PASSWORD\" /bin/bash"]
