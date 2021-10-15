#!/bin/sh 

for URL in $(cat newsurls.txt) ; do 
    res="$(curl --silent --head --location --output /dev/null --write-out '%{http_code}' $URL)"
    if [[ "$res" == 200 ]]; then 
        curl -s -L -I -o /dev/null -w $URL' -> %{url_effective}\n' $URL; 
    else
        echo "$URL -> "No exist"" 
    fi 
done

