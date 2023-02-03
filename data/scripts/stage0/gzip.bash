abinfo "gzip: Unpacking ..."
tar xf "$_SRCDIR"/gzip-$GZIP_VER.tar.xz || \
    aberr "Failed to unpack gzip: $?"

cd gzip-$GZIP_VER

abinfo "gzip: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for gzip: $?"

abinfo "gzip: Building ..."
make || \
    aberr "Failed to build gzip: $?"

abinfo "gzip: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install gzip: $?"
