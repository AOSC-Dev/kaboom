abinfo "python-3: Unpacking ..."
tar xf "$_SRCDIR"/Python-$PYTHON3_VER.tar.xz || \
    aberr "Failed to unpack python-3: $?"

cd Python-$PYTHON3_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "python-3: Running configure ..."
./configure \
    --prefix=/usr \
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
