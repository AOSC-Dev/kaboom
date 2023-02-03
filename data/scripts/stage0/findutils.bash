abinfo "findutils: Unpacking ..."
tar xf "$_SRCDIR"/findutils-$FINDUTILS_VER.tar.xz || \
    aberr "Failed to unpack findutils: $?"

cd findutils-$FINDUTILS_VER

abinfo "findutils: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for findutils: $?"

abinfo "findutils: Building ..."
make || \
    aberr "Failed to build findutils: $?"

abinfo "findutils: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install findutils: $?"
