#!/bin/sh

export PATH=/sbin:/usr/sbin:$PATH
DEBOS_CMD=debos
ARGS=

device="pinephone"
image="image"
partitiontable="mbr"
filesystem="ext4"
environment="phosh"
arch=
do_compress=
family=
image_only=
installer=
memory=
password=
use_docker=
username=
no_blockmap=
ssh=

while getopts "dDizobsre:f:h:m:p:t:u:F:" opt
do
  case "$opt" in
    d ) use_docker=1 ;;
    D ) debug=1 ;;
    e ) environment="$OPTARG" ;;
    i ) image_only=1 ;;
    z ) do_compress=1 ;;
    b ) no_blockmap=1 ;;
    s ) ssh=1 ;;
    o ) installer=1 ;;
    r ) rootfs=1 ;;
    f ) ftp_proxy="$OPTARG" ;;
    h ) http_proxy="$OPTARG" ;;
    m ) memory="$OPTARG" ;;
    p ) password="$OPTARG" ;;
    t ) device="$OPTARG" ;;
    u ) username="$OPTARG" ;;
    F ) filesystem="$OPTARG" ;;
  esac
done

case "$device" in
  "pinephone" )
    arch="arm64"
    family="sunxi"
    ;;
  "pinetab" )
    arch="arm64"
    family="sunxi"
    ;;
  "librem5" )
    arch="arm64"
    family="librem5"
    ;;
  "amd64" )
    arch="amd64"
    family="amd64"
    device="efi"
    partitiontable="gpt"
    ;;
  "amd64-legacy" )
    arch="amd64"
    family="amd64"
    device="pc"
    ;;
  "arm64-android9-generic" )
    arch="arm64"
    family="hybris"
    device="android9-generic"
    ;;
  "armhf-android9-generic" )
    arch="armhf"
    family="hybris"
    device="android9-generic"
    ;;
  * )
    echo "Unsupported device '$device'"
    exit 1
    ;;
esac

image_file="mobian-$device-$environment-`date +%Y%m%d`.img"
if [ "$installer" ]; then
  image="installer"
  image_file="mobian-installer-$device-$environment-`date +%Y%m%d`.img"
fi
if [ "$rootfs" ]; then
  image_file="mobian-rootfs-$device-$environment-`date +%Y%m%d`.tar.gz"
fi

if [ "$use_docker" ]; then
  DEBOS_CMD=docker
  ARGS="run --rm --interactive --tty --device /dev/kvm --workdir /recipes \
            --mount type=bind,source=$(pwd),destination=/recipes \
            --security-opt label=disable godebos/debos"
fi
if [ "$debug" ]; then
  ARGS="$ARGS --debug-shell"
fi

if [ "$username" ]; then
  ARGS="$ARGS -t username:$username"
fi

if [ "$password" ]; then
  ARGS="$ARGS -t password:$password"
fi

if [ "$ssh" ]; then
  ARGS="$ARGS -t ssh:$ssh"
fi

if [ "$environment" ]; then
  ARGS="$ARGS -t environment:$environment"
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

ARGS="$ARGS -t architecture:$arch -t family:$family -t device:$device \
            -t partitiontable:$partitiontable -t filesystem:$filesystem \
            -t environment:$environment -t image:$image_file --scratchsize=8G"

if [ ! "$image_only" ]; then
  $DEBOS_CMD $ARGS rootfs.yaml || exit 1
  if [ "$installer" ]; then
    $DEBOS_CMD $ARGS installfs.yaml || exit 1
  fi
fi

if [ ! "$image_only" -o ! -f "rootfs-$device-$environment.tar.gz" ]; then
  $DEBOS_CMD $ARGS "rootfs-device.yaml" || exit 1
fi

if [ "$rootfs" ]; then
  mv "rootfs-$device-$environment.tar.gz" "${image_file}"
  exit 0
fi

$DEBOS_CMD $ARGS "$image.yaml"

if [ ! "$no_blockmap" ]; then
  bmaptool create "$image_file" > "$image_file.bmap"
fi

if [ "$do_compress" ]; then
  echo "Compressing $image_file..."
  gzip --keep --force $image_file
fi
