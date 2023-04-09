abinfo "gawk: Unpacking ..."
tar xf "$_SRCDIR"/gawk-$GAWK_VER.tar.xz || \
    aberr "Failed to unpack gawk: $?"

cd gawk-$GAWK_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

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
