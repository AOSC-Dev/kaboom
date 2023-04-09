abinfo "automake: Unpacking ..."
tar xf "$_SRCDIR"/automake-$AUTOMAKE_VER.tar.xz || \
    aberr "Failed to unpack automake: $?"

cd automake-$AUTOMAKE_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "automake: Running configure ..."
./configure \
    --prefix=/usr \
    --build=$_TARGET || \
    aberr "Failed to run configure for automake: $?"

abinfo "automake: Building ..."
make || \
    aberr "Failed to build automake: $?"

abinfo "automake: Installing ..."
make install || \
    aberr "Failed to install automake: $?"
