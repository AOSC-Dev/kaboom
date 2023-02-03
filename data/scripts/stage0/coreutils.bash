abinfo "coreutils: Unpacking ..."
tar xf "$_SRCDIR"/coreutils-$COREUTILS_VER.tar.xz || \
    aberr "Failed to unpack coreutils: $?"

cd coreutils-$COREUTILS_VER

abinfo "coreutils: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET \
    --enable-install-program=hostname \
    --enable-no-install-program=kill,uptime || \
    aberr "Failed to run configure for coreutils: $?"

abinfo "coreutils: Building ..."
make || \
    aberr "Failed to build coreutils: $?"

abinfo "coreutils: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install coreutils: $?"
