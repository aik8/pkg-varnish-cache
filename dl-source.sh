#!/bin/bash
#
# Download and verify a public source tarball of Varnish Cache.
#
# Author: Lasse Karstensen <lkarsten@varnish-software.com>, April 2016.
TMPDIR=$(mktemp -d)
#TMPDIR="`pwd`/w"

set -o errexit

dl() {
    # Need to accept gzip to avoid getting the tarball unpacked in transit
    if [ "$2" == "gzip" ]; then
        echo "wget with Accept-encoding: gzip"
	    wget --header="Accept-encoding: gzip" --no-verbose --no-clobber -4 --directory-prefix=$TMPDIR $1
	else
        echo "wget with no Accept-encoding"
        wget --no-verbose --no-clobber -4 --directory-prefix=$TMPDIR $1
    fi
}

RELEASEVERSION=$1
OUTPUTDIR=$2
VERIFY=$3
SOURCEURL=$4

echo $#

if [ $# -lt 2 ]; then
	echo "Usage: $0 release outputdir [sourceurl] [verify (true/false)]"
	exit 1
fi

if [ ! -d $OUTPUTDIR ]; then
	echo "ERROR: No such directory $OUTPUTDIR"
	exit 2
fi

if [ "$SOURCEURL" == "" ]; then
    SOURCEURL="http://varnish-cache.org/_downloads"
fi

echo "Downloading Varnish Cache $RELEASEVERSION."
dl $SOURCEURL/varnish-${RELEASEVERSION}.tgz

if [ "$VERIFY" == "false" ]; then
    echo "WARNING: Skipping verification of source tarball"
else
    echo "Verifying Varnish Cache $RELEASEVERSION."
    dl https://raw.githubusercontent.com/varnishcache/homepage/master/R1/source/releases/rel$RELEASEVERSION.rst 
    SHASUM=$(sed -n -e '/.*SHA256=/ s/.*\=//p' $TMPDIR/rel$RELEASEVERSION.rst)
    echo "$SHASUM  varnish-${RELEASEVERSION}.tgz" > $TMPDIR/SHA256SUM
    
    #dl $SOURCEURL/SHA256SUM.gpg

    #if ! gpg --list-key C4DEFFEB 1>/dev/null; then
	#    gpg --recv-key C4DEFFEB
    #fi

    # Do file verification.
    #(cd $TMPDIR && gpg --verify SHA256SUM.gpg SHA256SUM)

    # Release must be a part of the signed signature file to be valid.
    (cd $TMPDIR && grep "varnish-$RELEASEVERSION.tgz" SHA256SUM | sha256sum -c - )
    
fi

mv $TMPDIR/*gz $OUTPUTDIR
