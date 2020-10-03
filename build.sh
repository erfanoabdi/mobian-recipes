#!/bin/sh

export PATH=/sbin:/usr/sbin:$PATH
DEBOS_CMD=debos
ARGS=
arch=
device="pinephone"
do_compress=
image_only=
image_recipe=
memory=
password=
use_docker=
username=
no_blockmap=

while getopts "dizbf:h:m:p:t:u:" opt
do
  case "$opt" in
    d ) use_docker=1 ;;
    i ) image_only=1 ;;
    z ) do_compress=1 ;;
    b ) no_blockmap=1 ;;
    f ) ftp_proxy="$OPTARG" ;;
    h ) http_proxy="$OPTARG" ;;
    m ) memory="$OPTARG" ;;
    p ) password="$OPTARG" ;;
    t ) device="$OPTARG" ;;
    u ) username="$OPTARG" ;;
  esac
done

IMG_FILE="mobian-$device-`date +%Y%m%d`.img"

case "$device" in
  "pinephone" )
    arch="arm64"
    image_recipe="image-sunxi"
    ;;
  "pinetab" )
    arch="arm64"
    image_recipe="image-sunxi"
    ;;
  "librem5" )
    arch="arm64"
    image_recipe="image-librem5"
    ;;
  "amd64" )
    arch="amd64"
    image_recipe="image-amd64"
    ;;
  "amd64-legacy" )
    arch="amd64"
    image_recipe="image-amd64-legacy"
    ;;
  * )
    usage
    ;;
esac

if [ "$use_docker" ]; then
  DEBOS_CMD=docker
  ARGS="run --rm --interactive --tty --device /dev/kvm --workdir /recipes \
            --mount type=bind,source=$(pwd),destination=/recipes \
            --security-opt label=disable godebos/debos"
fi
if [ "$username" ]; then
  ARGS="$ARGS -t username:$username"
fi

if [ "$password" ]; then
  ARGS="$ARGS -t password:$password"
fi

if [ "$http_proxy" ]; then
  ARGS="$ARGS -e http_proxy:$http_proxy"
fi

if [ "$ftp_proxy" ]; then
  ARGS="$ARGS -e ftp_proxy:$ftp_proxy"
fi

if [ "$memory" ]; then
  ARGS="$ARGS --memory $memory"
fi

ARGS="$ARGS -t architecture:$arch -t device:$device --scratchsize=8G"

if [ ! "$image_only" ]; then
  $DEBOS_CMD $ARGS rootfs.yaml || exit 1
fi

$DEBOS_CMD $ARGS -t image:$IMG_FILE $image_recipe.yaml

if [ ! "$no_blockmap" ]; then
  bmaptool create "$IMG_FILE" > "$IMG_FILE.bmap"
fi

if [ "$do_compress" ]; then
  echo "Compressing $IMG_FILE..."
  gzip --keep --force $IMG_FILE
fi
