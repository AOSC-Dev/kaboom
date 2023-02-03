#!/bin/bash
# Building stage1.

echo "
====

Building stage1

====
"

abinfo "Entering chroot to build stage1 ..."
# By using 'bash -i', the stage1 shell will remain after executing the stage1
# build script.
"$_TOPDIR"/contrib/arch-chroot "$_STAGE1" /usr/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    bash -i <<< '/stage1-data/scripts/build-stage1.bash && exec </dev/tty' || \
    aberr "Failed to build stage1: $?"
