#!/bin/bash
# Adapted from Linux from Scratch
# Simple script to list version numbers of critical development tools

echo -e "
====
Performing environment check ...
====
"

export CXXFLAGS="-mexplicit-relocs"

# Reset LC_ALL to POSIX to ensure output consistency.
export LC_ALL=C

abinfo "Testing for basic programs ..."
for prog in \
    awk bash bison cat diff find g++ gcc gawk grep gzip ld m4 make \
    makeinfo patch perl python3 sed tar tic yacc xz; do
    abinfo "Testing if $prog exists ..."
    command -v $prog > /dev/null || \
        aberr "$prog not found."
done

_BASH=$(readlink -f /bin/sh)
abinfo "Testing if /bin/sh points to bash ..."
echo $_BASH | grep -q bash || \
    aberr "/bin/sh does not point to bash."
unset MYSH

abinfo "Testing if awk is gawk ..."
_GAWK=$(readlink -f /bin/awk)
echo $_GAWK | grep -q gawk || \
    aberr "/bin/awk does not point to gawk."

abinfo "Testing if g++ produces a binary ..."
echo 'int main(){}' > dummy.c && \
    g++ -o dummy dummy.c
if [ ! -x dummy ]; then
    aberr "g++ failed to produce a binary ..."
fi
rm -f dummy.c dummy

_ARCH=$(dpkg --print-architecture)
_HOST_TRIPLE="$(dirname $(gcc --print-prog-name=cc1))"
_HOST_TRIPLE="$(basename $(realpath $_HOST_TRIPLE/..))"
export _HOST_TRIPLE
if [ "$_ARCH" != "$KABOOM_ARCH" ] ; then
	# We are cross compiling the stage 0.
	CROSS_STAGE0=1
	abinfo "Cross compiling from $_HOST_TRIPLE to $_TARGET"
	if systemd-detect-virt -qc ; then
		abwarn "Make sure the host system has $_BINFMT registered in binfmt_misc registry."
	elif [ "${_BINFMT_SKIP/$_ARCH/}" != "${_BINFMT_SKIP}" ] ; then
		if [ "$_ARCH" = "arm64" ] ; then
			abwarn "Be aware that not all AArch64 processors are capable of running AArch32 binaries natively."
			abwarn "Please check if your machine supports 32-bit EL0 and EL1 before continuing."
		else
			abinfo "Target binaries can run natively. No binfmt support is required."
		fi
	elif [ ! -e /proc/sys/fs/binfmt_misc/"$_BINFMT" ] ; then
		aberr "Binfmt entry $_BINFMT does not exist in /proc/sys/fs/binfmt_misc."
		abdie "Make sure the corresponding qemu-user-static package is installed."
	fi
fi
