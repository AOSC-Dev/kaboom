abinfo "binutils: Unpacking ..."
tar xf "$_SRCDIR"/binutils-$BINUTILS_VER.tar.xz || \
    aberr "Failed to unpack sources for binutils: $?"
cd binutils-$BINUTILS_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "binutils: Creating build directory ..."
mkdir -pv build || \
    aberr "Failed to create build directory for binutils: $?"
cd build

abinfo "binutils: Running configure ..."
../configure \
    --prefix=/usr \
    --build="$_TARGET" \
    --host="$_TARGET" \
    --disable-gold \
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
