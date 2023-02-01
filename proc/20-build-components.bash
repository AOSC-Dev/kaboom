#!/bin/bash
# Loop to build components.

echo "
====
Building stage0 components
====
"

# Clean up.
if [ -d "$_STAGE0"/build ]; then
    abinfo "$comp: Removing old build root ..."
    rm -r "$_STAGE0"/build/$comp || \
        abinfo "Failed to remove old build root ..."
fi
if [ -d "$_STAGE0"/tool ]; then
    abinfo "Removing old toolchain ..."
    rm -r "$_STAGE0"/tool || \
        abinfo "Failed to remove old toolchain ..."
fi

# Create and enter build root.
abinfo "Creating stage0 build root ..."
mkdir -pv "$_STAGE0"/build || \
    aberr "Failed to create stage0 build root: $?"

# Read build sequence.
for comp in `cat "$_DATADIR"/stage0-sequence`; do
    abinfo "$comp: Creating build directory ..."
    mkdir -pv "$_STAGE0"/build/$comp || \
        aberr "Failed to create build directory for $comp ..."

    cd "$_STAGE0"/build/$comp

    abinfo "$comp: Running build script ..."
    source "$_DATADIR"/scripts/$comp.bash
done
