abinfo "dpkg: Unpacking ..."
tar xf "$_SRCDIR"/dpkg_$DPKG_VER.tar.xz || \
    aberr "Failed to unpack dpkg: $?"

cd dpkg-$DPKG_VER

abinfo "dpkg: Applying architecture name hack patches ..."
if [ -e "$_CONTRIBDIR"/dpkg-patches/*.patch.$KABOOM_ARCH ]; then
    for archpatch in "$_CONTRIBDIR"/dpkg-patches/*.patch.$KABOOM_ARCH; do
        abinfo "Applying $archpatch ..."
        patch -Np1 -i $archpatch || \
            abinfo "Failed to apply $archpatch: $?"
    done
fi

abinfo "dpkg: Running configure ..."
# FIXME: When --build= is specified, dpkg could not recognise our arch hack.
if [[ "$KABOOM_ARCH" != "loongson2f" && \
      "$KABOOM_ARCH" != "loongson3" ]]; then
    ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --build=$_TARGET || \
        aberr "Failed to run configure for dpkg: $?"
else
    ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --localstatedir=/var || \
        aberr "Failed to run configure for dpkg: $?"
fi

abinfo "dpkg: Building ..."
make || \
    aberr "Failed to build dpkg: $?"

abinfo "dpkg: Installing ..."
make install || \
    aberr "Failed to install dpkg: $?"

abinfo "dpkg: Creating skeleton database files ..."
touch \
    /var/lib/dpkg/available \
    /var/lib/dpkg/status || \
    aberr "Failed to create skeleton database files: $?"
