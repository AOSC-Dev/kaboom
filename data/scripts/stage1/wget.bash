abinfo "wget: Unpacking ..."
tar xf "$_SRCDIR"/wget-$WGET_VER.tar.gz || \
    aberr "Failed to unpack wget: $?"

cd wget-$WGET_VER

abinfo "wget: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET \
    --with-ssl=openssl || \
    aberr "Failed to run configure for wget: $?"

abinfo "wget: Building ..."
make || \
    aberr "Failed to build wget: $?"

abinfo "wget: Installing ..."
make install || \
    aberr "Failed to install wget: $?"
