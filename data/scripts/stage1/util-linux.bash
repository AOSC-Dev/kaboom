abinfo "util-linux: Unpacking ..."
tar xf "$_SRCDIR"/util-linux-$UTIL_LINUX_VER.tar.xz || \
    aberr "Failed to unpack util-linux: $?"

cd util-linux-$UTIL_LINUX_VER

abinfo "util-linux: Running configure ..."
./configure \
    --host=$_TARGET \
    --build=$_TARGET \
    --libdir=/usr/lib    \
    --disable-chfn-chsh  \
    --disable-login      \
    --disable-nologin    \
    --disable-su         \
    --disable-setpriv    \
    --disable-runuser    \
    --disable-pylibmount \
    --disable-static     \
    --without-python || \
    aberr "Failed to run configure for util-linux: $?"

abinfo "util-linux: Building ..."
make || \
    aberr "Failed to build util-linux: $?"

abinfo "util-linux: Installing ..."
make install || \
    aberr "Failed to install util-linux: $?"
