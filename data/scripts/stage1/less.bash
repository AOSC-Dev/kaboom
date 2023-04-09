abinfo "less: Unpacking ..."
tar xf "$_SRCDIR"/less-$LESS_VER.tar.gz || \
    aberr "Failed to unpack less: $?"

cd less-$LESS_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "less: Running configure ..."
./configure \
    --prefix=/usr \
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
