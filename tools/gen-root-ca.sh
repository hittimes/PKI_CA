#!/bin/bash

# CyberTrust Root

# Prepare the directory
BASE_NAME=root
BASE_DIR=/root/${BASE_NAME}_ca

SRC_DIR=`pwd`

mkdir $BASE_DIR
cd $BASE_DIR

mkdir certs crl newcerts private
chmod 700 private
touch index.txt
touch index.txt.attr
echo 1000 > serial

cp ${SRC_DIR}/${BASE_NAME}.cnf $BASE_DIR

# Create the root key
cd $BASE_DIR
openssl genrsa -aes256 -out $BASE_DIR/private/$BASE_NAME.key.pem 4096
chmod 400 $BASE_DIR/private/$BASE_NAME.key.pem

# Create the root certificate 50 years
openssl req -config $BASE_DIR/$BASE_NAME.cnf \
      -key $BASE_DIR/private/$BASE_NAME.key.pem \
      -new -x509 -days 18250 -sha256 -extensions v3_ca \
      -out $BASE_DIR/certs/$BASE_NAME.cert.pem

chmod 444 $BASE_DIR/certs/$BASE_NAME.cert.pem

# View the root certificate
openssl x509 -noout -text -in $BASE_DIR/certs/$BASE_NAME.cert.pem
