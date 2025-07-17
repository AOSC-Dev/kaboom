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

export CFLAGS="$CFLAGS $_HOST_FLAGS"
export CXXFLAGS="$CXXFLAGS $_HOST_FLAGS"

if [ "$_LINK_LIB64" = "1" ] ; then
	abinfo "Workaround: Creating symlink /usr/lib64 -> lib ..."
	mkdir -pv "$_STAGE0"/usr/lib
	ln -sv lib "$_STAGE0"/usr/lib64
fi

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
rm -v "$_STAGE0"/usr/lib/*.la || \
    aberr "Failed to remove libtool archives (.la) ..."
if [ ! -L "$_STAGE0"/usr/lib64 ] && [ -d "$_STAGE0"/usr/lib64 ] ; then
	rm -v "$_STAGE0"/usr/lib64/*.la || \
	    aberr "Failed to remove unwanted libtool archives (.la) from libstdc++: $?"
fi
if [ ! -L "$_STAGE0"/usr/lib32 ] && [ -d "$_STAGE0"/usr/lib32 ] ; then
	rm -v "$_STAGE0"/usr/lib32/*.la || \
	    aberr "Failed to remove unwanted libtool archives (.la) from libstdc++: $?"
fi

# Remove the workaround
if [ "$_LINK_LIB64" = "1" ] ; then
	abinfo "Workaround: Removing the /usr/lib64 -> lib symlink ..."
	unlink "$_STAGE0"/usr/lib64
fi

