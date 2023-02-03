abinfo "make: Unpacking ..."
tar xf "$_SRCDIR"/make-$MAKE_VER.tar.gz || \
    aberr "Failed to unpack make: $?"

cd make-$MAKE_VER

abinfo "make: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET \
    --without-guile || \
    aberr "Failed to run configure for make: $?"

abinfo "make: Building ..."
make || \
    aberr "Failed to build make: $?"

abinfo "make: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install make: $?"
