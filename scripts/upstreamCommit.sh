#!/usr/bin/env bash

# requires curl & jq

# upstreamCommit --paper HASH --purpur HASH
# flag: --paper HASH - the commit hash to use for comparing commits between paper (PaperMC/Paper/compare/HASH...HEAD)
# flag: --purpur HASH - the commit hash to use for comparing commits between purpur (PurpurMC/Purpur/compare/HASH...HEAD)

function getCommits() {
    curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/"$1"/compare/"$2"...HEAD | jq -r '.commits[] | "'"$1"'@\(.sha[:7]) \(.commit.message | split("\r\n")[0] | split("\n")[0])"'
}

(
set -e
PS1="$"

purpurHash="$1"

purpur=""
updated=""
logsuffix=""

# Purpur updates
if [ -n "$purpurHash" ]; then
    pufferfish=$(getCommits "PurpurMC/Purpur" "$pufferfishHash")

    # Updates found
    if [ -n "$pufferfish" ]; then
        updated="Purpur"
        logsuffix="$logsuffix\n\nPurpur Changes:\n$purpurHash"
    fi
fi


disclaimer="Upstream has released updates that appear to apply and compile correctly"
log="Updated Upstream (Purpur)\n\n${disclaimer}${logsuffix}"

echo -e "$log" | git commit -F -

) || exit 1
