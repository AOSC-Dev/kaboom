abinfo "file: Unpacking ..."
tar xf "$_SRCDIR"/file-$FILE_VER.tar.gz || \
    aberr "Failed to unpack file: $?"

cd file-$FILE_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "file: Building a temporary file command ..."
# From Linux From Scratch:
#
# The file command on the build host needs to be the same version as the one
# we are building in order to create the signature file. Run the following
# commands to make a temporary copy of the file command.
mkdir tempbuild || \
    aberr "Failed to create the build directory for the temporary file command: $?"
cd tempbuild
../configure \
    --disable-bzlib \
    --disable-libseccomp \
    --disable-xzlib \
    --disable-zlib || \
    aberr "Failed to run configure for the temporary file command: $?"
make || \
    aberr "Failed to build the temporary file command: $?"
cd ..

abinfo "file: Running configure ..."
./configure \
    --prefix=/usr \
    --host=$_TARGET \
    --build=$(config.guess) || \
    aberr "Failed to run configure for file: $?"

abinfo "file: Building ..."
make \
    FILE_COMPILE="$PWD"/tempbuild/src/file || \
    aberr "Failed to build file: $?"

abinfo "file: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install file: $?"

abinfo "file: Removing a unwanted libtool archive (.la) ..."
rm -v "$_STAGE0"/usr/lib/libmagic.la || \
    aberr "Failed to remove unwnated libtool archive (.la) from file: $?"
