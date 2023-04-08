abinfo "gcc-pass2: Preparing sources ..."
for i in \
    gcc-$GCC_VER.tar.xz \
    gmp-$GMP_VER.tar.xz \
    mpc-$MPC_VER.tar.gz \
    mpfr-$MPFR_VER.tar.xz; do
    abinfo "gcc-pass2: Unpacking source package $i ..."
    tar xf "$_SRCDIR"/$i || \
        aberr "Failed to unpack $i for gcc-pass2 ..."
done

cd gcc-$GCC_VER
mv -v ../gmp-$GMP_VER gmp || \
    aberr "Failed to install source for gmp-$GMP_VER ..."
mv -v ../mpc-$MPC_VER mpc || \
    aberr "Failed to install source for mpc-$MPC_VER ..."
mv -v ../mpfr-$MPFR_VER mpfr || \
    aberr "Failed to install source for mpfr-$MPFR_VER ..."

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "gcc-pass2: Tweaking libstdc++ build rules to enable POSIX threading support ..."
# From Linux From Scratch:
#
# Override the building rule of libgcc and libstdc++ headers, to allow
# building these libraries with POSIX threads support.
sed -e '/thread_header =/s/@.*@/gthr-posix.h/' \
    -i libgcc/Makefile.in \
    -i libstdc++-v3/include/Makefile.in || \
    aberr "Failed to tweak libstdc++ build rules for gcc-pass2: $?"

abinfo "gcc-pass2: Creating build directory ..."
mkdir -pv build || \
    aberr "Failed to create build directory for gcc-pass2: $?"
cd build

abinfo "gcc-pass2: Running configure ..."
AUTOTOOLS_AFTER="--build=$_TARGET \
                 --host=$_TARGET \
                 --target=$_TARGET \
                 --prefix=/usr \
                 --with-build-sysroot=$_STAGE0 \
                 --with-glibc-version=$GLIBC_VER \
                 --with-zstd=no \
                 --enable-default-pie \
                 --enable-default-ssp \
                 --disable-nls \
                 --disable-multilib \
                 --disable-libatomic \
                 --disable-libgomp \
                 --disable-libquadmath \
                 --disable-libssp \
                 --disable-libvtv \
                 --enable-libstdcxx \
                 --enable-bootstrap \
                 --enable-languages=c,c++ \
                 LDFLAGS_FOR_TARGET=-L$PWD/$_TARGET/libgcc"

case $KABOOM_ARCH in
    alpha)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --with-cpu=ev4"
        ;;
    arm64)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --disable-altivec \
                 --disable-fixed-point \
                 --with-arch=armv8-a \
                 --enable-fix-cortex-a53-835769 \
                 --enable-fix-cortex-a53-843419"
        ;;
    armv4)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --with-arch=armv4 \
                 --with-tune=strongarm110 \
                 --with-float=soft"
        ;;
    armv6hf)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --disable-altivec \
                 --disable-fixed-point \
                 --with-arch=armv6 \
                 --with-tune=arm1176jzf-s \
                 --with-float=hard \
                 --with-fpu=vfpv2"
        ;;
    armv7hf)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --disable-altivec \
                 --disable-fixed-point \
                 --with-arch=armv7-a \
                 --with-float=hard \
                 --with-fpu=neon"
        ;;
    i486)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --with-cpu=i486 \
                 --with-tune=bonnell"
        ;;
    loongarch64)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --with-arch=loongarch64 \
                 --with-abi=lp64d"
        ;;
    loongson2f)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --with-abi=64 \
                 --with-arch=mips3 \
                 --with-tune=loongson2f"
        ;;
    loongson3)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --with-abi=64 \
                 --with-arch=gs464 \
                 --with-tune=gs464e \
                 --with-mips-fix-loongson3-llsc"
        ;;
    mips64r6el)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --with-arch=mips64r6 \
                 --with-tune=mips64r6"
        ;;
    powerpc)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --with-cpu=G3 \
                 --with-tune=G4 \
                 --with-long-double-128 \
                 --enable-secureplt"
        ;;
    ppc64)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --with-cpu=G5 \
                 --with-tune=G5 \
                 --with-long-double-128 \
                 --enable-secureplt"
        ;;
    ppc64el)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --with-cpu=power8 \
                 --with-tune=power9 \
                 --with-long-double-128 \
                 --with-long-double-format=ieee \
                 --enable-secureplt \
                 --enable-targets=powerpcle-linux"
        ;;
    riscv64)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --with-arch=rv64gc \
                 --with-abi=lp64d \
                 --with-isa-spec=2.2"
        ;;
esac

../configure \
    ${AUTOTOOLS_AFTER} || \
    aberr "Failed to configure gcc-pass2: $?"

abinfo "gcc-pass2: Building ..."
make || \
    aberr "Failed to build gcc-pass2: $?"

abinfo "gcc-pass2: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install gcc-pass2: $?"

abinfo "gcc-pass2: Creating a symlink for /usr/bin/cc => gcc ..."
ln -sv gcc \
    "$_STAGE0"/usr/bin/cc || \
    aberr "Failed to create the symlink for /usr/bin/cc => gcc gcc-pass2: $?"
