ARG PHP_VERSION=${PHP_VERSION:-8.4}

FROM dunglas/frankenphp:1-php${PHP_VERSION}-trixie

ARG DEVCONTAINER_SERVICE_ID
ARG DEVCONTAINER_SERVICE_NAME

ENV DEVCONTAINER_SERVICE_ID=${DEVCONTAINER_SERVICE_ID}
ENV DEVCONTAINER_SERVICE_NAME=${DEVCONTAINER_SERVICE_NAME}
ENV WORKSPACE_ROOT=${WORKSPACE_ROOT:-/workspaces}

USER root

EXPOSE 80 443
RUN addgroup --gid ${DEVCONTAINER_SERVICE_ID} ${DEVCONTAINER_SERVICE_NAME} && \
    adduser --gid ${DEVCONTAINER_SERVICE_ID} --no-create-home --home /nonexistent --comment "devcontainer service user" \
        --disabled-password --shell /bin/false --uid ${DEVCONTAINER_SERVICE_ID} $DEVCONTAINER_SERVICE_NAME

RUN apt-get update && \
    apt-get install -y \
        locales-all \
        openssh-client \
        vim \
        procps \
        unzip \
        mariadb-client && \
    apt-get install -y iproute2 iputils-ping && \
    install-php-extensions calendar bcmath exif ftp mysqli pdo pdo_mysql gmp intl zip \
        gd imagick xdebug opcache tokenizer json iconv mbstring curl phar session simplexml xml @composer && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT [ "/bin/bash" ]
