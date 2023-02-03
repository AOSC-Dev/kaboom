abinfo "gawk: Unpacking ..."
tar xf "$_SRCDIR"/gawk-$GAWK_VER.tar.xz || \
    aberr "Failed to unpack gawk: $?"

cd gawk-$GAWK_VER

abinfo "gawk: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for gawk: $?"

abinfo "gawk: Building ..."
make || \
    aberr "Failed to build gawk: $?"

abinfo "gawk: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install gawk: $?"
