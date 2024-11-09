FROM node:20.17.0-alpine3.20 AS build

WORKDIR /build/
COPY . /build/

RUN npm ci
RUN npm run build
RUN rm -rf node_modules/

FROM php:8.3.11-apache AS final

# Install Additional System Dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    libpq-dev \
    libcurl4-gnutls-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists

# Setup project
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
WORKDIR /var/www/html/
RUN docker-php-ext-install pdo_pgsql pgsql curl
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY --from=build /build/ /var/www/html/
RUN composer install --no-dev --no-interaction
RUN php artisan optimize
RUN php artisan config:cache
RUN php artisan event:cache
RUN php artisan route:cache
RUN php artisan view:cache

# Set environment variable for document root
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Update the Apache config to use the DocumentRoot
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf

# Allow rewrite
RUN a2enmod rewrite

# Allow custom config
COPY ./config/custom.conf /etc/apache2/conf-available/custom.conf
RUN a2enconf custom

# Set appropriate permissions
RUN chown -R www-data:www-data /var/www/html/

# Set user to www-data
USER www-data

# Expose port 80
EXPOSE 80
