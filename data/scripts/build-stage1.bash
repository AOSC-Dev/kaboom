#!/bin/bash
# Loop to build stage1.

# Output formatters.
abwarn() { echo -e "[\e[33mWARN\e[0m]: \e[1m$*\e[0m"; }
aberr()  { echo -e "[\e[31mERROR\e[0m]: \e[1m$*\e[0m"; exit 1; }
abinfo() { echo -e "[\e[96mINFO\e[0m]: \e[1m$*\e[0m"; }

echo "
====
Setting up build environment for stage1
====
"
abinfo "Sourcing /.kaboomrc ..."
source /.kaboomrc || \
    aberr "Failed to source /.kaboomrc: ?"

echo "
====
Building stage1 components
====
"

# Source version data.
abinfo "Sourcing version information ..."
source "$_DATADIR"/stage1-versions || \
    aberr "Failed to source version information: $?"

# Clean up.
if [ -d /build ]; then
    abinfo "Cleaning up old stage1 build root ..."
    rm -fr /build || \
        abinfo "Failed to remove old stage1 build root: $?"
fi

# Create and enter build root.
abinfo "Creating stage1 build root ..."
mkdir -pv /build || \
    aberr "Failed to create stage1 build root: $?"

# Read build sequence.
for comp in `cat "$_DATADIR"/stage1-sequence`; do
    abinfo "$comp: Creating build directory ..."
    mkdir -pv /build/$comp || \
        aberr "Failed to create build directory for $comp: $?"

    cd /build/$comp

    abinfo "$comp: Running build script ..."
    source "$_DATADIR"/scripts/$comp.bash
done

# Return to /.
cd /

# Clean up.
abinfo "Removing stage1 build root ..."
rm -r /build || \
    aberr "Failed to remove stage1 build root: $?"

abinfo "Removing stage0 toolchain ..."
rm -r /tools || \
    aberr "Failed to remove stage0 toolchain: $?"

abinfo "Removing stage1 data and scripts ..."
rm -r \
    "$_CONTRIBDIR" \
    "$_DATADIR" \
    "$_SRCDIR" || \
    aberr "Failed to remove stage1 data and scripts: $?"

# Prompt next steps.
echo "
====

Kaboom has completed bootstrapping an AOSC OS stage1 distribution ($KABOOM_ARCH).
The stage1 distribution contains the following:

- Minimal toolchain.
- DPKG package manager.
- Autobuild3 and ACBS.

Next steps for AOSC OS stage2:

- Setup your maintainer information (MTER= in /etc/autobuild/ab3cfg.sh).
- Build the AOSC OS Core.
- Build a BuildKit recipe (see aoscbootstrap/recipes/buildkit.lst for a list
  of packages to build).

These will all be done using Autobuild3's stage2 mode (ABSTAGE2=1, Kaboom has
already enabled it for you).

AOSC OS stage3 will involve a full system rebuild using Ciel with ABSTAGE2=0.

Good luck!

====
"
