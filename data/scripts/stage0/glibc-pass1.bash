# FIXME: 64-bit file offset and time_t breaks build on 32-bit architectures.
# Unset to work around this issue.
export CFLAGS="${CFLAGS} -U_FILE_OFFSET_BITS -U_TIME_BITS"

abinfo "glibc-pass1: Unpacking ..."
tar xf "$_SRCDIR"/glibc-$GLIBC_VER.tar.xz || \
    aberr "Failed to unpack sources for glibc-pass1: $?"

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "glibc-pass1: Preparing the build environment ..."
mkdir -pv glibc-$GLIBC_VER/build || \
    aberr "Failed to create build directory for glibc-pass1: $?"
cd glibc-$GLIBC_VER/build

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
"$_STAGE0"/tools/libexec/gcc/$_TARGET/13.2.0/install-tools/mkheaders || \
    aberr "Failed to finalise limits.h installation (gcc-pass1): $?"

abinfo "glibc-pass1: Installing finalised limits.h (gcc-pass1) ..."
cp -v `dirname $($_TARGET-gcc -print-libgcc-file-name)`/include-fixed/* \
    `dirname $($_TARGET-gcc -print-libgcc-file-name)`/include/ || \
    aberr "Failed to install finalised limits.h (gcc-pass1): $?"
