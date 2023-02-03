# Define triple and build flags.
# Build flags adapted from Autobuild3.
case $KABOOM_ARCH in
    alpha)
        _STAGE0_TARGET="alpha-aosc-linux-gnu"
        _FLAGS="-Os -mieee -mcpu=ev4"
        ;;
    amd64)
        _STAGE0_TARGET="x86_64-aosc-linux-gnu"
        _FLAGS="-O2 -fomit-frame-pointer -march=x86-64 -mtune=sandybridge -msse2"
        ;;
    arm64)
        _STAGE0_TARGET="aarch64-aosc-linux-gnu"
        _FLAGS="-O2 -march=armv8-a -mtune=cortex-a53"
        ;;
    armv4)
        _STAGE0_TARGET="arm-aosc-linux-gnueabi"
        _FLAGS="-Os -march=armv4 -mtune=strongarm110 -mfloat-abi=soft"
        ;;
    armv6hf)
        _STAGE0_TARGET="arm-aosc-linux-gnueabihf"
        _FLAGS="-O2 -march=armv6 -mtune=arm1176jz-s -mfloat-abi=hard"
        ;;
    armv7hf)
        _STAGE0_TARGET="arm-aosc-linux-gnueabihf"
        _FLAGS="-Os -march=armv7-a -mtune=cortex-a7 -mfloat-abi=hard -mfpu=neon -mthumb"
        ;;
    i486)
        _STAGE0_TARGET="i486-aosc-linux-gnu"
        _FLAGS="-Os -march=i486 -mtune=bonnell -ffunction-sections -fdata-sections"
        ;;
    loongarch64)
        _STAGE0_TARGET="loongarch64-aosc-linux-gnu"
        _FLAGS="-O2 -mabi=lp64d -march=loongarch64 -mtune=loongarch64"
        ;;
    loongson2f)
        _STAGE0_TARGET="mips64el-aosc-linux-gnuabi64"
        _FLAGS="-O2 -mabi=64 -march=mips3 -mtune=loongson2f -mloongson-mmi -Wa,-mfix-loongson2f-nop"
        ;;
    loongson3)
        _STAGE0_TARGET="mips64el-aosc-linux-gnuabi64"
        _FLAGS="-O2 -mabi=64 -march=gs464 -mtune=gs464e -mfix-loongson3-llsc -mxgot"
        ;;
    mips64r6el)
        _STAGE0_TARGET="mipsisa64r6el-aosc-linux-gnuabi64"
        _FLAGS="-O2 -march=mips64r6 -mtune=mips64r6 -mcompact-branches=always"
        ;;
    m68k)
        _STAGE0_TARGET="m68k-aosc-linux-gnu"
        _FLAGS="-Os"
        ;;
    powerpc)
        _STAGE0_TARGET="powerpc-aosc-linux-gnu"
        _FLAGS="-Os -m32 -mcpu=G3 -mtune=G4 -mno-altivec -msecure-plt -mhard-float"
        ;;
    ppc64)
        _STAGE0_TARGET="powerpc64-aosc-linux-gnu"
        _FLAGS="-Os -m64 -mcpu=G5 -maltivec -mabi=altivec -msecure-plt -mhard-float"
        ;;
    ppc64el)
        _STAGE0_TARGET="powerpc64le-aosc-linux-gnu"
        _FLAGS="-O2 -mcpu=power8 -mtune=power9 -mpower8-vector -mpower8-fusion -maltivec -msecure-plt -mvsx -mabi=ieeelongdouble"
        ;;
    riscv64)
        _STAGE0_TARGET="riscv64-aosc-linux-gnu"
        _FLAGS="-O2"
        ;;
esac

export _STAGE0_TARGET
export CFLAGS="${_FLAGS}"
export CXXFLAGS="${_FLAGS}"

# Define MAKEFLAGS.
export MAKEFLAGS="-j$(( $(nproc) + 1))"

# Executable paths.
export PATH="$_STAGE0/tools/bin:$PATH"
