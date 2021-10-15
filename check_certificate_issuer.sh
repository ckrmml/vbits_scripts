#!/usr/bin/env bash
 
while read -r URL; do 
    FOO=$(echo | openssl s_client -showcerts -connect "$URL":443 2> /dev/null | grep "issuer=C" | grep -oP "O\ =\ \K([A-Z].+?)(?=,)")
    printf "Certificate for \'%20s\' was issued by '%10s'\n" "$URL" "$FOO"
done < "$1"