abinfo "nano: Unpacking ..."
tar xf "$_SRCDIR"/nano-$NANO_VER.tar.xz || \
    aberr "Failed to unpack nano: $?"

cd nano-$NANO_VER

abinfo "nano: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for nano: $?"

abinfo "nano: Building ..."
make || \
    aberr "Failed to build nano: $?"

abinfo "nano: Installing ..."
make install || \
    aberr "Failed to install nano: $?"
