#!/bin/bash

# Generate Server SSL Cert

# Prepare the directory
BASE_NAME=ssl
ROOT_NAME=root
BASE_DIR=/root/${BASE_NAME}_ca
ROOT_BASE=/root/${ROOT_NAME}_ca

SRC_DIR=`pwd`

# Create the ssl ca key
cd $BASE_DIR
openssl genrsa -out $BASE_DIR/private/${1}.key.pem 4096
chmod 400 $BASE_DIR/private/${1}.key.pem

# openssl genrsa -aes256 -out $BASE_DIR/private/${1}.key.pem 4096
# chmod 400 $BASE_DIR/private/${1}.key.pem

# Create the ssl certificate 10 years
cp ${BASE_DIR}/${BASE_NAME}.cnf ${BASE_DIR}/tmp.cnf
cat ${SRC_DIR}/domains.txt >> ${BASE_DIR}/tmp.cnf

cd $BASE_DIR
openssl req -new -sha256 -config ${BASE_DIR}/tmp.cnf \
      -extensions server_cert \
      -key $BASE_DIR/private/${1}.key.pem \
      -subj "/C=CN/ST=ShangHai/O=My Team Ltd/CN=${2}" \
      -out $BASE_DIR/csr/${1}.csr.pem


# openssl req -config $BASE_DIR/$BASE_NAME.cnf -new -sha256 \
#       -key $BASE_DIR/private/${1}.key.pem \
#       -out $BASE_DIR/csr/${1}.csr.pem

# Sign and publish ssl server cert by ssl ca
openssl ca -config ${BASE_DIR}/tmp.cnf -extensions server_cert \
      -days 365 -notext -md sha256 \
      -in $BASE_DIR/csr/${1}.csr.pem \
      -out $BASE_DIR/certs/${1}.cert.pem

chmod 444 $BASE_DIR/certs/${1}.cert.pem

# View the certificate
openssl x509 -noout -text -in $BASE_DIR/certs/${1}.cert.pem

cp $BASE_DIR/certs/${1}.cert.pem $BASE_DIR/output
cp $BASE_DIR/private/${1}.key.pem $BASE_DIR/output

rm ${BASE_DIR}/tmp.cnf
