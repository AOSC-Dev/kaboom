abinfo "bash: Unpacking ..."
tar xf "$_SRCDIR"/bash-$BASH_VER.tar.gz || \
    aberr "Failed to unpack bash: $?"

cd bash-$BASH_VER

abinfo "bash: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$_TARGET \
    --without-bash-malloc || \
    aberr "Failed to run configure for bash: $?"

abinfo "bash: Building ..."
make || \
    aberr "Failed to build bash: $?"

abinfo "bash: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install bash: $?"

abinfo "Creating the symlink for /bin/sh => bash ..."
mkdir -pv "$_STAGE0"/bin || \
    aberr "Failed to create directory for /bin/sh => bash: $?"
ln -sv bash \
    "$_STAGE0"/bin/sh || \
    aberr "Failed to create the symlink for /bin/sh => bash: $?"
