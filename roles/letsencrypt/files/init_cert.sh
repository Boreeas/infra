#!/bin/bash -ex

domain=$1
[ "$domain" ]
shift

cd /etc/ssl
openssl genrsa 4096 > $domain.key
openssl req \
    -new -sha256 -key $domain.key \
    -reqexts SAN -subj "/CN=$domain" \
    -config <(
        cat /etc/ssl/openssl.cnf;
        printf "[SAN]\nsubjectAltName=DNS:$domain";
        while [ "$1" ]; do
            printf ",DNS:$1"
            shift
        done
    ) \
> $domain.csr

openssl x509 -req \
    -days 7 \
    -in $domain.csr \
    -signkey $domain.key \
    -out $domain.crt

rm $domain.csr
