abinfo "tar: Unpacking ..."
tar xf "$_SRCDIR"/tar-$TAR_VER.tar.xz || \
    aberr "Failed to unpack tar: $?"

cd tar-$TAR_VER

abinfo "tar: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for tar: $?"

abinfo "tar: Building ..."
make || \
    aberr "Failed to build tar: $?"

abinfo "tar: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install tar: $?"
