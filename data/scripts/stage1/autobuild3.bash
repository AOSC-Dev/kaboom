abinfo "autobuild3: Unpacking ..."
tar xf "$_SRCDIR"/v$AUTOBUILD3_VER.tar.gz || \
    aberr "Failed to unpack autobuild3: $?"

abinfo "autobuild3: Creating installation directories ..."
mkdir -pv \
    /etc \
    /usr/bin \
    /usr/lib || \
    aberr "Failed to create installation directories for autobuild3: $?"

abinfo "autobuild3: Installing program files ..."
cp -arv autobuild3-$AUTOBUILD3_VER \
    /usr/lib/autobuild3 || \
    aberr "Failed to install autobuild3 program files: $?"

abinfo "autobuild3: Setting prefix in configuration ..."
echo '/usr/lib/autobuild3' \
    > /usr/lib/autobuild3/etc/autobuild/prefix || \
    aberr "Failed to set prefix for autobuild3: $?"

abinfo "autobuild3: Installing a symlink for /etc/autobuild ..."
ln -sv ../usr/lib/autobuild3/etc/autobuild \
    /etc/autobuild || \
    aberr "Failed to create the symlink for /etc/autobuild: $?"

abinfo "autobuild3: Installing executable symlinks ..."
cd /usr/bin
ln -sv ../lib/autobuild3/ab3.sh \
    . || \
    aberr "Failed to create symlink for /usr/bin/autobuild: $?"
ln -sv ../lib/autobuild3/contrib/autobuild-* \
    . || \
    aberr "Failed to create symlinks for contrib scripts: $?"
cd /

abinfo "autobuild3: Creating fake symlinks for apt ..."
for fake in apt apt-get apt-cache; do
    ln -sv true \
        /usr/bin/$fake || \
        aberr "Failed to create fake symlinks for $fake: $?"
done

abinfo "autobuild3: Setting stage2 mode ..."
echo ABSTAGE2=1 \
    >> /etc/autobuild/ab3cfg.sh
