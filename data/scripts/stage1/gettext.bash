abinfo "gettext: Unpacking ..."
tar xf "$_SRCDIR"/gettext-$GETTEXT_VER.tar.xz || \
    aberr "Failed to unpack gettext: $?"

cd gettext-$GETTEXT_VER

abinfo "gettext: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET \
    --disable-shared || \
    aberr "Failed to run configure for gettext: $?"

abinfo "gettext: Building ..."
make || \
    aberr "Failed to build gettext: $?"

abinfo "gettext: Installing ..."
make install || \
    aberr "Failed to install gettext: $?"
