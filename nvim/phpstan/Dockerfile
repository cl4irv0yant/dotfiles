FROM php:7.4-cli

RUN apt-get update && apt-get install -y \
        git \
        unzip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer global config --no-plugins allow-plugins.phpstan/extension-installer true

RUN composer global require "phpstan/phpstan:^1.8" \
        "phpstan/extension-installer" \
        "phpstan/phpstan-doctrine:^1.3" \
        "phpstan/phpstan-symfony:^1.2" \
        "phpstan/phpstan-phpunit:^1.1" \
        "phpstan/phpstan-webmozart-assert:^1.2"

ENV PATH="/root/.composer/vendor/bin:${PATH}"

