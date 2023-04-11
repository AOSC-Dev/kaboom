#!/bin/bash
# Finalizing system root.

echo "
====
Finalizing system root
====
"

# Prepare virtual kernel file systems.
abinfo "Creating directories for virtual kernel file systems ..."
mkdir -pv "$_STAGE0"/{dev,proc,sys,run} || \
    aberr "Failed to create directories for virtual kernel file systems: $?"

# Prepare directory structure.
abinfo "Moving files to AOSC OS-compliant locations ..."
if [ -d "$_STAGE0"/bin ]; then
    mv -v "$_STAGE0"/bin/* \
        "$_STAGE0"/usr/bin/ || \
        aberr "Failed to move files from /bin => /usr/bin: $?"
fi
if [ -d "$_STAGE0"/sbin ]; then
    mv -v "$_STAGE0"/sbin/* \
        "$_STAGE0"/usr/bin/ || \
        aberr "Failed to move files from /sbin => /usr/bin: $?"
fi
if [ -d "$_STAGE0"/usr/sbin ]; then
    mv -v "$_STAGE0"/usr/sbin/* \
        "$_STAGE0"/usr/bin/ || \
        aberr "Failed to move files from /usr/sbin => /usr/bin: $?"
fi
if [ -d "$_STAGE0"/lib ]; then
    mv -v "$_STAGE0"/lib/* \
        "$_STAGE0"/usr/lib/ || \
        aberr "Failed to move files from /lib => /usr/lib: $?"
fi
if [ -d "$_STAGE0"/lib64 ]; then
    mv -v "$_STAGE0"/lib64/* \
        "$_STAGE0"/usr/lib/ || \
        aberr "Failed to move files from /lib64 => /usr/lib: $?"
fi

abinfo "Removing extraneous directories ..."
# These will be replaced with symlinks.
rm -frv \
    "$_STAGE0"/{,s}bin \
    "$_STAGE0"/usr/sbin \
    "$_STAGE0"/lib{,64} \
    "$_STAGE0"/usr/lib64 || \
    aberr "Failed to remove extraneous directories: $?"

abinfo "Creating system directories ..."
# Adapted from aosc-aaa.
#
# A derivative of Linux From Scratch system directory template.
# Refer to Chapter 6, Section 5 of Linux From Scratch for original
# design.
#
# This is NOT a fully FHS compliant directory tree.
#

# Just so I don't have to write a stupid amount of aberr handlers.
set -e

mkdir -pv "$_STAGE0"/{boot,home,usr/lib/firmware,mnt,opt}
mkdir -pv "$_STAGE0"/{media/{floppy,cdrom},srv,var}
install -dv -m 0750 "$_STAGE0"/root
install -dv -m 1777 "$_STAGE0"/tmp "$_STAGE0"/var/tmp
mkdir -pv "$_STAGE0"/usr{,/local}/{bin,include,lib,src}
mkdir -pv "$_STAGE0"/usr/share/{doc,info,locale,man}
mkdir -v  "$_STAGE0"/usr/share/zoneinfo
mkdir -pv "$_STAGE0"/usr/share/man/man{1..8}

mkdir -v "$_STAGE0"/var/{log,mail,spool}
ln -sv /run "$_STAGE0"/var/run
ln -sv /run/lock "$_STAGE0"/var/lock
mkdir -pv "$_STAGE0"/var/{opt,cache,local}

#
# Avoid confusion.
#
ln -sv usr/lib "$_STAGE0"/lib
case $KABOOM_ARCH in
	(*n32*)
		ln -sv usr/lib "$_STAGE0"/lib32
		ln -sv lib "$_STAGE0"/usr/lib32
		ln -sv ../lib "$_STAGE0"/usr/lib/32;;
	(*64*|loongson3)
		ln -sv usr/lib "$_STAGE0"/lib64
		ln -sv ../lib "$_STAGE0"/usr/lib/64;;
	(*)
		;;
esac
ln -sv usr/bin "$_STAGE0"/bin
ln -sv usr/bin "$_STAGE0"/sbin
ln -sv bin "$_STAGE0"/usr/sbin

abinfo "Creating /etc/mtab ..."
ln -sv /proc/self/mounts \
    "$_STAGE0"/etc/mtab || \
    aberr "Failed to create /etc/mtab: $?"

abinfo "Copying /etc/group ..."
cp -v "$_CONTRIBDIR"/etc-bootstrap/group \
    "$_STAGE0"/etc/group || \
    abinfo "Failed to copy /etc/group: $?"

abinfo "Copying /etc/passwd ..."
cp -v "$_CONTRIBDIR"/etc-bootstrap/passwd \
    "$_STAGE0"/etc/passwd || \
    abinfo "Failed to copy /etc/passwd: $?"

abinfo "Creating basic login log files ..."
touch /var/log/{btmp,lastlog,faillog,wtmp} || \
   aberr "Failed to create basic login log files: $?"
chgrp -v utmp /var/log/lastlog || \
   aberr "Failed to set owner for /var/log/lastlog to utmp: $?"
chmod -v 664 /var/log/lastlog || \
   aberr "Failed to set permissions for /var/log/lastlog to 664: $?"
chmod -v 600 /var/log/btmp || \
   aberr "Failed to set permissions for /var/log/btmp to 600: $?"

abinfo "Setting up resolv.conf ..."
cp -v /etc/resolv.conf \
    "$_STAGE0"/etc/resolv.conf
