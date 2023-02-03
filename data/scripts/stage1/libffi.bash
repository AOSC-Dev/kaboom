abinfo "libffi: Unpacking ..."
tar xf "$_SRCDIR"/libffi-$LIBFFI_VER.tar.gz || \
    aberr "Failed to unpack libffi: $?"

cd libffi-$LIBFFI_VER

abinfo "libffi: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for libffi: $?"

abinfo "libffi: Building ..."
make || \
    aberr "Failed to build libffi: $?"

abinfo "libffi: Installing ..."
make install || \
    aberr "Failed to install libffi: $?"
