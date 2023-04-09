abinfo "expat: Unpacking ..."
tar xf "$_SRCDIR"/expat-$EXPAT_VER.tar.xz || \
    aberr "Failed to unpack expat: $?"

cd expat-$EXPAT_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "expat: Running configure ..."
./configure \
    --prefix=/usr \
    --build=$_TARGET || \
    aberr "Failed to run configure for expat: $?"

abinfo "expat: Building ..."
make || \
    aberr "Failed to build expat: $?"

abinfo "expat: Installing ..."
make install || \
    aberr "Failed to install expat: $?"
