abinfo "findutils: Unpacking ..."
tar xf "$_SRCDIR"/findutils-$FINDUTILS_VER.tar.xz || \
    aberr "Failed to unpack findutils: $?"

cd findutils-$FINDUTILS_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "findutils: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$(config.guess) || \
    aberr "Failed to run configure for findutils: $?"

abinfo "findutils: Building ..."
make || \
    aberr "Failed to build findutils: $?"

abinfo "findutils: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install findutils: $?"
