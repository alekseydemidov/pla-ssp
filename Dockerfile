FROM nginx
LABEL maintainer='Alexey Demidov <ademidov.info@gmail.com>'
ARG PHPLDAPADMIN_VERSION=1.2.5
ARG PHP_VERSION=7.3
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssl \
    ca-certificates \
    php \
    php-ldap \
    php-mbstring \
#    php-mcrypt \
    php-fpm \
    php-xml \
    php-gettext \
    php-readline \
    curl \
    wget \ 
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ;\
curl -o phpldapadmin.tar.gz -SL https://github.com/leenooks/phpLDAPadmin/archive/${PHPLDAPADMIN_VERSION}.tar.gz \
&& tar xf phpldapadmin.tar.gz -C /usr/share/ \
&& mv /usr/share/phpLDAPadmin-${PHPLDAPADMIN_VERSION} /usr/share/phpldapadmin \
&& cp /usr/share/phpldapadmin/config/config.php.example /usr/share/phpldapadmin/config/config.php \
&& rm phpldapadmin.tar.gz && mkdir /run/php; \
wget http://ltb-project.org/archives/self-service-password_1.3-1_all.deb && dpkg -i self-service-password_1.3-1_all.deb
COPY ssp-nginx.conf /etc/nginx/conf.d/
COPY pla-nginx.conf /etc/nginx/conf.d/
COPY www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/
COPY groupOfNames.xml /usr/share/phpldapadmin/templates/creation/
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"] 

