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
if [ -d "$_STAGE0"/usr/lib64 ]; then
    mv -v "$_STAGE0"/usr/lib64/* \
        "$_STAGE0"/usr/lib/ || \
        aberr "Failed to move files from /usr/lib64 => /usr/lib: $?"
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
		ln -sv lib "$_STAGE0"/usr/lib64
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

abinfo "Creating /etc/passwd ..."
cat > "$_STAGE0"/etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/usr/bin/false
systemd-journal-remote:x:74:74:systemd Journal Remote:/:/usr/bin/false
systemd-journal-upload:x:75:75:systemd Journal Upload:/:/usr/bin/false
systemd-network:x:76:76:systemd Network Management:/:/usr/bin/false
systemd-resolve:x:77:77:systemd Resolver:/:/usr/bin/false
systemd-timesync:x:78:78:systemd Time Synchronization:/:/usr/bin/false
systemd-coredump:x:79:79:systemd Core Dumper:/:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
systemd-oom:x:81:81:systemd Out Of Memory Daemon:/:/usr/bin/false
nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
EOF

abinfo "Creating /etc/group ..."
cat > "$_STAGE0"/etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
kvm:x:61:
systemd-journal-gateway:x:73:
systemd-journal-remote:x:74:
systemd-journal-upload:x:75:
systemd-network:x:76:
systemd-resolve:x:77:
systemd-timesync:x:78:
systemd-coredump:x:79:
uuidd:x:80:
systemd-oom:x:81:
wheel:x:97:
users:x:999:
nogroup:x:65534:
EOF

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

abinfo "Installing environment file ..."
cp -v "$_LIBDIR"/env.bash \
    "$_STAGE0"/.kaboomrc || \
    aberr "Failed to copy environment file: $?"
sed -e '/^export PATH/d' \
    -i "$_STAGE0"/.kaboomrc || \
    aberr "Failed to tweak environment file: $?"
