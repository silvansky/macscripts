#!/bin/bash

#
# This script downloads and builds GCC 4.7.0 for Mac OS X.
# Depends on: brew, wget
#
# This file is modifyed version of script by Konrad Rudolph, found here:
# http://apple.stackexchange.com/questions/38222/how-do-i-install-gcc-via-homebrew
#

VERSION=4.7.0
VER_SHORT=4.7
PREFIX=/usr/local/gcc-${VER_SHORT}
TEMP_DIR=temp-gcc
LANGUAGES=c,c++,objc,obj-c++
MAKE='make -j 4'

echo "Preparing to install GCC ${VERSION}..."
echo " Installation path: ${PREFIX}"
echo " Temporary dir: ${TEMP_DIR}"
echo " Programming languages: ${LANGUAGES}"

brew-path() { brew info $1 | head -n3 | tail -n1 | cut -d' ' -f1; }

# Prerequisites

echo
echo "Installing gmp, mpfr and libmpc using brew..."

brew install gmp
brew install mpfr
brew install libmpc

# Download & install the latest GCC

echo
echo "Downloading GCC sources..."

mkdir -p $PREFIX
mkdir ${TEMP_DIR}
cd ${TEMP_DIR}
wget ftp://ftp.gnu.org/gnu/gcc/gcc-${VERSION}/gcc-${VERSION}.tar.gz
tar xfz gcc-$VERSION.tar.gz
rm gcc-${VERSION}.tar.gz
cd gcc-${VERSION}

mkdir build
cd build

echo
echo "Configuring GCC..."

../configure \
	--prefix=$PREFIX \
	--with-gmp=$(brew-path gmp) \
	--with-mpfr=$(brew-path mpfr) \
	--with-mpc=$(brew-path libmpc) \
	--program-suffix=-${VER_SHORT} \
	--enable-languages=${LANGUAGES} \
	--with-system-zlib \
	--enable-stage1-checking \
	--enable-plugin \
	--enable-lto \
	--disable-multilib

echo
echo "Building GCC..."

$MAKE bootstrap

echo
echo "Installing GCC..."

make install

# Uncomment for cleanup
# cd ../../..
# rm -r temp-gcc