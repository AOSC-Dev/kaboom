abinfo "nano: Unpacking ..."
tar xf "$_SRCDIR"/nano-$NANO_VER.tar.xz || \
    aberr "Failed to unpack nano: $?"

cd nano-$NANO_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "nano: Running configure ..."
./configure \
    --prefix=/usr \
    --build=$_TARGET || \
    aberr "Failed to run configure for nano: $?"

abinfo "nano: Building ..."
make || \
    aberr "Failed to build nano: $?"

abinfo "nano: Installing ..."
make install || \
    aberr "Failed to install nano: $?"
