if [[ "${KABOOM_ARCH}" = "ppc64el" ]]; then
    # FIXME: -O2 generates broken code, SIGILLs during module compilation.
    abinfo "ppc64el: Storing standard flags into _CFLAGS ..."
    export _CFLAGS="${CFLAGS}"

    abinfo "ppc64el: Downgrading -O2 to -O1 ..."
    export CFLAGS="${CFLAGS/-O2/-O1}"
fi

abinfo "perl: Unpacking ..."
tar xf "$_SRCDIR"/perl-$PERL_VER.tar.xz || \
    aberr "Failed to unpack perl: $?"

cd perl-$PERL_VER

abinfo "perl: Running Configure ..."
./Configure \
    -des -Dusethreads -Duseshrplib \
    -Dprefix=/usr -Dvendorprefix=/usr \
    -Dman1dir=/usr/share/man/man1 \
    -Dman3dir=/usr/share/man/man3 \
    -Dprefix=/usr -Dvendorprefix=/usr \
    -Dprivlib=/usr/share/perl5/core_perl \
    -Darchlib=/usr/lib/perl5/core_perl \
    -Dsitelib=/usr/share/perl5/site_perl \
    -Dsitearch=/usr/lib/perl5/site_perl \
    -Dvendorlib=/usr/share/perl5/vendor_perl \
    -Dvendorarch=/usr/lib/perl5/vendor_perl \
    -Dscriptdir=/usr/bin/core_perl \
    -Dsitescript=/usr/bin/site_perl \
    -Dvendorscript=/usr/bin/vendor_perl \
    -Dinc_version_list=none \
    -Dcccdlflags="${CFLAGS}" \
    -Dlddlflags="-shared ${LDFLAGS}" \
    -Dldflags="${LDFLAGS}" \
    -Doptimize="${CFLAGS}" || \
    aberr "Failed to run Configure for perl: $?"

abinfo "perl: Building ..."
make || \
    aberr "Failed to build perl: $?"

abinfo "perl: Installing ..."
make install || \
    aberr "Failed to install perl: $?"

if [[ "${KABOOM_ARCH}" = "ppc64el" ]]; then
    abinfo "ppc64el: Restoring CFLAGS ..."
    export CFLAGS="${_CFLAGS}"

    abinfo "ppc64el: Unsetting _CFLAGS ..."
    unset _CFLAGS
fi
