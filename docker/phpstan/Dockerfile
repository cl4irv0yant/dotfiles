
FROM php:7.4-cli

RUN apt-get update && apt-get install -y \
        git \
        unzip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer global require "phpstan/extension-installer"
RUN composer global require "phpstan/phpstan"
RUN composer global require "phpstan/phpstan-doctrine"
RUN composer global require "phpstan/phpstan-symfony"
RUN composer global require "phpstan/phpstan-symfony""
RUN composer global require "phpstan/phpstan-phpunit"
RUN composer global require "phpstan/phpstan-webmozart-assert"
ENV PATH="/root/.composer/vendor/bin:${PATH}"


