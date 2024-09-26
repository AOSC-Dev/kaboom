abinfo "openssl: Unpacking ..."
tar xf "$_SRCDIR"/openssl-$OPENSSL_VER.tar.gz || \
    aberr "Failed to unpack openssl: $?"

cd openssl-$OPENSSL_VER

if [ "$KABOOM_ARCH" = "amd64" ]; then
    ARCH_OPTS="linux-x86_64"
elif [ "$KABOOM_ARCH" = "arm64" ]; then
    ARCH_OPTS="linux-aarch64"
elif [ "$KABOOM_ARCH" = "armv4" ]; then
    ARCH_OPTS="linux-armv4"
elif [ "$KABOOM_ARCH" = "armv6hf" ]; then
    ARCH_OPTS="linux-armv4"
elif [ "$KABOOM_ARCH" = "armv7hf" ]; then
    ARCH_OPTS="linux-armv4"
elif [ "$KABOOM_ARCH" = "i486" ]; then
    ARCH_OPTS="linux-x86-latomic"
elif [ "$KABOOM_ARCH" = "loongson2f" ]; then
    ARCH_OPTS="linux64-mips64"
elif [ "$KABOOM_ARCH" = "loongson3" ]; then
    ARCH_OPTS="linux64-mips64"
elif [ "$KABOOM_ARCH" = "mips32r6el" ]; then
    ARCH_OPTS="linux-generic32"
elif [ "$KABOOM_ARCH" = "mips64r6el" ]; then
    ARCH_OPTS="linux-generic64"
elif [ "$KABOOM_ARCH" = "powerpc" ]; then
    ARCH_OPTS="linux-ppc"
elif [ "$KABOOM_ARCH" = "ppc64" ]; then
    ARCH_OPTS="linux-ppc64"
elif [ "$KABOOM_ARCH" = "ppc64el" ]; then
    ARCH_OPTS="linux-ppc64le"
elif [ "$KABOOM_ARCH" = "riscv64" ]; then
    ARCH_OPTS="linux64-riscv64"
fi

abinfo "openssl: Running Configure ..."
./Configure \
    --prefix=/usr \
    --openssldir=/etc/ssl \
    --libdir=lib \
    shared zlib $ARCH_OPTS || \
    aberr "Failed to run Configure for openssl: $?"

abinfo "openssl: Building ..."
make || \
    aberr "Failed to build openssl: $?"

abinfo "openssl: Installing ..."
make install || \
    aberr "Failed to install openssl: $?"
