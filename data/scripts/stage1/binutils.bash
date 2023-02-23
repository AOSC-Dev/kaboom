abinfo "binutils: Unpacking ..."
tar xf "$_SRCDIR"/binutils-$BINUTILS_VER.tar.xz || \
    aberr "Failed to unpack sources for binutils: $?"
cd binutils-$BINUTILS_VER

abinfo "binutils: Creating build directory ..."
mkdir -pv build || \
    aberr "Failed to create build directory for binutils: $?"
cd build

abinfo "binutils: Running configure ..."
../configure \
    --prefix=/usr \
    --build="$_TARGET" \
    --enable-gold \
    --enable-ld=default \
    --enable-plugins \
    --enable-shared \
    --disable-werror \
    --enable-64-bit-bfd \
    --with-system-zlib || \
    aberr "Failed to run configure for binutils: $?"

abinfo "binutils: Building ..."
make || \
    aberr "Failed to build binutils: $?"

abinfo "binutils: Installing ..."
make install \
    tooldir=/usr || \
    aberr "Failed to install binutils: $?"
