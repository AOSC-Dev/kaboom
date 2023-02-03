abinfo "m4: Unpacking ..."
tar xf "$_SRCDIR"/m4-$M4_VER.tar.xz || \
    aberr "Failed to unpack m4: $?"

cd m4-$M4_VER

abinfo "m4: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for m4: $?"

abinfo "m4: Building ..."
make || \
    aberr "Failed to build m4: $?"

abinfo "m4: Installing ..."
make install || \
    aberr "Failed to install m4: $?"
