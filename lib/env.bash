# Define triple and build flags.
# Build flags adapted from Autobuild3.
case $KABOOM_ARCH in
    alpha)
        _TARGET="alpha-kaboom-linux-gnu"
        _FLAGS="-O2 -fno-tree-ch -mieee -mcpu=ev4"
        ;;
    amd64)
        _TARGET="x86_64-kaboom-linux-gnu"
        _FLAGS="-O2 -fomit-frame-pointer -march=x86-64 -mtune=sandybridge -msse2"
        ;;
    arm64)
        _TARGET="aarch64-kaboom-linux-gnu"
        _FLAGS="-O2 -march=armv8-a -mtune=cortex-a53"
        ;;
    armv4)
        _TARGET="arm-kaboom-linux-gnueabi"
        _CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _FLAGS="-O2 -fno-tree-ch -march=armv4 -mtune=strongarm110 -mfloat-abi=soft"
        ;;
    armv6hf)
        _TARGET="arm-kaboom-linux-gnueabihf"
        _CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _FLAGS="-O2 -fno-tree-ch -march=armv6 -mtune=arm1176jz-s -mfloat-abi=hard"
        ;;
    armv7hf)
        _TARGET="arm-kaboom-linux-gnueabihf"
        _CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _FLAGS="-O2 -fno-tree-ch -march=armv7-a -mtune=cortex-a7 -mfloat-abi=hard -mfpu=neon -mthumb"
        ;;
    i486)
        _TARGET="i486-kaboom-linux-gnu"
        _CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _FLAGS="-O2 -fno-tree-ch -march=i486 -mtune=generic -ffunction-sections -fdata-sections"
        ;;
    loongarch64)
        _TARGET="loongarch64-kaboom-linux-gnu"
        _FLAGS="-O2 -mabi=lp64d -march=loongarch64 -mtune=loongarch64"
        ;;
    loongson2f)
        _TARGET="mips64el-kaboom-linux-gnuabi64"
        _FLAGS="-O2 -mabi=64 -march=mips3 -mtune=loongson2f -mloongson-mmi -Wa,-mfix-loongson2f-nop"
        ;;
    loongson3)
        _TARGET="mips64el-kaboom-linux-gnuabi64"
        _FLAGS="-O2 -mabi=64 -march=gs464 -mtune=gs464e -mfix-loongson3-llsc -mxgot"
        ;;
    mips32r6el)
        _TARGET="mipsisa32r6el-kaboom-linux-gnu"
        _CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _FLAGS="-O2 -march=mips32r6 -mtune=mips32r6 -mcompact-branches=always"
        ;;
    mips64r6el)
        _TARGET="mipsisa64r6el-kaboom-linux-gnuabi64"
        _FLAGS="-O2 -march=mips64r6 -mtune=mips64r6 -mcompact-branches=always"
        ;;
    m68k)
        _TARGET="m68k-kaboom-linux-gnu"
        _CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _FLAGS="-O2 -fno-tree-ch"
        ;;
    powerpc)
        _TARGET="powerpc-kaboom-linux-gnu"
        _CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _FLAGS="-O2 -fno-tree-ch -m32 -mcpu=G3 -mtune=G4 -mno-altivec -msecure-plt -mhard-float"
        ;;
    ppc64)
        _TARGET="powerpc64-kaboom-linux-gnu"
        _FLAGS="-O2 -fno-tree-ch -m64 -mcpu=G5 -maltivec -mabi=altivec -msecure-plt -mhard-float"
        ;;
    ppc64el)
        _TARGET="powerpc64le-kaboom-linux-gnu"
        _FLAGS="-O2 -mcpu=power8 -mtune=power9 -msecure-plt -mvsx -mabi=ieeelongdouble"
        ;;
    riscv64)
        _TARGET="riscv64-kaboom-linux-gnu"
        _FLAGS="-O2"
        ;;
esac

export _TARGET
export CPPFLAGS="${_CPPFLAGS}"
export CFLAGS="${_FLAGS}"
export CXXFLAGS="${_FLAGS}"

# Define MAKEFLAGS.
export MAKEFLAGS="-j$(( $(nproc) + 1)) V=1 VERBOSE=1"

# Executable paths.
export PATH="$_STAGE0/tools/bin:$PATH"

# We are building with root, fight us.
export FORCE_UNSAFE_CONFIGURE=1
