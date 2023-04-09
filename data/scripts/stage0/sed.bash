abinfo "sed: Unpacking ..."
tar xf "$_SRCDIR"/sed-$SED_VER.tar.xz || \
    aberr "Failed to unpack sed: $?"

cd sed-$SED_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "sed: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for sed: $?"

abinfo "sed: Building ..."
make || \
    aberr "Failed to build sed: $?"

abinfo "sed: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install sed: $?"
