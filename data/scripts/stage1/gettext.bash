abinfo "gettext: Unpacking ..."
tar xf "$_SRCDIR"/gettext-$GETTEXT_VER.tar.xz || \
    aberr "Failed to unpack gettext: $?"

cd gettext-$GETTEXT_VER

if [[ "$KABOOM_ARCH" = "ppc64el" ]]; then
    abinfo "Tweaking libc-config.h for IEEE long double ABI compatibility ..."
    # This makes sure gnulib uses cdefs.h shipped with Glibc, not gnulib.
    sed -e 's|^#include <cdefs.h>|#include <sys/cdefs.h>|g' \
        -i gettext-tools/gnulib-lib/libc-config.h \
        -i gettext-tools/libgrep/libc-config.h ||
        aberr "Failed to tweak libc-config.h: $?"
fi

abinfo "Replacing config.* ..."
for i in $(find -name config.guess -o -name config.sub); do
    cp -v "$_CONTRIBDIR"/automake/$(basename "$i") "$i" || \
        aberr "Failed to copy replacement $i: $?."
done

abinfo "gettext: Running configure ..."
./configure \
    --prefix=/usr \
    --build=$_TARGET \
    --disable-shared || \
    aberr "Failed to run configure for gettext: $?"

abinfo "gettext: Building ..."
make || \
    aberr "Failed to build gettext: $?"

abinfo "gettext: Installing ..."
make install || \
    aberr "Failed to install gettext: $?"
