abinfo "python-3: Unpacking ..."
tar xf "$_SRCDIR"/Python-$PYTHON3_VER.tar.xz || \
    aberr "Failed to unpack python-3: $?"

cd Python-$PYTHON3_VER

abinfo "python-3: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET \
    --enable-shared \
    --with-ensurepip || \
    aberr "Failed to run configure for python-3: $?"

abinfo "python-3: Building ..."
make || \
    aberr "Failed to build python-3: $?"

abinfo "python-3: Installing ..."
make install || \
    aberr "Failed to install python-3: $?"
