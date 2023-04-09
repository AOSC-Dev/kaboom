abinfo "flex: Unpacking ..."
tar xf "$_SRCDIR"/flex-$FLEX_VER.tar.gz || \
    aberr "Failed to unpack flex: $?"

cd flex-$FLEX_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "flex: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for flex: $?"

abinfo "flex: Building ..."
make || \
    aberr "Failed to build flex: $?"

abinfo "flex: Installing ..."
make install || \
    aberr "Failed to install flex: $?"
