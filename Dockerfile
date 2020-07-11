FROM jobber:1.4.3-alpine3.11

LABEL maintainer="badbuta@badbuta.com"

USER root

ARG JOBBER_WORK_HOME="/jobber-work"
ARG DOCKER_VERSION="19.03.11"
ARG DOCKER_COMPOSE_VERSION="1.26.1"
ARG DOCKER_MACHINE_VERSION="v0.16.2"
ARG GLIBC_VERSION="2.31-r0"

ENV TZ="Asia/Hong_Kong"

# Dependencies and Utilities
RUN apk add --update --no-cache \
    # ----- Dependencies
    gcc \
    make \
    libc-dev \
    libffi-dev \
    openssl-dev \
    musl-dev \
    python-dev \
    wget \
    curl \
    py-pip && \
    # ----- Install GLIBC for Alpine Linux (Requried by docker-compose)
    curl -L "https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub" -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -L "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" -o /tmp/glibc-bin-${GLIBC_VERSION}.apk && \
    curl -L "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" -o /tmp/glibc-${GLIBC_VERSION}.apk && \
    apk add --update --no-cache /tmp/glibc-${GLIBC_VERSION}.apk /tmp/glibc-bin-${GLIBC_VERSION}.apk && \
    # ----- Docker, Docker Engine, Docker Compose
    curl -L "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" -o /tmp/docker-${DOCKER_VERSION}.tgz && \
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    curl -L "https://github.com/docker/machine/releases/download/${DOCKER_MACHINE_VERSION}/docker-machine-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-machine && \
    tar -xz -C /tmp -f /tmp/docker-${DOCKER_VERSION}.tgz && \
    mv /tmp/docker/docker /usr/local/bin && \
    # pip install docker-compose docker-cloud && \
    chmod +x /usr/local/bin/docker* && \    
    # -- More APKs
    # ----- Utilities
    apk add --update --no-cache \
    bash \
    expect \
    gpgme \
    tzdata \
    jq \
    git \
    rsync \
    openssh-client

# Cleanup
RUN rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /var/log/* && \
    rm -rf /root/.cache

# Copy the files
COPY image-files /

# Setup for jobber
WORKDIR ${JOBBER_WORK_HOME}
RUN addgroup root jobberuser && \
    chgrp -R jobberuser . && \
    chmod 755 /usr/local/bin/start-jobber.sh && \
    chmod 644 ./.* ./* && \
    chmod g+w . && \
    ln -s jobberfile_sample_1.4.yml .jobber
ENV JOBBER_WORK_HOME=${JOBBER_WORK_HOME}

# Setup Docker Entrypoint:
# Update permission and ownership
RUN chmod 644 \
        /docker-entrypoint.d/* \
        /root/.bashrc && \
    chmod 755 \
        /docker-entrypoint.sh \
        /docker-entrypoint.d \
        /docker-entrypoint.d/*.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
