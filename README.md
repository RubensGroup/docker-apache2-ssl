----------------------------------------
docker run marvambass/apache2-ssl-secure

docker run -d \
-p 80:80 -p 443:443 \
-v /home/vagrant/apache2-ssl:/etc/apache2/external/ \
marvambass/apache2-ssl-secure

docker run  -p 80:80 -p 443:443 -v /home/vagrant/apache2-ssl:/etc/apache2/external/ marvambass/apache2-ssl-secure

Ejecutar Imagen desde Dockerfile
docker build -t apache2_ssl_roger .

docker run  -p 80:80 -p 443:443 -v /home/vagrant/apache2-ssl:/etc/apache2/external/ apache2_ssl_roger
----------------------------------------

Welcome to the marvambass/apache2-ssl-secure container

If you want to add your own VirtualHosts Configuration, you can copy the following SSL Configuration Stuff

  SSLEngine On

  # Locate Certificate File
  SSLCertificateFile /etc/apache2/external/cert.pem
  # Locate Private Key File
  SSLCertificateKeyFile /etc/apache2/external/key.pem

  # CA File
  SSLCACertificateFile /etc/apache2/external/example_ca.crt
  # If you need to add a Intermediate Cert File
  SSLCertificateChainFile /etc/apache2/external/example-intermediate.crt

  # disable old SSL Versions
  SSLProtocol all -SSLv2 -SSLv3

  # disable ssl compression
  SSLCompression Off

  # set HSTS Header
  #Header add Strict-Transport-Security "max-age=31536000" # just this domain
  #Header add Strict-Transport-Security "max-age=31536000; includeSubdomains" # with subdomains

  # Ciphers
  SSLCipherSuite ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4

  SSLHonorCipherOrder on

#############

>> HSTS Headers disabled
>> generating self signed cert
Generating a 4086 bit RSA private key
...++
............++
writing new private key to '/etc/apache2/external/key.pem'
-----
>> copy /etc/apache2/external/*.conf files to /etc/apache2/sites-enabled/
>> exec docker CMD
/usr/sbin/apache2ctl -D FOREGROUND
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message