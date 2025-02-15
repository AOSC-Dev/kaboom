abinfo "bash: Unpacking ..."
tar xf "$_SRCDIR"/bash-$BASH_VER.tar.gz || \
    aberr "Failed to unpack bash: $?"

cd bash-$BASH_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "bash: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$(config.guess) \
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
