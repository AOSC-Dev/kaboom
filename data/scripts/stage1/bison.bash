abinfo "bison: Unpacking ..."
tar xf "$_SRCDIR"/bison-$BISON_VER.tar.xz || \
    aberr "Failed to unpack bison: $?"

cd bison-$BISON_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "bison: Running configure ..."
./configure \
    --prefix=/usr \
    --build=$_TARGET || \
    aberr "Failed to run configure for bison: $?"

abinfo "bison: Building ..."
make || \
    aberr "Failed to build bison: $?"

abinfo "bison: Installing ..."
make install || \
    aberr "Failed to install bison: $?"
