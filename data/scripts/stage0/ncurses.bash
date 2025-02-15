abinfo "ncurses: Unpacking ..."
tar xf "$_SRCDIR"/ncurses-$NCURSES_VER.tar.gz || \
    aberr "Failed to unpack ncurses: $?"

cd ncurses-$NCURSES_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "ncurses: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$(config.guess) \
    --with-shared \
    --without-normal \
    --with-cxx-shared \
    --without-debug \
    --without-ada \
    --enable-widec || \
    aberr "Failed to run configure for ncurses: $?"

abinfo "ncurses: Building ..."
make || \
    aberr "Failed to build ncurses: $?"

abinfo "ncurses: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install ncurses: $?"

abinfo "ncurses: Creating libncurses.so as a linker script pointing to libncursesw.so ..."
echo "INPUT(-lncursesw)" > \
    "$_STAGE0"/usr/lib/libncurses.so || \
    aberr "Failed to create the libncurses.so linker script: $?"
