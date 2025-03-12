FROM alpine:latest

COPY ./ /var/www/html/
COPY entrypoint.sh /opt/entrypoint.sh

RUN apk --update add \
    curl php-apache2 php-cli php-json php-mbstring php-phar php-openssl && \
    rm -f /var/cache/apk/* && \
    chmod +x /opt/entrypoint.sh && \
    curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer && \
	composer install --working-dir=/var/www/html && \
    mkdir -p /var/www/html/ && chown -R apache:apache /var/www/html

RUN apt-get update && apt-get install -y libssl-dev

COPY configs/httpd.conf /etc/apache2/httpd.conf
COPY configs/app.conf /etc/apache2/sites/
COPY configs/php.ini /etc/php7/php.ini

EXPOSE 80

WORKDIR /var/www/html/
ENTRYPOINT [ "/opt/entrypoint.sh" ]

# FROM php:8.2-apache

# # Install dependencies
# RUN apt-get update && apt-get install -y \
#     curl \
#     unzip \
#     && rm -rf /var/lib/apt/lists/*

# # Install Composer
# RUN curl -sS https://getcomposer.org/installer | php -- \
#     --install-dir=/usr/local/bin --filename=composer

# # Set working directory
# WORKDIR /var/www/html

# # Ensure correct ownership
# RUN chown -R www-data:www-data /var/www/html

# # Validate composer.json and install dependencies
# COPY . /var/www/html
# RUN composer validate && composer install --no-interaction --no-scripts --no-autoloader

# # Optimize Composer autoloader
# RUN composer dump-autoload --optimize

# # Expose port 80
# EXPOSE 80
