abinfo "pcre2: Unpacking ..."
tar xf "$_SRCDIR"/pcre2-$PCRE2_VER.tar.gz || \
    aberr "Failed to unpack pcre2: $?"

cd pcre2-$PCRE2_VER

abinfo "pcre2: Running configure ..."
./configure \
    --prefix=/usr \
    --build=$_TARGET || \
    aberr "Failed to run configure for pcre2: $?"

abinfo "pcre2: Building ..."
make || \
    aberr "Failed to build pcre2: $?"

abinfo "pcre2: Installing ..."
make install || \
    aberr "Failed to install pcre2: $?"
