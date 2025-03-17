FROM ubuntu
#FROM debian:bookworm-slim

WORKDIR /app


RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    gcc-x86-64-linux-gnu libc6-dev binutils libpython3-dev \
    memcached git python3-pip python3-venv openssh-server pipx nodejs npm yarn mkcert; \
    npm install -g newman;

RUN set -eux; \
    mkdir -p /run/sshd; chmod 755 /run/sshd; \
    useradd -m -s /bin/bash sshuser; \
    mkdir -p /home/sshuser/.ssh; \
    chmod 700 /home/sshuser/.ssh;

COPY id_rsa.pub /home/sshuser/.ssh/authorized_keys

RUN set -eux; \
    chmod 600 /home/sshuser/.ssh/authorized_keys; \
    chown -R sshuser:sshuser /home/sshuser

USER sshuser

RUN set -eux; \
    pipx ensurepath; \
    pipx install sparv-pipeline;

USER root

RUN set -eux; \
    mkdir -p /var/run/memcached; chown memcache /var/run/memcached;

ARG REFRESH_BACKEND=dummy

RUN set -eux; \
    git clone https://github.com/CSCfi/Kielipankki-mink-backend.git mink-backend; \
    cd mink-backend; git checkout KP-7710-mock-auth; mkdir -p instance/logs; \
    python3 -m venv venv; . venv/bin/activate; pip3 install -r requirements.txt

ARG REFRESH_FRONTEND=dummy

RUN set -eux; \
    apt-get remove -y cmdtest yarn; \
    npm install -g yarn; \
    git clone https://github.com/CSCfi/Kielipankki-mink-frontend.git mink-frontend; \
    cd mink-frontend; git checkout KP-7710-mock-auth; yarn install;

COPY scripts/run-backend.sh ./run-backend.sh
COPY config/sshd_config /etc/ssh/sshd_config.d/01-local-mink.conf
COPY config/mink_backend_config.py mink-backend/instance/config.py
COPY id_rsa.pub /home/sshuser/.ssh/authorized_keys
COPY pubkey.pem mink-backend/instance/pubkey.pem
COPY config/memcached.conf /etc/memcached.conf

CMD ["./run-backend.sh"]
