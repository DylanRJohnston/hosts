#!/bin/bash
set -o pipefail
set -o nounset
set -e

DIR="$(cd "$(dirname "$0")"; pwd)"

EXTERNAL_HOSTS=(
    'http://someonewhocares.org/hosts/zero/'
)

function hostNameFromURL()
{
    sed -E 's/http:\/\/([^\/]+).+/\1/' <<< "$1"
}

for site in ${EXTERNAL_HOSTS[@]}; do
    curl "${site}" | grep -oE '^(0\.){3}0 \S+' > "$(hostNameFromURL "${site}").hosts"
done

cat *.hosts | sort -u > /etc/hosts
