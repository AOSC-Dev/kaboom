abinfo "tar: Unpacking ..."
tar xf "$_SRCDIR"/tar-$TAR_VER.tar.xz || \
    aberr "Failed to unpack tar: $?"

cd tar-$TAR_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "tar: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$(config.guess) || \
    aberr "Failed to run configure for tar: $?"

abinfo "tar: Building ..."
make || \
    aberr "Failed to build tar: $?"

abinfo "tar: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install tar: $?"
