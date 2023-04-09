abinfo "zlib: Unpacking ..."
tar xf "$_SRCDIR"/v$ZLIB_VER.tar.gz || \
    aberr "Failed to unpack zlib: $?"

cd zlib-$ZLIB_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "zlib: Running configure ..."
./configure \
    --prefix=/usr || \
    aberr "Failed to run configure for zlib: $?"

abinfo "zlib: Building ..."
make || \
    aberr "Failed to build zlib: $?"

abinfo "zlib: Installing ..."
make install || \
    aberr "Failed to install zlib: $?"
