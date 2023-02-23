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

# Obtain group/passwd templates from the following link:
#
# https://repo.aosc.io/aosc-repacks/etc-bootstrap.tar.xz
abinfo "Creating /etc/passwd ..."
cat > "$_STAGE0"/etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
dbus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
systemd-journal-gateway:x:994:994:systemd Journal Gateway:/:/sbin/nologin
systemd-bus-proxy:x:993:993:systemd Bus Proxy:/:/sbin/nologin
systemd-network:x:992:992:systemd Network Management:/:/sbin/nologin
systemd-resolve:x:991:991:systemd Resolver:/:/sbin/nologin
systemd-timesync:x:990:990:systemd Time Synchronization:/:/sbin/nologin
systemd-journal-remote:x:989:989:systemd Journal Remote:/:/sbin/nologin
systemd-journal-upload:x:988:988:systemd Journal Upload:/:/sbin/nologin
ldap:x:439:439:LDAP daemon owner:/var/lib/openldap:/bin/bash
http:x:207:207:HTTP daemon:/srv/http:/bin/true
uuidd:x:209:209:UUIDD user:/dev/null:/bin/true
locate:x:191:191:Locate daemon owner:/var/lib/mlocate:/bin/bash
polkitd:x:27:27:PolicyKit Daemon Owner:/etc/polkit-1:/bin/false
rtkit:x:133:133:RealtimeKit User:/proc:/sbin/nologin
named:x:40:40:BIND DNS Server:/var/named:/sbin/nologin
tss:x:159:159:Account used by the trousers package to sandbox the tcsd daemon:/dev/null:/sbin/nologin
unbound:x:986:986:unbound:/etc/unbound:/bin/false
systemd-coredump:x:985:985:systemd Core Dumper:/:/sbin/nologin
_apt:x:984:984::/var/lib/apt:/sbin/nologin
EOF

abinfo "Creating /etc/group ..."
cat > "$_STAGE0"/etc/group << "EOF"
root:x:0:
bin:x:1:
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
mail:x:34:
nogroup:x:99:
systemd-journal:x:23:
netdev:x:86:
pulse-access:x:59:
plugdev:x:999:
scanner:x:70:
network:x:135:
dbus:x:18:
adm:x:998:
wheel:x:997:
lock:x:996:
input:x:995:
systemd-journal-gateway:x:994:
systemd-bus-proxy:x:993:
systemd-network:x:992:
systemd-resolve:x:991:
systemd-timesync:x:990:
systemd-journal-remote:x:989:
systemd-journal-upload:x:988:
ldap:x:439:
mem:x:200:
ftp:x:201:
uucp:x:202:
log:x:203:
rfkill:x:204:
smmsp:x:205:
proc:x:206:
http:x:207:
games:x:208:
uuidd:x:209:
storage:x:210:
power:x:211:
locate:x:191:
polkitd:x:27:
rtkit:x:133:
named:x:40:
tss:x:159:
unbound:x:986:
systemd-coredump:x:985:
kvm:x:987:
users:x:1000:
render:x:983:
systemd-nogroup:x:65534:
_apt:x:984:
nobody:x:982:
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
