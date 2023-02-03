#!/bin/bash
# Adapted from Linux from Scratch
# Simple script to list version numbers of critical development tools

echo -e "
====
Performing environment check ...
====
"

# Reset LC_ALL to POSIX to ensure output consistency.
export LC_ALL=C

abinfo "Testing for basic programs ..."
for prog in \
    awk bash bison cat diff find g++ gcc gawk grep gzip ld m4 make \
    makeinfo patch perl sed tar tic yacc xz; do
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
