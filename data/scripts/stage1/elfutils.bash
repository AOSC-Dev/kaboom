abinfo "elfutils: Unpacking ..."
tar xf "$_SRCDIR"/elfutils-$ELFUTILS_VER.tar.bz2 || \
    aberr "Failed to unpack elfutils: $?"

cd elfutils-$ELFUTILS_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "elfutils: Running configure ..."
./configure \
    --prefix=/usr \
    --build=$_TARGET \
    --disable-debuginfod || \
    aberr "Failed to run configure for elfutils: $?"

abinfo "elfutils: Building ..."
make || \
    aberr "Failed to build elfutils: $?"

abinfo "elfutils: Installing ..."
make install || \
    aberr "Failed to install elfutils: $?"
