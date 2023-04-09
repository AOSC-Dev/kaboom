abinfo "autoconf: Unpacking ..."
tar xf "$_SRCDIR"/autoconf-$AUTOCONF_VER.tar.xz || \
    aberr "Failed to unpack autoconf: $?"

cd autoconf-$AUTOCONF_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "autoconf: Running configure ..."
./configure \
    --prefix=/usr \
    --build=$_TARGET || \
    aberr "Failed to run configure for autoconf: $?"

abinfo "autoconf: Building ..."
make || \
    aberr "Failed to build autoconf: $?"

abinfo "autoconf: Installing ..."
make install || \
    aberr "Failed to install autoconf: $?"
