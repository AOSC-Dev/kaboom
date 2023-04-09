abinfo "texinfo: Unpacking ..."
tar xf "$_SRCDIR"/texinfo-$TEXINFO_VER.tar.xz || \
    aberr "Failed to unpack texinfo: $?"

cd texinfo-$TEXINFO_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

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
