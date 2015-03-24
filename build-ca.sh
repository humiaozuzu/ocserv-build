#!/bin/bash

AUTHOR="Maple"
VPN="Cisco SG for Maple"
DOMAIN="miao.hu"
CLIENT="user"

cd /opt/ocserv
mkdir ca
cd ca

cat << EOF > ca.tmpl
cn = "$VPN"
organization = "$AUTHOR"
serial = 1
expiration_days = 1000
ca
signing_key
cert_signing_key
crl_signing_key
EOF

cat << EOF > server.tmpl
cn = "$DOMAIN"
organization = "$AUTHOR"
serial = 2
expiration_days = 1000
signing_key
encryption_key
tls_www_server
EOF

certtool --generate-privkey --outfile ca-key.pem
certtool --generate-self-signed --load-privkey ca-key.pem --template ca.tmpl --outfile ca-cert.pem
certtool --generate-privkey --outfile server-key.pem
certtool --generate-certificate --load-privkey server-key.pem \
--load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem \
--template server.tmpl --outfile server-cert.pem

cat << EOF > user.tmpl
cn = "$CLIENT"
serial = 1824
expiration_days = 1000
signing_key
tls_www_client
EOF

certtool --generate-privkey --outfile user-key.pem
certtool --generate-certificate --load-privkey user-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template user.tmpl --outfile user-cert.pem
openssl pkcs12 -export -clcerts -in user-cert.pem -inkey user-key.pem -out user.p12
