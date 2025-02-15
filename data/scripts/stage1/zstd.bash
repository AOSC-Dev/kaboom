abinfo "zstd: Unpacking ..."
tar xf "$_SRCDIR"/zstd-$ZSTD_VER.tar.gz || \
    aberr "Failed to unpack zstd: $?"

cd zstd-$ZSTD_VER

abinfo "zstd: Building ..."
make || \
    aberr "Failed to build zstd: $?"

abinfo "zstd: Installing ..."
make install \
    PREFIX=/usr || \
    aberr "Failed to install zstd: $?"
