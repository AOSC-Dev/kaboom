abinfo "zlib: Unpacking ..."
tar xf "$_SRCDIR"/$ZLIB_VER.tar.gz || \
    aberr "Failed to unpack zlib: $?"

cd zlib-ng-$ZLIB_VER

abinfo "zlib: Running configure ..."
./configure \
    --prefix=/usr \
    --zlib-compat || \
    aberr "Failed to run configure for zlib: $?"

abinfo "zlib: Building ..."
make || \
    aberr "Failed to build zlib: $?"

abinfo "zlib: Installing ..."
make install || \
    aberr "Failed to install zlib: $?"
