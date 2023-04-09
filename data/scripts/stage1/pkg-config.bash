abinfo "pkg-config: Unpacking ..."
tar xf "$_SRCDIR"/pkg-config-$PKG_CONFIG_VER.tar.gz || \
    aberr "Failed to unpack pkg-config: $?"

cd pkg-config-$PKG_CONFIG_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "pkg-config: Running configure ..."
./configure \
    --prefix=/usr \
    --build=$_TARGET \
    --with-internal-glib \
    --disable-host-tool || \
    aberr "Failed to run configure for pkg-config: $?"

abinfo "pkg-config: Building ..."
make || \
    aberr "Failed to build pkg-config: $?"

abinfo "pkg-config: Installing ..."
make install || \
    aberr "Failed to install pkg-config: $?"
