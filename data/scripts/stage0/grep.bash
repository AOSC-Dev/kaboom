abinfo "grep: Unpacking ..."
tar xf "$_SRCDIR"/grep-$GREP_VER.tar.xz || \
    aberr "Failed to unpack grep: $?"

cd grep-$GREP_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "grep: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$(config.guess) || \
    aberr "Failed to run configure for grep: $?"

abinfo "grep: Building ..."
make || \
    aberr "Failed to build grep: $?"

abinfo "grep: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install grep: $?"
