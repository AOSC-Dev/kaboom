# FIXME: Older help2man does not build the man pages successfully.
if command -v help2man; then
    abinfo "coreutils: Moving help2man out of PATH to workaround potential build failures ..."
    HELP2MAN_PATH="$(dirname $(command -v help2man))"
    mv -v "$HELP2MAN_PATH"/help2man \
        "$_SRCDIR"/
fi

abinfo "coreutils: Unpacking ..."
tar xf "$_SRCDIR"/coreutils-$COREUTILS_VER.tar.xz || \
    aberr "Failed to unpack coreutils: $?"

cd coreutils-$COREUTILS_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?"
done

abinfo "coreutils: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET \
    --enable-install-program=hostname \
    --enable-no-install-program=kill,uptime \
    aberr "Failed to run configure for coreutils: $?"

abinfo "coreutils: Building ..."
make || \
    aberr "Failed to build coreutils: $?"

abinfo "coreutils: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install coreutils: $?"

# FIXME: Older help2man does not build the man pages successfully.
if [ -e "$_SRCDIR"/help2man ]; then
    abinfo "coreutils: Moving help2man out of PATH to workaround potential build failures ..."
    mv -v "$_SRCDIR"/help2man \
        "$HELP2MAN_PATH"/help2man
fi
