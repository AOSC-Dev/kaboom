abinfo "git: Unpacking ..."
tar xf "$_SRCDIR"/v$GIT_VER.tar.gz || \
    aberr "Failed to unpack git: $?"

cd git-$GIT_VER

abinfo "git: Building ..."
make \
    prefix=/usr \
    gitexecdir=/usr/lib/git-core \
    DEFAULT_EDITOR=/usr/bin/nano || \
    aberr "Failed to build git: $?"

abinfo "git: Installing ..."
make install \
    prefix=/usr \
    gitexecdir=/usr/lib/git-core \
    DEFAULT_EDITOR=/usr/bin/nano || \
    aberr "Failed to install git: $?"
