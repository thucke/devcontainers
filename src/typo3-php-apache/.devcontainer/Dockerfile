ARG PHP_VERSION

FROM php:${PHP_VERSION}-apache-trixie

ARG DEVCONTAINER_SERVICE_ID
ARG DEVCONTAINER_SERVICE_NAME

ENV DEVCONTAINER_SERVICE_ID=${DEVCONTAINER_SERVICE_ID}
ENV DEVCONTAINER_SERVICE_NAME=${DEVCONTAINER_SERVICE_NAME}
ENV APACHE_RUN_USER=${DEVCONTAINER_SERVICE_NAME}
ENV APACHE_RUN_GROUP=${DEVCONTAINER_SERVICE_NAME}
ENV TYPO3_INSTALL_WEB_SERVER_CONFIG=apache

# should be set by devcontainer.json, but we set it here as well to be sure
ENV WORKSPACE_ROOT=${WORKSPACE_ROOT:-/workspaces}
ENV APACHE_DOCUMENT_ROOT=${WORKSPACE_ROOT}/.build/public

EXPOSE 80 443
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
    update-locale LANG=en_US.UTF-8 &&\
    #apt-get install -y iproute2 iputils-ping && \
    install-php-extensions calendar bcmath exif ftp mysqli pdo pdo_mysql pdo_pgsql pgsql gmp intl zip \
        gd imagick xdebug opcache tokenizer json iconv mbstring curl phar session simplexml xml @composer && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -v -m 777 ${WORKSPACE_ROOT} && \
    echo "UseCanonicalName On" >>/etc/apache2/apache2.conf && \
    ln -sfr /etc/apache2/mods-available/expires.load /etc/apache2/mods-enabled/expires.load && \
    ln -sfr /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/headers.load && \
    ##################################################################################
    # configuration according to https://docs.typo3.org/m/typo3/reference-coreapi/main/en-us/Administration/Installation/SystemRequirements/Index.html#using-typo3-with-docker-based-environments
    ##################################################################################
    # Enable Apache mod_rewrite
    a2enmod rewrite

COPY ./allsudoers /etc/sudoers.d/allsudoers
COPY ./docker-entrypoint.sh /

USER ${DEVCONTAINER_SERVICE_NAME}
WORKDIR ${WORKSPACE_ROOT}

ENTRYPOINT ["/docker-entrypoint.sh"]
