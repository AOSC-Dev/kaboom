# Define triple and build flags.
# Build flags adapted from Autobuild3.
case $KABOOM_ARCH in
    alpha)
        _TARGET="alpha-kaboom-linux-gnu"
        _TGT_FLAGS="-O2 -fno-tree-ch -mieee -mcpu=ev4"
	_BINFMT=qemu-alpha
	_KERNEL_ARCH=alpha
        ;;
    amd64)
        _TARGET="x86_64-kaboom-linux-gnu"
        _TGT_FLAGS="-O2 -fomit-frame-pointer -march=x86-64 -mtune=sandybridge -msse2"
	_BINFMT=qemu-x86_64
	_KERNEL_ARCH=x86
        ;;
    arm64)
        _TARGET="aarch64-kaboom-linux-gnu"
        _TGT_FLAGS="-O2 -march=armv8-a -mtune=cortex-a53"
	_BINFMT=qemu-aarch64
	_KERNEL_ARCH=arm64
	_LINK_LIB64=1
        ;;
    armv4)
        _TARGET="arm-kaboom-linux-gnueabi"
        _TGT_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _TGT_FLAGS="-O2 -fno-tree-ch -march=armv4 -mtune=strongarm110 -mfloat-abi=soft"
	_BINFMT=qemu-arm
	_KERNEL_ARCH=arm
        ;;
    armv6hf)
        _TARGET="arm-kaboom-linux-gnueabihf"
        _TGT_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _TGT_FLAGS="-O2 -fno-tree-ch -march=armv6 -mtune=arm1176jz-s -mfloat-abi=hard"
	_BINFMT=qemu-arm
	_KERNEL_ARCH=arm
        ;;
    armv7hf)
        _TARGET="arm-kaboom-linux-gnueabihf"
        _TGT_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _TGT_FLAGS="-O2 -fno-tree-ch -march=armv7-a -mtune=cortex-a7 -mfloat-abi=hard -mfpu=neon -mthumb"
	_BINFMT=qemu-arm
	_KERNEL_ARCH=arm
        ;;
    i486)
        _TARGET="i486-kaboom-linux-gnu"
        _TGT_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _TGT_FLAGS="-O2 -fno-tree-ch -march=i486 -mtune=generic -ffunction-sections -fdata-sections"
	_BINFMT=qemu-i386
	_KERNEL_ARCH=x86
        ;;
    loongarch64)
        _TARGET="loongarch64-kaboom-linux-gnu"
        _TGT_FLAGS="-O2 -mabi=lp64d -march=loongarch64 -mtune=loongarch64"
	_BINFMT=qemu-loongarch64
	_KERNEL_ARCH=loongarch
        ;;
    loongson2f)
        _TARGET="mips64el-kaboom-linux-gnuabi64"
        _TGT_FLAGS="-O2 -mabi=64 -march=mips3 -mtune=loongson2f -mloongson-mmi -Wa,-mfix-loongson2f-nop"
	_BINFMT=qemu-mips64el
	_LINK_LIB64=1
	KERNEL_ARCH=mips
        ;;
    loongson3)
        _TARGET="mips64el-kaboom-linux-gnuabi64"
        _TGT_FLAGS="-O2 -mabi=64 -march=gs464 -mtune=gs464e -mfix-loongson3-llsc -mxgot"
	_BINFMT=qemu-mips64el
	_LINK_LIB64=1
	KERNEL_ARCH=mips
        ;;
    mips32r6el)
        _TARGET="mipsisa32r6el-kaboom-linux-gnu"
        _TGT_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _TGT_FLAGS="-O2 -march=mips32r6 -mtune=mips32r6 -mcompact-branches=always"
	_BINFMT=qemu-mipsel
	KERNEL_ARCH=mips
        ;;
    mips64r6el)
        _TARGET="mipsisa64r6el-kaboom-linux-gnuabi64"
        _TGT_FLAGS="-O2 -march=mips64r6 -mtune=mips64r6 -mcompact-branches=always -mmsa"
	_BINFMT=qemu-mips64el
	_LINK_LIB64=1
	_KERNEL_ARCH=mips
        ;;
    m68k)
        _TARGET="m68k-kaboom-linux-gnu"
        _TGT_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _TGT_FLAGS="-O2 -fno-tree-ch"
	_BINFMT=qemu-m68k
	_KERNEL_ARCH=m68k
        ;;
    powerpc)
        _TARGET="powerpc-kaboom-linux-gnu"
        _TGT_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64"
        _TGT_FLAGS="-O2 -fno-tree-ch -m32 -mcpu=G3 -mtune=G4 -mno-altivec -msecure-plt -mhard-float"
	_BINFMT=qemu-ppc
	_KERNEL_ARCH=powerpc
        ;;
    ppc64)
        _TARGET="powerpc64-kaboom-linux-gnu"
        _TGT_FLAGS="-O2 -fno-tree-ch -m64 -mcpu=G5 -maltivec -mabi=altivec -msecure-plt -mhard-float"
	_BINFMT=qemu-ppc64
	_KERNEL_ARCH=powerpc
        ;;
    ppc64el)
        _TARGET="powerpc64le-kaboom-linux-gnu"
        _TGT_FLAGS="-O2 -mcpu=power8 -mtune=power9 -msecure-plt -mvsx -mabi=ieeelongdouble"
	_BINFMT=qemu-ppc64el
	_KERNEL_ARCH=powerpc
        ;;
    riscv64)
        _TARGET="riscv64-kaboom-linux-gnu"
        _TGT_FLAGS="-O2"
	_BINFMT=qemu-riscv64
	_KERNEL_ARCH=riscv
        ;;
esac

_HOST_FLAGS="-march=native -mtune=native -O2"

export _TARGET _KERNEL_ARCH

# Define MAKEFLAGS.
export MAKEFLAGS="-j$(( $(nproc) + 1)) V=1 VERBOSE=1"

# Executable paths.
export PATH="$_STAGE0/tools/bin:$PATH"

# We are building with root, fight us.
export FORCE_UNSAFE_CONFIGURE=1
