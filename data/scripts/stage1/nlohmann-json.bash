abinfo "nlohmann-json: Unpacking ..."
tar xf "$_SRCDIR"/v$NLOHMANN_JSON_VER.tar.gz || \
    aberr "Failed to unpack nlohmann-json: $?"

cd json-$NLOHMANN_JSON_VER

abinfo "nlohmann-json: Configuring CMake sources ..."
cmake . \
    -DCMAKE_INSTALL_PREFIX=/usr

abinfo "nlohmann-json: Building ..."
make

abinfo "nlohmann-json: Installing ..."
make install
