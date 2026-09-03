ARG APP_VERSION=1.0.0
ARG BUN_VERSION=1.4.0
ARG COMPOSER_VERSION=2.10.3
ARG DEBIAN_VERSION=trixie
ARG FRANKENPHP_VERSION=1.12.7
ARG PHP_VERSION=8.5.9
ARG PIE_VERSION=1.4.10
ARG TASK_VERSION=3.53.1
ARG DEBIAN_FRONTEND=noninteractive

# ---------------------------------------------------------------------------
# Base stage
# ---------------------------------------------------------------------------
FROM ghcr.io/php/pie:${PIE_VERSION}-bin AS pie
FROM oven/bun:${BUN_VERSION}-debian AS bun
FROM composer:${COMPOSER_VERSION} AS composer
FROM dunglas/frankenphp:${FRANKENPHP_VERSION}-php${PHP_VERSION}-${DEBIAN_VERSION} AS base

ARG APP_VERSION

WORKDIR /app

COPY --from=pie /pie /usr/bin/pie

RUN set -eux; \
    apt update -y; \
    apt install -y --no-install-recommends \
        $PHPIZE_DEPS \
        ca-certificates \
        libpq-dev \
        libicu-dev \
        zlib1g-dev \
        libzip-dev \
        libpng-dev; \
    docker-php-ext-install -j"$(nproc)" pdo_pgsql pcntl intl zip bcmath gd; \
    pie install phpredis/phpredis; \
    apt purge -y --auto-remove $PHPIZE_DEPS libpq-dev libicu-dev zlib1g-dev libzip-dev libpng-dev; \
    apt install -y --no-install-recommends libcap2-bin libpq5 libicu76 libzip5 libpng16-16; \
    setcap -r /usr/local/bin/frankenphp || true; \
    setcap -r /usr/local/bin/caddy || true; \
    apt-get purge -y --auto-remove libcap2-bin; \
    groupadd -g 1000 app; \
    useradd -M -N -u 1000 -g app app; \
    rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# Dev target
# ---------------------------------------------------------------------------
FROM base AS dev

ENV DEBIAN_FRONTEND=noninteractive

COPY --from=bun /usr/local/bin/bun /usr/local/bin/bun
COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY ./configurations/caddy/Caddyfile /etc/frankenphp/Caddyfile
COPY ./configurations/php/dev.ini /usr/local/etc/php/conf.d/app.ini

ARG TASK_VERSION
ARG TARGETARCH

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        $PHPIZE_DEPS \
        curl \
        fish \
        less \
        ca-certificates \
        git \
        unzip \
        procps; \
    ln -s /usr/local/bin/bun /usr/local/bin/node; \
    ln -s /usr/local/bin/bun /usr/local/bin/npm; \
    ARCH="${TARGETARCH}"; \
    curl -sL "https://github.com/go-task/task/releases/download/v${TASK_VERSION}/task_linux_${ARCH}.tar.gz" | tar -xz -C /usr/local/bin task; \
    usermod -s /usr/bin/fish app; \
    mkdir -p \
        /app \
        /home/app \
        /config/fish \
        /config/psysh \
        /config/composer \
        /data/fish; \
    chown -R app:app /app /home/app /config /data; \
    rm -rf /var/lib/apt/lists/*;

ENV HOME=/home/app \
    SHELL=/usr/bin/fish \
    COMPOSER_HOME=/config/composer \
    PATH="/config/composer/vendor/bin:$PATH"

USER app

COPY --chmod=755 ./scripts/ /usr/local/bin/

EXPOSE 8080
EXPOSE 5173
