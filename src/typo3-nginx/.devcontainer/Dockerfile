ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm-trixie

ARG DEVCONTAINER_SERVICE_ID
ARG DEVCONTAINER_SERVICE_NAME

ENV DEVCONTAINER_SERVICE_ID=${DEVCONTAINER_SERVICE_ID}
ENV DEVCONTAINER_SERVICE_NAME=${DEVCONTAINER_SERVICE_NAME}

LABEL dev.containers.servicetype="devcontainer" \
      dev.containers.serviceuser="${DEVCONTAINER_SERVICE_NAME}" \
      dev.containers.serviceuid="${DEVCONTAINER_SERVICE_ID}" \
      dev.containers.phpversion="${PHP_VERSION}" \
      dev.containers.commit_short_sha="${COMMIT_SHORT_SHA}" \
      dev.containers.build_date="${IMAGE_TIMESTAMP}"

# should be set by devcontainer.json, but we set it here as well to be sure
ENV WORKSPACE_ROOT=${WORKSPACE_ROOT:-/workspaces}
ENV TZ=UTC
ENV LANG=en_US.UTF-8

EXPOSE 80 443 9000
USER root

RUN addgroup --gid ${DEVCONTAINER_SERVICE_ID} ${DEVCONTAINER_SERVICE_NAME} && \
adduser --gid ${DEVCONTAINER_SERVICE_ID} --home /home/${DEVCONTAINER_SERVICE_NAME} --comment "devcontainer service user" \
--disabled-password --shell /bin/bash --uid ${DEVCONTAINER_SERVICE_ID} $DEVCONTAINER_SERVICE_NAME

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        locales locales-all \
        sudo \
        openssh-client \
        vim \
        procps \
        unzip \
        lsb-release \
        netcat-openbsd \
        mariadb-client \
        sqlite3 \
        postgresql-client \
        libssl-dev libicu-dev \
        libzip-dev zlib1g-dev \
        libgmp-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libmagickwand-dev \
        libfcgi-bin \
        imagemagick \
        ghostscript && \
    update-locale LANG=en_US.UTF-8
    #apt-get install -y iproute2 iputils-ping && \
    RUN install-php-extensions calendar bcmath exif ftp mysqli pdo pdo_mysql pdo_pgsql pgsql gmp intl zip \
        gd imagick xdebug opcache tokenizer json iconv mbstring curl phar session simplexml xml @composer    
    RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -v -m 777 ${WORKSPACE_ROOT} && \
    sed -i "s/user\s*=\s*www-data/user\ =\ ${DEVCONTAINER_SERVICE_NAME}/" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i "s/group\s*=\s*www-data/group\ =\ ${DEVCONTAINER_SERVICE_NAME}/" /usr/local/etc/php-fpm.d/www.conf

COPY ./allsudoers /etc/sudoers.d/allsudoers
COPY ./docker-entrypoint.sh /

USER ${DEVCONTAINER_SERVICE_NAME}

# add devcontainer cli (https://github.com/devcontainers/cli)
ADD --chmod=0755 --chown=${DEVCONTAINER_SERVICE_NAME}:${DEVCONTAINER_SERVICE_NAME} https://raw.githubusercontent.com/devcontainers/cli/main/scripts/install.sh /home/${DEVCONTAINER_SERVICE_NAME}/.devcontainers/bin/
ENV PATH="$PATH:/home/${DEVCONTAINER_SERVICE_NAME}/.devcontainers/bin"
RUN /home/${DEVCONTAINER_SERVICE_NAME}/.devcontainers/bin/install.sh

WORKDIR ${WORKSPACE_ROOT}

# launch bash shell by default, so that the container doesn't exit immediately and we can exec into it
ENTRYPOINT ["/docker-entrypoint.sh"]
