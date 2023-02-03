abinfo "curl: Unpacking ..."
tar xf "$_SRCDIR"/curl-$CURL_VER.tar.xz || \
    aberr "Failed to unpack curl: $?"

cd curl-$CURL_VER

abinfo "curl: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET \
    --with-openssl || \
    aberr "Failed to run configure for curl: $?"

abinfo "curl: Building ..."
make || \
    aberr "Failed to build curl: $?"

abinfo "curl: Installing ..."
make install || \
    aberr "Failed to install curl: $?"
