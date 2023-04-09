abinfo "diffutils: Unpacking ..."
tar xf "$_SRCDIR"/diffutils-$DIFFUTILS_VER.tar.xz || \
    aberr "Failed to unpack diffutils: $?"

cd diffutils-$DIFFUTILS_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "diffutils: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for diffutils: $?"

abinfo "diffutils: Building ..."
make || \
    aberr "Failed to build diffutils: $?"

abinfo "diffutils: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install diffutils: $?"
