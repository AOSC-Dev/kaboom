abinfo "autoconf: Unpacking ..."
tar xf "$_SRCDIR"/autoconf-$AUTOCONF_VER.tar.xz || \
    aberr "Failed to unpack autoconf: $?"

cd autoconf-$AUTOCONF_VER

abinfo "autoconf: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for autoconf: $?"

abinfo "autoconf: Building ..."
make || \
    aberr "Failed to build autoconf: $?"

abinfo "autoconf: Installing ..."
make install || \
    aberr "Failed to install autoconf: $?"
