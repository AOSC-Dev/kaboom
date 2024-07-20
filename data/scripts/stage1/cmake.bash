abinfo "cmake: Unpacking ..."
tar xf "$_SRCDIR"/cmake-$CMAKE_VER.tar.gz || \
    aberr "Failed to unpack cmake: $?"

abinfo "cmake: Configuring CMake sources ..."
"$SRCDIR"/bootstrap \
    --prefix=/usr \
    --mandir=/share/man \
    --docdir=/share/doc/cmake \
    --parallel="$(( $(nproc) + 1))"

abinfo "cmake: Building ..."
make

abinfo "cmake: Installing ..."
make install
