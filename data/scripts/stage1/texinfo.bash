abinfo "texinfo: Unpacking ..."
tar xf "$_SRCDIR"/texinfo-$TEXINFO_VER.tar.xz || \
    aberr "Failed to unpack texinfo: $?"

cd texinfo-$TEXINFO_VER

abinfo "texinfo: Running configure ..."
./configure \
    --prefix=/usr \
    --build=$_TARGET || \
    aberr "Failed to run configure for texinfo: $?"

abinfo "texinfo: Building ..."
make || \
    aberr "Failed to build texinfo: $?"

abinfo "texinfo: Installing ..."
make install || \
    aberr "Failed to install texinfo: $?"
