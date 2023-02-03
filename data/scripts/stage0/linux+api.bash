abinfo "linux+api: Unpacking ..."
tar xf "$_SRCDIR"/linux-$LINUX_API_VER.tar.xz || \
    aberr "Failed to unpack sources for linux+api: $?"
cd linux-$LINUX_API_VER

abinfo "linux+api: Building Linux API headers ..."
make headers || \
    aberr "Faild to build Linux API headers: $?"

abinfo "linux+api: Drop unwanted files ..."
find usr/include \
    -type f ! \
    -name '*.h' \
    -delete || \
    abinfo "Failed to drop unwanted files from linux+api: $?"

abinfo "linux+api: Installing Linux API headers ..."
mkdir -pv "$_STAGE0"/usr || \
    aberr "Failed to create installation directory for linux+api: $?"
cp -rv usr/include "$_STAGE0"/usr || \
    aberr "Failed to install linux+api: $?"
