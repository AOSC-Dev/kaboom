abinfo "bzip2: Unpacking ..."
tar xf "$_SRCDIR"/bzip2-$BZIP2_VER.tar.gz || \
    aberr "Failed to unpack bzip2: $?"

cd bzip2-$BZIP2_VER

abinfo "bzip2: Building ..."
make \
    -f Makefile-libbz2_so \
    CC="gcc ${CFLAGS} -fPIC"

abinfo "bzip2: Building bzip2, bzip2recover ..."
make bzip2 bzip2recover

abinfo "bzip2: Installing executables ..."
install -Dvm755 bzip2-shared \
    /usr/bin/bzip2
install -Dvm755 bz{ip2recover,diff,grep,more} \
    -t /usr/bin/

abinfo "bzip2: Creating bunzip2, bzcat symlinks ..."
ln -sv bzip2 \
    /usr/bin/bunzip2
ln -sv bzip2 \
    /usr/bin/bzcat

abinfo "bzip2: Installing runtime libraries ..."
install -Dvm644 libbz2.a \
    /usr/lib/libbz2.a
install -Dvm755 libbz2.so.$BZIP2_VER \
    /usr/lib/libbz2.so.$BZIP2_VER
ln -sv libbz2.so.$BZIP2_VER \
    /usr/lib/libbz2.so
ln -sv libbz2.so.$BZIP2_VER \
    /usr/lib/libbz2.so.${BZIP2_VER:0:1}
ln -sv libbz2.so.$BZIP2_VER \
    /usr/lib/libbz2.so.${BZIP2_VER:0:3}

abinfo "Installing bzlib.h ..."
install -Dvm644 bzlib.h \
    /usr/include/bzlib.h
