#!/bin/bash
# Preparing stage1 system root.

echo "
====
Preparing stage1 system root.
====
"

# Remove old system root.
if [ -d "$_STAGE1" ]; then
    abinfo "Removing old stage1 system root ..."
    rm -r "$_STAGE1" || \
        aberr "Failed to remove old stage1 system root: $?"
fi

# Copy system root.
abinfo "Copying stage1 system root from stage0 ..."
cp -av "$_STAGE0" \
    "$_STAGE1" || \
    aberr "Failed to copy stage1 system root: $?"

# Copy files.
abinfo "Copying data and scripts for stage1 ..."
cp -rv "$_DATADIR" \
    "$_STAGE1"/stage1-data || \
    aberr "Failed to copy data and scripts for stage1: $?"

abinfo "Copying contrib scripts for stage1 ..."
cp -rv "$_CONTRIBDIR" \
    "$_STAGE1"/stage1-contrib || \
    aberr "Failed to copy contrib scripts for stage1: $?"

abinfo "Copying sources for stage1 ..."
cp -rv "$_SRCDIR" \
    "$_STAGE1"/stage1-sources || \
    aberr "Failed to copy sources for stage1: $?"

# Environment settings.
abinfo "Setting up environment for stage1: $?"
echo -e "\
# Contributed data directory.
export _CONTRIBDIR=/stage1-contrib

# Data directory.
export _DATADIR=/stage1-data

# Source cache directory.
export _SRCDIR=/stage1-sources

# Architecture.
export KABOOM_ARCH=$KABOOM_ARCH
" \
    > "$_STAGE1"/.kaboomrc || \
    aberr "Failed to generate environment file (source paths, KABOOM_ARCH): $?"
cat "$_LIBDIR"/env.bash \
    >> "$_STAGE1"/.kaboomrc || \
    aberr "Failed to generate environment file (lib/env.bash): $?"
echo -e "
# Extra PATHs.
export PATH=\"\$HOME/.local/bin:/usr/bin/core_perl:/tools/bin:/usr/bin"" \
    >> "$_STAGE1"/.kaboomrc || \
    aberr "Failed to generate environment file (PATH variable): $?"
