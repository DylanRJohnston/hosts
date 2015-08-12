#!/bin/bash
set -o pipefail
set -o nounset
set -o errexit

DIR="$(cd "$(dirname "$0")"; pwd)"

EXTERNAL_HOSTS=(
    'http://someonewhocares.org/hosts/zero/'
)

function hostNameFromURL()
{
    sed -E 's/http:\/\/([^\/]+).+/\1/' <<< "$1"
}

for site in ${EXTERNAL_HOSTS[@]}; do
    curl "${site}" | grep -oE '^0.0.0.0 \S+' > "${DIR}/$(hostNameFromURL "${site}").hosts"
done

cat "${DIR}/"*".hosts" | sort -u > /etc/hosts
