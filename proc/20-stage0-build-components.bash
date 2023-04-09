#!/bin/bash
# Loop to build components.

echo "
====
Building stage0 components
====
"

# Clean up.
if [ -d "$_STAGE0" ]; then
    abinfo "Cleaning up old stage0 system root ..."
    rm -fr "$_STAGE0" || \
        abinfo "Failed to remove old stage0 system root: $?"
fi

# Create and enter build root.
abinfo "Creating stage0 build root ..."
mkdir -pv "$_STAGE0"/build || \
    aberr "Failed to create stage0 build root: $?"

# Read build sequence.
for comp in `cat "$_DATADIR"/stage0-sequence`; do
    abinfo "$comp: Creating build directory ..."
    mkdir -pv "$_STAGE0"/build/$comp || \
        aberr "Failed to create build directory for $comp: $?"

    cd "$_STAGE0"/build/$comp

    abinfo "$comp: Running build script ..."
    source "$_DATADIR"/scripts/$comp.bash
done

# Clean up.
abinfo "Removing stage0 build root ..."
rm -r "$_STAGE0"/build || \
    aberr "Failed to remove stage0 build root: $?"

abinfo "Removing libtool archives (.la) ..."
rm -fv "$_STAGE0"/usr/lib**/*.la || \
    aberr "Failed to remove libtool archives (.la) ..."
