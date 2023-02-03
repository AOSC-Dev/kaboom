abinfo "less: Unpacking ..."
tar xf "$_SRCDIR"/less-$LESS_VER.tar.xz || \
    aberr "Failed to unpack less: $?"

cd less-$LESS_VER

abinfo "less: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET || \
    aberr "Failed to run configure for less: $?"

abinfo "less: Building ..."
make || \
    aberr "Failed to build less: $?"

abinfo "less: Installing ..."
make install || \
    aberr "Failed to install less: $?"

abinfo "less: Creating a symlink for pager ..."
ln -sv less \
    /usr/bin/pager || \
    aberr "Failed to create the symlink for pager: $?"
