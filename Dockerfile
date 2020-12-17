FROM ubuntu:20.04
LABEL Description="Pre-Built WP container based on fauria/lamp image" \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 -p [HOST DB PORT NUMBER]:3306 snegirev/wp_prebuilt" \
	Version="1.0"

RUN apt-get update && apt-get upgrade -y

COPY debconf.selections /tmp/
RUN debconf-set-selections /tmp/debconf.selections

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y \
	curl \
	php7.4 \
	php7.4-bz2 \
	php7.4-cgi \
	php7.4-cli \
	php7.4-common \
	php7.4-curl \
	php7.4-dev \
	php7.4-enchant \
	php7.4-fpm \
	php7.4-gd \
	php7.4-gmp \
	php7.4-imap \
	php7.4-interbase \
	php7.4-intl \
	php7.4-json \
	php7.4-ldap \
	php7.4-mbstring \
	php7.4-mysql \
	php7.4-odbc \
	php7.4-opcache \
	php7.4-pgsql \
	php7.4-phpdbg \
	php7.4-pspell \
	php7.4-readline \
	php7.4-snmp \
	php7.4-sqlite3 \
	php7.4-sybase \
	php7.4-tidy \
	php7.4-xmlrpc \
	php7.4-xsl \
	php7.4-zip	\
	apache2 \
	libapache2-mod-php7.4 \
	mariadb-common \
	mariadb-server \
	mariadb-client \
	postfix \
	git \
	nano \
	tree \
	ftp

ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC
ENV TERM dumb

COPY run-lamp.sh /usr/sbin/

RUN a2enmod rewrite
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN chmod +x /usr/sbin/run-lamp.sh

# Download WordPress & set Apache access
RUN curl -L "https://wordpress.org/latest.tar.gz" > /latest.tar.gz && \
    rm /var/www/html/index.html && \
    tar -xzf latest.tar.gz -C /var/www/html --strip-components=1 && \
    rm /latest.tar.gz && \
	chown -R www-data:www-data /var/www/html


EXPOSE 80
EXPOSE 3306

CMD ["/usr/sbin/run-lamp.sh"]
