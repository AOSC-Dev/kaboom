abinfo "libmd: Unpacking ..."
tar xf "$_SRCDIR"/libmd-$LIBMD_VER.tar.xz || \
    aberr "Failed to unpack libmd: $?"

cd libmd-$LIBMD_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "libmd: Running configure ..."
./configure \
    --prefix=/usr \
    --build=$_TARGET || \
    aberr "Failed to run configure for libmd: $?"

abinfo "libmd: Building ..."
make || \
    aberr "Failed to build libmd: $?"

abinfo "libmd: Installing ..."
make install || \
    aberr "Failed to install libmd: $?"
