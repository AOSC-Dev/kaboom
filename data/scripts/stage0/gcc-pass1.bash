abinfo "gcc-pass1: Preparing sources ..."
for i in \
    gcc-$GCC_VER.tar.xz \
    gmp-$GMP_VER.tar.xz \
    mpc-$MPC_VER.tar.gz \
    mpfr-$MPFR_VER.tar.xz; do
    abinfo "gcc-pass1: Unpacking source package $i ..."
    tar xf "$_SRCDIR"/$i || \
        aberr "Failed to unpack $i for gcc-pass1 ..."
done

cd gcc
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

abinfo "gcc-pass1: Creating build directory ..."
mkdir -pv build || \
    aberr "Failed to create build directory for gcc-pass1: $?"
cd build

abinfo "gcc-pass1: Running configure ..."
AUTOTOOLS_AFTER="--target=$_TARGET \
                 --prefix=$_STAGE0/tools \
                 --with-glibc-version=$GLIBC_VER \
                 --with-sysroot=$_STAGE0 \
                 --with-newlib \
                 --without-headers \
                 --with-zstd=no \
                 --enable-default-pie \
                 --enable-default-ssp \
                 --disable-nls \
                 --disable-shared \
                 --disable-multilib \
                 --disable-threads \
                 --disable-libatomic \
                 --disable-libgomp \
                 --disable-libquadmath \
                 --disable-libssp \
                 --disable-libvtv \
                 --disable-libstdcxx \
                 --enable-languages=c,c++"

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
                 --with-arch=la464 \
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
    aberr "Failed to configure gcc-pass1: $?"

abinfo "gcc-pass1: Building ..."
make || \
    aberr "Failed to build gcc-pass1: $?"

abinfo "gcc-pass1: Installing ..."
make install || \
    aberr "Failed to install gcc-pass1: $?"

abinfo "gcc-pass1: Generating limits.h ..."
# From Linux From Scratch:
#
# This build of GCC has installed a couple of internal system headers.
# Normally one of them, limits.h, would in turn include the corresponding
# system limits.h header, in this case, $LFS/usr/include/limits.h. However,
# at the time of this build of GCC $LFS/usr/include/limits.h does not exist,
# so the internal header that has just been installed is a partial,
# self-contained file and does not include the extended features of the system
# header. This is adequate for building Glibc, but the full internal header
# will be needed later. Create a full version of the internal header using a
# command that is identical to what the GCC build system does in normal
# circumstances.
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
    `dirname $($_TARGET-gcc -print-libgcc-file-name)`/install-tools/include/limits.h || \
    aberr "Failed to generate limits.h for gcc-pass1: $?"
