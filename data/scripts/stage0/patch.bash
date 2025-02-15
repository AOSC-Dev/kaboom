abinfo "patch: Unpacking ..."
tar xf "$_SRCDIR"/patch-$PATCH_VER.tar.xz || \
    aberr "Failed to unpack patch: $?"

cd patch-$PATCH_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "patch: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$(config.guess) || \
    aberr "Failed to run configure for patch: $?"

abinfo "patch: Building ..."
make || \
    aberr "Failed to build patch: $?"

abinfo "patch: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install patch: $?"
