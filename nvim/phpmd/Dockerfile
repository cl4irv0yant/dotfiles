
FROM php:7.4-cli

RUN apt-get update && apt-get install -y \
        git \
        unzip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer global require "phpmd/phpmd"

ENV PATH="/root/.composer/vendor/bin:${PATH}"
