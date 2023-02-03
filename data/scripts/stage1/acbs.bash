abinfo "acbs: Unpacking ..."
tar xf "$_SRCDIR"/$ACBS_VER.tar.gz || \
    aberr "Failed to unpack acbs: $?"

cd acbs-$ACBS_VER/

# Adapted from acbs/bootstrap.
abinfo "acbs: Installing required dependencies to local user folder ...'
rm -f get-pip.py
wget https://bootstrap.pypa.io/get-pip.py || \
    aberr "Failed to download get-pip.py: $?"
python3 get-pip.py --user || \
    aberr "Failed to install pip: $?"
pip3 install --user pyparsing || \
    aberr "Failed to install pyparsing: $?"

abinfo 'acbs: Installing ..."
python3 setup.py install --user || \
    aberr "Failed to install acbs: $?"

rm -f get-pip.py

abinfo "acbs: Preparing build environment ..."
git clone -b stable https://github.com/AOSC-Dev/aosc-os-abbs \
    /tree || \
    aberr "Failed to clone aosc-os-abbs: $?"
mkdir -pv \
    /etc/acbs/ \
    /var/cache/acbs/{build,tarballs} \
    /var/log/acbs || \
    aberr "Failed to create acbs directories: $?"
cp -rv /tree/core-devel/gcc/02-compiler/overrides/* \
    / || \
    aberr "Failed to install GCC spec files: $?"

abinfo "acbs: Generating /etc/acbs/forest.conf ..."
cat > /etc/acbs/forest.conf << EOF
[default]
location = /tree
EOF
