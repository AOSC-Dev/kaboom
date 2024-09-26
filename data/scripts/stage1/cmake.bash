# FIXME: Whilst building on i486 ...
#
# /usr/lib/gcc/i486-aosc-linux-gnu/13.2.0/../../../../i486-aosc-linux-gnu/bin/ld: ../../Utilities/cmcppdap/libcmcppdap.a(typeof.cpp.o): undefined reference to symbol '__atomic_fetch_sub_8@@LIBATOMIC_1.0'
# /usr/lib/gcc/i486-aosc-linux-gnu/13.2.0/../../../../i486-aosc-linux-gnu/bin/ld: /lib/libatomic.so.1: error adding symbols: DSO missing from command line
if [[ "$KABOOM_ARCH" = "i486" ]]; then
    abinfo "cmake: Appending -latomic to fix build ..."
    export LDFLAGS="${LDFLAGS} -latomic"
fi

abinfo "cmake: Unpacking ..."
tar xf "$_SRCDIR"/cmake-$CMAKE_VER.tar.gz || \
    aberr "Failed to unpack cmake: $?"

cd cmake-$CMAKE_VER

abinfo "cmake: Configuring CMake sources ..."
./bootstrap \
    --prefix=/usr \
    --mandir=/share/man \
    --docdir=/share/doc/cmake \
    --parallel="$(( $(nproc) + 1))"

abinfo "cmake: Building ..."
make

abinfo "cmake: Installing ..."
make install

if [[ "$KABOOM_ARCH" = "i486" ]]; then
    abinfo "cmake: Restoring LDFLAGS ..."
    export LDFLAGS="${LDFLAGS/-latomic/}"
fi
