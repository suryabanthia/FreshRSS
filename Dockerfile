FROM php:8.2-apache

# Install necessary PHP extensions
RUN docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html

# Download and extract FreshRSS (replace with the latest version if needed)
RUN curl -L -o FreshRSS.zip https://github.com/FreshRSS/FreshRSS/releases/download/1.25.3/FreshRSS-1.25.3.zip && \
    unzip FreshRSS.zip && \
    mv FreshRSS-1.25.3/* . && \
    rm -rf FreshRSS-1.25.3 FreshRSS.zip

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html/data /var/www/html/extensions /var/www/html/themes

# Copy the default Apache vhost configuration
COPY docker-apache.conf /etc/apache2/sites-available/000-default.conf

# Expose port 80
EXPOSE 80

 # Set the entrypoint to start Apache
CMD ["apache2-foreground"]
