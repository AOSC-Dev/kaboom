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

abinfo "gcc: Tweaking build configurations ..."
case $KABOOM_ARCH in
    alpha)
        sed -e '/m64=/s/lib64/lib/' \
            -i gcc/config/alpha/t-linux64
        ;;
    amd64)
        sed -e '/m64=/s/lib64/lib/' \
            -i gcc/config/i386/t-linux64
        ;;
    arm64)
        sed -e '/m64=/s/lib64/lib/' \
            -i gcc/config/arm/t-linux64
        ;;
    loongarch64)
        sed -e '/m64=/s/lib64/lib/' \
            -i gcc/config/loongarch/t-linux64
        ;;
    loongson2f)
        sed -e '/m64=/s/lib64/lib/' \
            -i gcc/config/mips/t-linux64
        ;;
    loongson3)
        sed -e '/m64=/s/lib64/lib/' \
            -i gcc/config/mips/t-linux64
        ;;
    mips64r6el)
        sed -e '/m64=/s/lib64/lib/' \
            -i gcc/config/mips/t-linux64
        ;;
    ppc64)
        sed -e '/m64=/s/lib64/lib/' \
            -i gcc/config/rs6000/t-linux64
        ;;
    ppc64el)
        sed -e '/m64=/s/lib64/lib/' \
            -i gcc/config/rs6000/t-linux64
        ;;
    riscv64)
        sed -e '/m64=/s/lib64/lib/' \
            -i gcc/config/riscv/t-linux64
        ;;
esac

abinfo "gcc: Creating build directory ..."
mkdir -pv build || \
    aberr "Failed to create build directory for gcc: $?"
cd build

abinfo "gcc: Running configure ..."
AUTOTOOLS_AFTER="--build=$_TARGET \
                 --host=$_TARGET \
                 --prefix=/usr \
                 --with-glibc-version=$GLIBC_VER \
                 --enable-default-pie \
                 --enable-default-ssp \
                 --disable-multilib \
                 --enable-languages=c,c++ \
                 --with-system-zlib"

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
    aberr "Failed to configure gcc: $?"

abinfo "gcc: Building ..."
make || \
    aberr "Failed to build gcc: $?"

abinfo "gcc: Installing ..."
make install || \
    aberr "Failed to install gcc: $?"

abinfo "gcc: Creating a symlink for the LTO plugin ..."
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/12.2.0/liblto_plugin.so \
    /usr/lib/bfd-plugins/ || \
    aberr "Failed to create a symlink for the LTO plugin: $?"