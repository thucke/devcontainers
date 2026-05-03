ARG PHP_VERSION

FROM dunglas/frankenphp:1-php${PHP_VERSION}-trixie

ARG DEVCONTAINER_SERVICE_ID
ARG DEVCONTAINER_SERVICE_NAME

ENV DEVCONTAINER_SERVICE_ID=${DEVCONTAINER_SERVICE_ID}
ENV DEVCONTAINER_SERVICE_NAME=${DEVCONTAINER_SERVICE_NAME}
ENV TYPO3_INSTALL_WEB_SERVER_CONFIG=other

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

USER root

EXPOSE 80 443
RUN addgroup --gid ${DEVCONTAINER_SERVICE_ID} ${DEVCONTAINER_SERVICE_NAME} && \
    adduser --gid ${DEVCONTAINER_SERVICE_ID} --home /home/${DEVCONTAINER_SERVICE_NAME} --comment "devcontainer service user" \
        --disabled-password --shell /bin/bash --uid ${DEVCONTAINER_SERVICE_ID} $DEVCONTAINER_SERVICE_NAME

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
        postgresql-client && \
    update-locale LANG=en_US.UTF-8 &&\
    #apt-get install -y iproute2 iputils-ping && \
    install-php-extensions calendar bcmath exif ftp mysqli pdo pdo_mysql pdo_pgsql pgsql gmp intl zip \
        gd imagick xdebug opcache tokenizer json iconv mbstring curl phar session simplexml xml @composer && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -v -m 777 ${WORKSPACE_ROOT}

COPY ./allsudoers /etc/sudoers.d/allsudoers
COPY ./docker-entrypoint.sh /

USER ${DEVCONTAINER_SERVICE_NAME}

# add devcontainer cli (https://github.com/devcontainers/cli)
ADD --chmod=0755 --chown=${DEVCONTAINER_SERVICE_NAME}:${DEVCONTAINER_SERVICE_NAME} https://raw.githubusercontent.com/devcontainers/cli/main/scripts/install.sh /home/${DEVCONTAINER_SERVICE_NAME}/.devcontainers/bin/
ENV PATH="$PATH:/home/${DEVCONTAINER_SERVICE_NAME}/.devcontainers/bin"
RUN /home/${DEVCONTAINER_SERVICE_NAME}/.devcontainers/bin/install.sh

WORKDIR ${WORKSPACE_ROOT}

ENTRYPOINT ["/docker-entrypoint.sh"]
