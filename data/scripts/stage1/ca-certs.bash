abinfo "ca-certs: Copying certdata.txt ..."
cp -v "$_SRCDIR"/certdata.txt \
    . || \
    aberr "Failed to copy certdata.txt: $?"

abinfo "ca-certs: Installing ca-certs scripts ..."
cp -av "$_CONTRIBDIR"/ca-certs/* \
    /usr/bin/ || \
    aberr "Failed to install ca-certs scripts: $?"

abinfo "ca-certs: Running make-ca ..."
make-ca || \
    aberr "Failed to run make-ca: $?"

abinfo "ca-certs: Pruning expired certificates ..."
remove-expired-certs certs || \
    aberr "Failed to prune expired certificates: $?"

abinfo "ca-certs: Installing certificates ..."
install -dv /etc/ssl/certs || \
    aberr "Failed to create installation directory for certificates: $?"
cp -v certs/* \
    /etc/ssl/certs/ || \
    aberr "Failed to install certificates: $?"

abinfo "ca-certs: Creating a compatibility symlink for ca-certificates.crt ..."
ln -sv ../ca-bundle.crt \
    /etc/ssl/certs/ca-certificates.crt

abinfo "ca-certs: Scanning certificates ..."
c_rehash || \
    aberr "Failed to scan certificates ..."
