abinfo "gcc: Preparing sources ..."
for i in \
    gcc-$GCC_VER.tar.xz \
    gmp-$GMP_VER.tar.xz \
    mpc-$MPC_VER.tar.gz \
    mpfr-$MPFR_VER.tar.xz; do
    abinfo "gcc: Unpacking source package $i ..."
    tar xf "$_SRCDIR"/$i || \
        aberr "Failed to unpack $i for gcc ..."
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

abinfo "gcc: Creating build directory ..."
mkdir -pv build || \
    aberr "Failed to create build directory for gcc: $?"
cd build

# FIXME: Use stage1 binutils (ar) to workaround linkage failure - may be
# related to cross-time_t builds.
#
# /usr/i486-kaboom-linux-gnu/bin/ar \
#     --plugin /build/stage1/gcc/gcc-14.2.0/build/./gcc/liblto_plugin.so \
#     x "/build/stage1/gcc/gcc-14.2.0/build/i486-kaboom-linux-gnu/libstdc++-v3/src/experimental/../../src/c++23/.libs/libc++23convenience.a"
#
# libc++23convenience.a is not a valid archive
abinfo "gcc: Running configure ..."
AUTOTOOLS_AFTER="--build=$_TARGET \
                 --prefix=/usr \
                 --enable-default-pie \
                 --enable-default-ssp \
                 --disable-multilib \
                 --enable-languages=c,c++ \
                 --with-system-zlib \
                 --disable-bootstrap \
                 AR_FOR_TARGET=/usr/bin/ar"

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
    mips32r6el)
        AUTOTOOLS_AFTER=" \
                 ${AUTOTOOLS_AFTER} \
                 --with-arch=mips32r6 \
                 --with-tune=mips32r6"
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
    aberr "Failed to configure gcc: $?"

abinfo "gcc: Building ..."
make || \
    aberr "Failed to build gcc: $?"

abinfo "gcc: Installing ..."
make install || \
    aberr "Failed to install gcc: $?"

abinfo "gcc: Creating a symlink for the LTO plugin ..."
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/$GCC_VER/liblto_plugin.so \
    /usr/lib/bfd-plugins/ || \
    aberr "Failed to create a symlink for the LTO plugin: $?"
