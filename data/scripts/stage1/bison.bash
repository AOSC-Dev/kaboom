abinfo "bison: Unpacking ..."
tar xf "$_SRCDIR"/bison-$BISON_VER.tar.xz || \
    aberr "Failed to unpack bison: $?"

cd bison-$BISON_VER

abinfo "bison: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for bison: $?"

abinfo "bison: Building ..."
make || \
    aberr "Failed to build bison: $?"

abinfo "bison: Installing ..."
make install || \
    aberr "Failed to install bison: $?"
