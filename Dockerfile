# Use nextcloud:latest as the base image
FROM nextcloud:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    ffmpeg \
    bzip2 \
    libdlib-dev \
    smbclient \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Install pdlib via pip
RUN pip3 install pdlib

# Change UID and GID of www-data
RUN usermod -u 99 www-data && groupmod -g 100 www-data

# Add a cron job for www-data user
USER www-data
RUN echo "* * * * * echo 'Cron job executed'" | crontab -

# Switch back to root user
USER root
