abinfo "binutils-pass2: Unpacking ..."
tar xf "$_SRCDIR"/binutils-$BINUTILS_VER.tar.xz || \
    aberr "Failed to unpack sources for binutils-pass2: $?"
cd binutils-$BINUTILS_VER

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "binutils: Tweaking the shipped ltmain.sh to prevent linkage to host libraries ..."
# From Linux From Scratch:
#
# Binutils ships an outdated copy of libtool in the tarball. It lacks sysroot
# support, so the produced binaries will be mistakenly linked to libraries
# from the host distro. Work around this issue.
sed -e '6009s/$add_dir//' \
    -i ltmain.sh

abinfo "binutils-pass2: Creating build directory ..."
mkdir -pv build || \
    aberr "Failed to create build directory for binutils-pass2: $?"
cd build

abinfo "binutils-pass2: Running configure ..."
../configure \
    --prefix=/usr \
    --build=$(../config.guess) \
    --host=$_TARGET \
    --disable-nls \
    --enable-shared \
    --enable-gprofng=no \
    --disable-werror \
    --enable-64-bit-bfd || \
    aberr "Failed to run configure for binutils-pass2: $?"

abinfo "binutils-pass2: Building ..."
make || \
    aberr "Failed to build binutils-pass2: $?"

abinfo "binutils-pass2: Installing ..."
make install \
    DESTDIR="$_STAGE0" || \
    aberr "Failed to install binutils-pass2: $?"

abinfo "Removing unwanted libtool archives (.la) ..."
rm -v "$_STAGE0"/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.{a,la} || \
    aberr "Failed to remove unwanted libtool archives (.la) from binutils-pass2: $?"
