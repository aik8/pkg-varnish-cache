#!/bin/bash

# Download and verify the latest version of Varnish Cache source code given the
# major version number.

set -o errexit

################################################################################
# Get the user input.
#

# Get the input and fail if none is provided.
REQUIRED_VERSION=$1
if [ "$REQUIRED_VERSION" == "" ]; then
	echo "Usage: $0 <major_version>"
	exit 1
fi

# Get the custom build version.
CUSTOM_VERSION=$2
if [ "$CUSTOM_VERSION" == "" ]; then
	CUSTOM_VERSION="42"
fi

################################################################################
# Define the functions.

# Determines which is the latest minor and patch versions of the given major
# version of Varnish Cache.
get_latest_version() {
	local MAJOR_VERSION=$1

	curl -s https://varnish-cache.org/releases/ | grep -o "varnish-$MAJOR_VERSION\.[0-9]\+\.[0-9]\+" | sort -V | tail -n 1 | sed 's/varnish-//'
}



################################################################################
# Do stuff.
#

# Determine the latest version.
LATEST_VERSION=$(get_latest_version $REQUIRED_VERSION)

# Download it using the dl-source.sh script.
./dl-source.sh $LATEST_VERSION ./ 1 https://varnish-cache.org/downloads

# Extract the source code.
tar -xzf varnish-$LATEST_VERSION.tgz

# Copy the debian directory.
cp -r debian varnish-$LATEST_VERSION/

# Switch to the source directory.
cd varnish-$LATEST_VERSION

# Put together the version string.
FULL_VERSION="${LATEST_VERSION}-${CUSTOM_VERSION}fastpath"

# Update all variant and version strings.
sed -i -e "s|@VRNVARIANT@|${REQUIRED_VERSION}|g" $(find debian/ -maxdepth 1 -type f)
sed -i -e "s|@VERSION@|${FULL_VERSION}|g" $(find debian/ -maxdepth 1 -type f)
/usr/bin/rename -e "s|VRNVARIANT|${REQUIRED_VERSION}|" debian/*

# Everything is ready to build the package.
dpkg-buildpackage -us -uc -j4 -b
