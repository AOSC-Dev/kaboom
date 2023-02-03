abinfo "zlib: Unpacking ..."
tar xf "$_SRCDIR"/v$ZLIB_VER.tar.gz || \
    aberr "Failed to unpack zlib: $?"

cd zlib-$ZLIB_VER

abinfo "zlib: Running configure ..."
./configure \
    --prefix=/usr || \
    aberr "Failed to run configure for zlib: $?"

abinfo "zlib: Building ..."
make || \
    aberr "Failed to build zlib: $?"

abinfo "zlib: Installing ..."
make install || \
    aberr "Failed to install zlib: $?"
