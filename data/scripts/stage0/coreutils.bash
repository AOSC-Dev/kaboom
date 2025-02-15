abinfo "coreutils: Unpacking ..."
tar xf "$_SRCDIR"/coreutils-$COREUTILS_VER.tar.xz || \
    aberr "Failed to unpack coreutils: $?"

cd coreutils-$COREUTILS_VER

cat > config.cache << "EOF"
gl_cv_prog_perl=no
cross_compiling=yes
EOF

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?"
done

abinfo "coreutils: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$(config.guess) \
    --enable-install-program=hostname \
    --enable-no-install-program=kill,uptime \
    --cache-file=config.cache || \
    aberr "Failed to run configure for coreutils: $?"

abinfo "coreutils: Building ..."
make || \
    aberr "Failed to build coreutils: $?"

abinfo "coreutils: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install coreutils: $?"
