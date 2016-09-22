#!/usr/bin/env bash

set -eu

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "1 argument required, $# provided"

REPOS=$(curl "https://api.github.com/orgs/$1/repos" | jq -r '.[] | .ssh_url')

echo "$REPOS" | while IFS='' read -r REPO || [[ -n "$REPO" ]]; do
	git clone --recursive "$REPO" || true
done

for DIR in $(find . -maxdepth 1 -type d | cut -c 3-) ; do
	mr register $DIR
done
