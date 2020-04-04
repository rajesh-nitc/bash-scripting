#!/bin/bash

# gitlab instance
sudo apt-get update -y
sudo apt-get install -y apache2
sudo a2enmod ssl
mkdir -p /opt/app
gsutil -m cp -R gs://tf-first-project-bucket /opt/app
sudo tee /etc/apache2/sites-enabled/default.conf <<'EOF'
<VirtualHost *:443>
        ServerAlias gitlab.budita.dev
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        SSLCertificateFile /opt/app/tf-first-project-bucket/cert.pem
        SSLCertificateKeyFile /opt/app/tf-first-project-bucket/privkey.pem
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
echo "<!doctype html><html><body><h1>Hello Gitlab!</h1></body></html>" | sudo tee /var/www/html/index.html
sudo systemctl restart apache2

# artifactory instance
sudo apt-get update -y
sudo apt-get install -y apache2
sudo a2enmod ssl
mkdir -p /opt/app
gsutil -m cp -R gs://tf-first-project-bucket /opt/app
sudo tee /etc/apache2/sites-enabled/default.conf <<'EOF'
<VirtualHost *:443>
        ServerAlias artifactory.budita.dev
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        SSLCertificateFile /opt/app/tf-first-project-bucket/cert.pem
        SSLCertificateKeyFile /opt/app/tf-first-project-bucket/privkey.pem
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
echo "<!doctype html><html><body><h1>Hello Artifactory!!</h1></body></html>" | sudo tee /var/www/html/index.html
sudo systemctl restart apache2

# dns enteries
# 1. A          name: gitlab.budita.dev         data: ip_address
# 2. A          name: artifactory.budita.dev    data: ip_address

# ssl certificates with * subdomain
# sudo apt-get install certbot
# sudo certbot certonly -d *.budita.dev -d budita.dev --server https://acme-v02.api.letsencrypt.org/directory --preferred-challenges dns --manual