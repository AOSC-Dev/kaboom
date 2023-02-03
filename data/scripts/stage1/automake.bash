abinfo "automake: Unpacking ..."
tar xf "$_SRCDIR"/automake-$AUTOMAKE_VER.tar.xz || \
    aberr "Failed to unpack automake: $?"

cd automake-$AUTOMAKE_VER

abinfo "automake: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for automake: $?"

abinfo "automake: Building ..."
make || \
    aberr "Failed to build automake: $?"

abinfo "automake: Installing ..."
make install || \
    aberr "Failed to install automake: $?"
