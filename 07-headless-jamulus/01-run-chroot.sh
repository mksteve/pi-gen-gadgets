#!/bin/bash -e

cat >> /etc/apache2/apache2.conf <<EOF 

<Directory /var/www/html/status/>
	Options +Includes
	AddType text/html .shtml
	AddHandler server-parsed .shtml
	AddOutputFilter INCLUDES .shtml
	DirectoryIndex index.shtml
</Directory>
EOF

ln -s /etc/apache2/mods-available/include.load /etc/apache2/mods-enabled/include.load
ln -s /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load
adduser www-data audio
