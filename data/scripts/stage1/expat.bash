abinfo "expat: Unpacking ..."
tar xf "$_SRCDIR"/expat-$EXPAT_VER.tar.xz || \
    aberr "Failed to unpack expat: $?"

cd expat-$EXPAT_VER

abinfo "expat: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for expat: $?"

abinfo "expat: Building ..."
make || \
    aberr "Failed to build expat: $?"

abinfo "expat: Installing ..."
make install || \
    aberr "Failed to install expat: $?"
