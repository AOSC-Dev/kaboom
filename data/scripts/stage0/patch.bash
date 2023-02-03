abinfo "patch: Unpacking ..."
tar xf "$_SRCDIR"/patch-$PATCH_VER.tar.xz || \
    aberr "Failed to unpack patch: $?"

cd patch-$PATCH_VER

abinfo "patch: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for patch: $?"

abinfo "patch: Building ..."
make || \
    aberr "Failed to build patch: $?"

abinfo "patch: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install patch: $?"
