abinfo "libmd: Unpacking ..."
tar xf "$_SRCDIR"/libmd-$LIBMD_VER.tar.xz || \
    aberr "Failed to unpack libmd: $?"

cd libmd-$LIBMD_VER

abinfo "libmd: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for libmd: $?"

abinfo "libmd: Building ..."
make || \
    aberr "Failed to build libmd: $?"

abinfo "libmd: Installing ..."
make install || \
    aberr "Failed to install libmd: $?"
