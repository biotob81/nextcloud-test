# Use Ubuntu 20.04 as the base image
FROM ubuntu:latest

# Update packages and install necessary dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:ondrej/apache2 \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 \
    apache2-utils \
    php8.3 \
    libapache2-mod-php8.3 \
    php8.3-* \
    ffmpeg \
    bzip2 \
    libdlib-dev \
    smbclient \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install pdlib via pip
RUN apt-get update && apt-get install -y \
    python3-pip \
    cmake \
    libopenblas-dev \
    liblapack-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libboost-all-dev \
    python3-dev \
    && pip3 install pdlib

# Change the UID and GID of www-data
RUN usermod -u 99 www-data && groupmod -g 100 www-data

# Install Nextcloud
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    && wget -qO- https://download.nextcloud.com/server/releases/nextcloud-23.0.0.tar.bz2 | tar xvj -C /var/www/html \
    && chown -R www-data:www-data /var/www/html/nextcloud \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose ports
EXPOSE 80

# Start Apache service
CMD ["apache2ctl", "-D", "FOREGROUND"]
