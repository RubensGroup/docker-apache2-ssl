#!/bin/bash

#SERVERNAME="sitio.seguro.local>"
#1024 => 128GSM 2048
#SECURITYSSL=2048
echo ">> copy /etc/apache2/external/*.conf files to /etc/apache2/sites-enabled/"
cp /etc/apache2/external/*.conf /etc/apache2/sites-enabled/ 2> /dev/null > /dev/null

echo ">> copy /etc/apache2/external/html/* /var/www/html"
cp -R /etc/apache2/external/html/* /var/www/html

#ln -nfs /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf
#ln -nfs /etc/apache2/sites-enabled/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf

if [ ! -z ${HSTS_HEADERS_ENABLE+x} ]
then
  echo ">> HSTS Headers enabled"
  sed -i 's/#Header add Strict-Transport-Security/Header add Strict-Transport-Security/g' /etc/apache2/sites-enabled/default-ssl

  if [ ! -z ${HSTS_HEADERS_ENABLE_NO_SUBDOMAINS+x} ]
  then
    echo ">> HSTS Headers configured without includeSubdomains"
    sed -i 's/; includeSubdomains//g' /etc/apache2/sites-enabled/default-ssl
  fi
else
  echo ">> HSTS Headers disabled"
fi

if [ ! -e "/etc/apache2/external/${SERVERNAME}.key" ] || [ ! -e "/etc/apache2/external/${SERVERNAME}.csr" ]
then

  echo ">> generating Private Key"
  openssl genrsa -out "/etc/apache2/external/${SERVERNAME}.key" ${SECURITYSSL}


  echo ">> generating a CSR (Certificate Signing Request)"
  openssl req -new \
          -subj "/C=CL/ST=MET/L=SANTIAGO/O=${ORGANIZATIONNAME}/CN=${SERVERNAME}" \
          -key "/etc/apache2/external/${SERVERNAME}.key" \
          -out "/etc/apache2/external/${SERVERNAME}.csr" 

  echo ">> generating Certificate SSL"
  openssl  x509 -req -days 365 \
          -in "/etc/apache2/external/${SERVERNAME}.csr" \
          -signkey "/etc/apache2/external/${SERVERNAME}.key" \
          -out "/etc/apache2/external/${SERVERNAME}.crt" \
          -subject
fi

# exec CMD
echo ">> exec docker CMD"
echo "$@"
exec "$@"