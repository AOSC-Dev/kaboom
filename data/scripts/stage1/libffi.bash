abinfo "libffi: Unpacking ..."
tar xf "$_SRCDIR"/libffi-$LIBFFI_VER.tar.gz || \
    aberr "Failed to unpack libffi: $?"

cd libffi-$LIBFFI_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "libffi: Running configure ..."
./configure \
    --prefix=/usr \
    --build=$_TARGET || \
    aberr "Failed to run configure for libffi: $?"

abinfo "libffi: Building ..."
make || \
    aberr "Failed to build libffi: $?"

abinfo "libffi: Installing ..."
make install || \
    aberr "Failed to install libffi: $?"
