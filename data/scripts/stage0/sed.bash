abinfo "sed: Unpacking ..."
tar xf "$_SRCDIR"/sed-$SED_VER.tar.xz || \
    aberr "Failed to unpack sed: $?"

cd sed-$SED_VER

abinfo "sed: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for sed: $?"

abinfo "sed: Building ..."
make || \
    aberr "Failed to build sed: $?"

abinfo "sed: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install sed: $?"
