#!/bin/bash
# Download stage0 sources.

echo -e "
====
Downloading stage0 sources
====
"

# Load version definitions.
abinfo "Loading version definitions ..."
source "$_DATADIR"/stage0-versions || \
    aberr "Failed to load version definitions: $?"

abinfo "Preparing to download sources ..."
if [ ! -d "$_STAGE0"/sources ]; then
    mkdir -pv "$_STAGE0"/sources || \
        aberr "Failed to create sources download directory: $?"
fi

cd "$_STAGE0"/sources

# Download.
abinfo "Downloading sources ..."
while read url; do
    eval wget -c $url || \
        aberr "Failed to download from $url: $?"
done < "$_DATADIR"/stage0-sources

# Verify.
abinfo "Verifying sources ..."
sha256sum -c "$_DATADIR"/stage0-checksums || \
    aberr "Source checksum verification failed: $?"

# Return.
cd "$_TOPDIR"
