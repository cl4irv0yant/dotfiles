
FROM composer:1.10.22 as composer
FROM php:7.4-cli


RUN chmod a+rwx /tmp
RUN docker-php-ext-install pcntl
RUN apt-get update && apt-get install -y git

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /app

ENTRYPOINT ["composer", "--ansi"]
