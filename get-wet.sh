#!/bin/bash
set -euo pipefail

# URL="wget https://wetten.overheid.nl/${WET}/YYYY-MM-DD/0/txt"
export WET="BWBR0002656"
export BASEURL="https://wetten.overheid.nl/${WET}"
export DATUM="2002-01-01"

while true;
do
    wget -4 -O "${WET}.txt" "${BASEURL}/$DATUM/0/txt"

    ENDDATE=`grep "^Geldend van" ${WET}.txt  | head -1 | awk '{print $5}' | sed -E 's/([0-9]+)-([0-9]+)-([0-9]+)/\3-\2-\1/'`
    NEWDATE=`date -d "${ENDDATE} +1 day" +%d-%m-%Y`
    echo $ENDDATE
    echo $NEWDATE

    if [ "$ENDDATE" = "heden" ]; then
        echo "Last version..."
        exit 1;
    fi

    git add ${WET}.txt
    git commit --date "$DATUM 00:00:00" -m "${WET}-geldend_van_${DATUM}_tot_${NEWDATE}"

    DATUM=${NEWDATE}
done
