abinfo "binutils-pass1: Unpacking ..."
tar xf "$_SRCDIR"/binutils-$BINUTILS_VER.tar.xz || \
    aberr "Failed to unpack sources for binutils-pass1: $?"
cd binutils-$BINUTILS_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "binutils-pass1: Creating build directory ..."
mkdir -pv build || \
    aberr "Failed to create build directory for binutils-pass1: $?"
cd build

abinfo "binutils-pass1: Running configure ..."
../configure \
    --prefix="$_STAGE0"/tools \
    --with-sysroot="$_STAGE0" \
    --target="$_TARGET" \
    --disable-nls \
    --enable-gprofng=no \
    --disable-werror || \
    aberr "Failed to run configure for binutils-pass1: $?"

abinfo "binutils-pass1: Building ..."
make || \
    aberr "Failed to build binutils-pass1: $?"

abinfo "binutils-pass1: Installing ..."
make install || \
    aberr "Failed to install binutils-pass1: $?"
