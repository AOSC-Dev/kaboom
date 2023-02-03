#!/bin/bash
# Download stage1 sources.

echo -e "
====
Downloading stage1 sources
====
"

# Load version definitions.
abinfo "Loading version definitions ..."
source "$_DATADIR"/stage1-versions || \
    aberr "Failed to load version definitions: $?"

abinfo "Preparing to download sources ..."
if [ ! -d "$_SRCDIR" ]; then
    mkdir -pv "$_SRCDIR" || \
        aberr "Failed to create sources download directory: $?"
fi

cd "$_SRCDIR"

# Download.
abinfo "Downloading sources ..."
while read url; do
    eval wget -c $url || \
        aberr "Failed to download from $url: $?"
done < "$_DATADIR"/stage1-sources

# Verify.
abinfo "Verifying sources ..."
sha256sum -c "$_DATADIR"/stage1-checksums || \
    aberr "Source checksum verification failed: $?"

# Return.
cd "$_TOPDIR"
