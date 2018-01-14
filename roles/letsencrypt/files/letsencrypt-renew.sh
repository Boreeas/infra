#!/bin/bash -ex

cd /etc/lets-encrypt

renew_cert() {
    local domain=$1
    local aliases=$2
    [ "$domain" ]

    pushd /etc/ssl

    openssl req \
        -new -sha256 -key $domain.key \
        -reqexts SAN -subj "/CN=$domain" \
        -config <(
            cat /etc/ssl/openssl.cnf;
            printf "[SAN]\nsubjectAltName=DNS:$domain";
            for al in $aliases; do
                printf ",DNS:$al"
            done
        ) \
        > $domain.csr

    python /etc/lets-encrypt/acme_tiny.py \
        --account-key /etc/lets-encrypt/account.key \
        --csr $domain.csr \
        --acme-dir /srv/http/challenges \
        > $domain.crt.new

    rm $domain.csr

    cat /etc/lets-encrypt/lets-encrypt-x3.crt >> $domain.crt.new
    mv $domain.crt.new $domain.crt

    popd
}

while getopts "h?df:" opt; do
    case "$opt" in
    h|\?)
        echo "Usage: $0 [-d DOMAIN|-f FILE]"
        exit 0
        ;;
    d)  DOMAIN=$OPTARG
        ;;
    f)  FILE=$OPTARG
        ;;
    esac
done

if [[ -z "$FILE" ]] && [[ -z "$DOMAIN" ]]; then
    FILE="/etc/lets-encrypt/domains"
fi

if [ "$FILE" ] && [ "$DOMAIN" ]; then
    echo "Usage: $0 [-d DOMAIN|-f FILE]"
    echo "Please provide only one of domain or file"
    exit 1
fi

if [ "$FILE" ]; then
    while read domain aliases || [[ -n "$domain" ]]; do
        renew_cert $domain $aliases
    done < "$FILE"
else
    renew_cert "$DOMAIN"
fi

while read service; do
    systemctl reload $service
done < "/etc/lets-encrypt/services"
