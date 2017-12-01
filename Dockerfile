FROM ubuntu:14.04
MAINTAINER RReyes

ENV LANG C.UTF-8

#libapache2-mod-macro For Read Enviroment Variabel in creartion of .conf configurations Files
RUN apt-get update; apt-get install -y \
    apache2 \
    libapache2-mod-macro \
    openssl \
    nano 

RUN rm -rf /var/www/html/*; rm -rf /etc/apache2/sites-enabled/*; \
    mkdir -p /etc/apache2/external

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV ORGANIZATIONNAME RUBENSGROUP

#Name of server domain, this name is the white in url in nav
ENV SERVERNAME sitio.seguro.roger

#Secutiry SSL encription 1024 => 128GSM, 2048
ENV SECURITYSSL 2048

RUN sed -i 's/^ServerSignature/#ServerSignature/g' /etc/apache2/conf-enabled/security.conf; \
    sed -i 's/^ServerTokens/#ServerTokens/g' /etc/apache2/conf-enabled/security.conf; \
    echo "ServerSignature Off" >> /etc/apache2/conf-enabled/security.conf; \
    echo "ServerTokens Prod" >> /etc/apache2/conf-enabled/security.conf; \
    a2enmod ssl; \
    a2enmod headers; \
    echo "SSLProtocol ALL -SSLv2 -SSLv3" >> /etc/apache2/apache2.conf
#   a2enmod macro; \
 

RUN a2ensite default-ssl 

ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf

EXPOSE 80
EXPOSE 443

ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]