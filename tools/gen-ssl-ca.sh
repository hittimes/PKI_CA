#!/bin/bash

# SSL CA

# Prepare the directory
BASE_NAME=ssl
ROOT_NAME=root
BASE_DIR=/root/${BASE_NAME}_ca
ROOT_BASE=/root/${ROOT_NAME}_ca

SRC_DIR=`pwd`

mkdir $BASE_DIR
cd $BASE_DIR

mkdir certs crl csr newcerts private output
chmod 700 private
touch index.txt
touch index.txt.attr
echo 1000 > serial

cp ${SRC_DIR}/${BASE_NAME}.cnf $BASE_DIR

# crlnumber is used to keep track of certificate revocation lists.
echo 1000 > $BASE_DIR/crlnumber



# Create the ssl ca key
cd $BASE_DIR
openssl genrsa -aes256 -out $BASE_DIR/private/$BASE_NAME.key.pem 4096
chmod 400 $BASE_DIR/private/$BASE_NAME.key.pem


# Create the ssl certificate 10 years
cd $BASE_DIR
openssl req -config $BASE_DIR/$BASE_NAME.cnf -new -sha256 \
      -key $BASE_DIR/private/$BASE_NAME.key.pem \
      -out $BASE_DIR/csr/$BASE_NAME.csr.pem


# Sign and publish ssl ca cert by root ca
cd $ROOT_BASE
openssl ca -config $ROOT_BASE/$ROOT_NAME.cnf -extensions v3_intermediate_ca \
      -days 3650 -notext -md sha256 \
      -in $BASE_DIR/csr/$BASE_NAME.csr.pem \
      -out $BASE_DIR/certs/$BASE_NAME.cert.pem

chmod 444 $BASE_DIR/certs/$BASE_NAME.cert.pem

# View the root certificate
openssl x509 -noout -text -in $BASE_DIR/certs/$BASE_NAME.cert.pem

# Create the certificate chain file
cat $BASE_DIR/certs/$BASE_NAME.cert.pem \
      $ROOT_BASE/certs/$ROOT_NAME.cert.pem > $BASE_DIR/certs/ca-chain.cert.pem
chmod 444 $BASE_DIR/certs/ca-chain.cert.pem
