#!/bin/bash

####################################################################################################################################################
##  1. Create script bash shell for automation install LEMP (Linux, Nginx, MariaDb, PhpFpm) using docker compose                                  ##
####################################################################################################################################################
##  3. Create simple laravel project (using LEMP on no 1)  using docker compose environment, the project just contain hello world with your name  ##
####################################################################################################################################################


# Create php-fpm Dockerfile
mkdir -p docker

cat <<EOF > docker/php.Dockerfile
FROM php:7.4-fpm

RUN apt-get update && \
    apt-get install -y git zip

RUN curl --silent --show-error https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

EOF



# Create nginx config file
mkdir -p config/nginx

cat <<'EOF' > config/nginx/nginx.conf
server {
    index index.php index.html;
    server_name localhost;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    root /var/www/html/hello-world/public;

    location / {
        try_files $uri $uri/ /index.php$is_args$query_string;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }

    # Static files
    location ~* ^.+\.(jpg|jpeg|gif|css|png|js|ico|svg|html|txt)$ {
        access_log        off;
        expires           30d;
    }
}
EOF



# Create .env file for mysql password
cat <<EOF > .env
MYSQL_ROOT_PASSWORD=rootpass
EOF



# Create docker-compose.yml file
cat <<EOF > docker-compose.yml
name: lemp-laravel-stack
services:
    php:
        build:
            context: ./docker
            dockerfile: php.Dockerfile
        container_name: php
        user: "1000:1000"
        volumes:
            - './app:/var/www/html'
        depends_on:
            - mariadb

    nginx:
        image: nginx:latest
        container_name: nginx
        ports:
            - '80:80'
            - '443:443'
        links:
            - 'php'
        volumes:
            - './app:/var/www/html'
            - './config/nginx:/etc/nginx/conf.d'

    mariadb:
        image: mariadb:10.3.9
        container_name: mariadb
        restart: 'on-failure'
        env_file:
            - .env
        volumes:
            - ${PWD}
EOF

chmod -R 777 app/hello-world/storage

echo -e '\nDocker compose for LEMP Stack & Laravel Hello World App are generated. running the project...\n'

docker compose up -d && echo -e '\nThe LEMP Stack & Laravel Hello World App is started, to stop it run "docker compose down"\n'
