abinfo "libstdc++: Unpacking ..."
tar xf "$_SRCDIR"/gcc-$GCC_VER.tar.xz || \
    aberr "Failed to unpack libstdc++: $?"

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "libstdc++: Creating build directory ..."
mkdir -pv gcc-$GCC_VER/build || \
    aberr "Failed to create build directory for libstdc++: $?"
cd gcc-$GCC_VER/build

abinfo "libstdc++: Running configure ..."
AUTOTOOLS_AFTER="--host=$_TARGET \
                 --build=$_TARGET \
                 --prefix=/usr \
                 --disable-multilib \
                 --disable-nls \
                 --disable-libstdcxx-pch \
                 --with-gxx-include-dir=/tools/$_TARGET/include/c++/$GCC_VER"

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

../libstdc++-v3/configure \
    ${AUTOTOOLS_AFTER} || \
    aberr "Failed to configure libstdc++: $?"

abinfo "libstdc++: Building ..."
make || \
    aberr "Failed to build libstdc++: $?"

abinfo "libstdc++: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install libstdc++: $?"

abinfo "libstdc++: Removing unwanted libtool archives (.la) ..."
rm -v "$_STAGE0"/usr/lib*/lib{stdc++,stdc++fs,supc++}.la || \
    aberr "Failed to remove unwanted libtool archives (.la) from libstdc++: $?"
