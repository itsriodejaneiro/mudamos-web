#!/bin/bash
set -e

indent() {
  sed -u 's/^/       /'
}

echo "-----> Install ImageMagick"

BUILD_DIR=/dependencies/imagemagick/build
CACHE_DIR=/dependencies/imagemagick/cache

mkdir -p $BUILD_DIR
mkdir -p $CACHE_DIR

VENDOR_DIR="$BUILD_DIR/vendor"
mkdir -p $VENDOR_DIR
INSTALL_DIR="$VENDOR_DIR/imagemagick"
mkdir -p $INSTALL_DIR
IMAGE_MAGICK_VERSION="${IMAGE_MAGICK_VERSION:-6.9.5-10}"

# install imagemagick
IMAGE_MAGICK_FILE="ImageMagick-$IMAGE_MAGICK_VERSION.tar.xz"
IMAGE_MAGICK_DIR="ImageMagick-$IMAGE_MAGICK_VERSION"
# SSL cert used on imagemagick not recognized by heroku.
IMAGE_MAGICK_URL="http://www.imagemagick.org/download/releases/$IMAGE_MAGICK_FILE"

echo "-----> Downloading ImageMagick from $IMAGE_MAGICK_URL"
wget $IMAGE_MAGICK_URL -P $BUILD_DIR | indent

echo "-----> Extracting ImageMagick from $BUILD_DIR/$IMAGE_MAGICK_FILE"
if [ ! -f $BUILD_DIR/$IMAGE_MAGICK_FILE ]; then
  echo "Error: Unable to download ImageMagick" | indent
  ls $BUILD_DIR | indent
  exit 1;
fi
tar xvf $BUILD_DIR/$IMAGE_MAGICK_FILE | indent

echo "-----> Building ImageMagick"
cd $IMAGE_MAGICK_DIR
export CPPFLAGS="-I$INSTALL_DIR/include"
export LDFLAGS="-L$INSTALL_DIR/lib"
./configure --prefix=$INSTALL_DIR --without-gvc
make && make install
cd ..
rm -rf $IMAGE_MAGICK_DIR


echo "-----> Writing policy file"
mkdir -p $INSTALL_DIR/etc/ImageMagick
cat > $INSTALL_DIR/policy.xml <<EOF
<policymap>
  <policy domain="coder" rights="none" pattern="EPHEMERAL" />
  <policy domain="coder" rights="none" pattern="HTTPS" />
  <policy domain="coder" rights="none" pattern="MVG" />
  <policy domain="coder" rights="none" pattern="MSL" />
</policymap>
EOF
