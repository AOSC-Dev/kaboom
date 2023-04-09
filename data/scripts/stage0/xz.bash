abinfo "xz: Unpacking ..."
tar xf "$_SRCDIR"/xz-$XZ_VER.tar.xz || \
    aberr "Failed to unpack xz: $?"

cd xz-$XZ_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "xz: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET \
    --enable-shared || \
    aberr "Failed to run configure for xz: $?"

abinfo "xz: Building ..."
make || \
    aberr "Failed to build xz: $?"

abinfo "xz: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install xz: $?"

abinfo "xz: Removing an unwanted libtool archive (.la) ..."
rm -v "$_STAGE0"/usr/lib/liblzma.la || \
    aberr "Failed to remove the unwanted libtool archive (.la) from xz: $?"
