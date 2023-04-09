abinfo "m4: Unpacking ..."
tar xf "$_SRCDIR"/m4-$M4_VER.tar.xz || \
    aberr "Failed to unpack m4: $?"

cd m4-$M4_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "m4: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for m4: $?"

abinfo "m4: Building ..."
make || \
    aberr "Failed to build m4: $?"

abinfo "m4: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install m4: $?"
