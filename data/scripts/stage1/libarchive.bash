abinfo "libarchive: Unpacking ..."
tar xf "$_SRCDIR"/libarchive-$LIBARCHIVE_VER.tar.xz || \
    aberr "Failed to unpack libarchive: $?"

cd libarchive-$LIBARCHIVE_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "libarchive: Running configure ..."
./configure \
    --prefix=/usr \
    --build=$_TARGET || \
    aberr "Failed to run configure for libarchive: $?"

abinfo "libarchive: Building ..."
make || \
    aberr "Failed to build libarchive: $?"

abinfo "libarchive: Installing ..."
make install || \
    aberr "Failed to install libarchive: $?"
