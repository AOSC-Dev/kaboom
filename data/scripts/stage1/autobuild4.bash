abinfo "autobuild4: Unpacking ..."
tar xf "$_SRCDIR"/v$AUTOBUILD4_VER.tar.gz || \
    aberr "Failed to unpack autobuild4: $?"

cd autobuild4-$AUTOBUILD4_VER

abinfo "autobuild4: Preparing for shadow build ..."
mkdir -pv build
cd build

abinfo "autobuild4: Configuring CMake sources ..."
cmake .. \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DSYSCONF_INSTALL_DIR=/etc

abinfo "autobuild4: Building ..."
make

abinfo "autobuild4: Installing ..."
make install

abinfo "Exiting shadow build directory ..."
cd ..

abinfo "autobuild4: Setting prefix in configuration ..."
echo '/usr/lib/autobuild4' \
    > /etc/autobuild/prefix || \
    aberr "Failed to set prefix for autobuild4: $?"

abinfo "autobuild4: Creating fake symlinks for apt and more ..."
for fake in apt apt-get apt-cache go gem meson ninja python2 ruby; do
    ln -sv true \
        /usr/bin/$fake || \
        aberr "Failed to create fake symlinks for $fake: $?"
done

abinfo "autobuild4: Setting stage2 mode ..."
echo ABSTAGE2=1 \
    >> /etc/autobuild/ab4cfg.sh
