abinfo "glibc-pass1: Unpacking ..."
tar xf "$_SRCDIR"/glibc-$GLIBC_VER.tar.xz || \
    aberr "Failed to unpack sources for glibc-pass1: $?"

abinfo "glibc-pass1: Preparing the build environment ..."
mkdir -pv glibc-$GLIBC_VER/build || \
    aberr "Failed to create build directory for glibc-pass1: $?"
cd glibc-$GLIBC_VER/build

if [[ "$KABOOM_ARCH" = "ppc64el" ]]; then
    abinfo "Storing default flags ..."
    export _CFLAGS="${CFLAGS}"

    abinfo "Dropping conflicting -mvsx flag ..."
    export CFLAGS="${CFLAGS/-mpower8-vector/}"
fi

abinfo "glibc-pass1: Running configure ..."
# Note: Set minimum kernel version to lowest branch used by mainline
# architectures.
../configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET \
    --enable-kernel=5.4 \
    --with-headers=$_STAGE0/usr/include \
    libc_cv_slibdir=/usr/lib || \
    aberr "Failed to run configure for glibc-pass1: $?"

abinfo "glibc-pass1: Building ..."
make || \
    aberr "Failed to build glibc-pass1: $?"

abinfo "glibc-pass1: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install glibc-pass1: $?"

abinfo "glibc-pass1: Adjusting ldd ..."
# From Linux from Scratch:
#
# Fix a hard coded path to the executable loader in the ldd script.
sed -e '/RTLDLIST=/s@/usr@@g' \
    -i "$_STAGE0"/usr/bin/ldd || \
    aberr "Failed to adjust ldd: $?"

abinfo "glibc-pass1: Finalising limits.h installation (gcc-pass1) ..."
"$_STAGE0"/tools/libexec/gcc/$_TARGET/12.2.0/install-tools/mkheaders || \
    aberr "Failed to finalise limits.h installation (gcc-pass1) ..."

if [[ "$KABOOM_ARCH" = "ppc64el" ]]; then
    abinfo "Resetting default flags ..."
    export CFLAGS="${_CFLAGS}"
fi