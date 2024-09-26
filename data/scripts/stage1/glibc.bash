# FIXME: 64-bit file offset and time_t breaks build on 32-bit architectures.
# Unset to work around this issue.
export CFLAGS="${CFLAGS} -U_FILE_OFFSET_BITS -U_TIME_BITS"

abinfo "glibc: Unpacking ..."
tar xf "$_SRCDIR"/glibc-$GLIBC_VER.tar.xz || \
    aberr "Failed to unpack sources for glibc: $?"

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "glibc: Preparing the build environment ..."
mkdir -pv glibc-$GLIBC_VER/build || \
    aberr "Failed to create build directory for glibc: $?"
cd glibc-$GLIBC_VER/build

abinfo "glibc: Running configure ..."
# Note: Set minimum kernel version to lowest branch used by mainline
# architectures.
../configure \
    --prefix=/usr \
    --build=$_TARGET \
    --enable-kernel=5.4 \
    --with-headers=/usr/include \
    libc_cv_slibdir=/usr/lib || \
    aberr "Failed to run configure for glibc: $?"

abinfo "glibc: Tweaking Makefile to skip a broken sanity check ..."
# From Linux From Scratch:
#
# Fix the Makefile to skip an unneeded sanity check that fails in the LFS
# partial environment.
sed -e '/test-installation/s@$(PERL)@echo not running@' \
    -i ../Makefile

abinfo "glibc: Building ..."
make || \
    aberr "Failed to build glibc: $?"

abinfo "glibc: Installing ..."
make install || \
    aberr "Failed to install glibc: $?"

abinfo "Creating /etc/ld.so.conf ..."
cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

# Add an include directory
include /etc/ld.so.conf.d/*.conf
EOF

abinfo "glibc: Adjusting ldd ..."
# From Linux from Scratch:
#
# Fix a hard coded path to the executable loader in the ldd script.
sed -e '/RTLDLIST=/s@/usr@@g' \
    -i /usr/bin/ldd || \
    aberr "Failed to adjust ldd: $?"

abinfo "glibc: Generating and installing locale data ..."
make localedata/install-locales || \
    aberr "Failed to generate and install locale data: $?"
