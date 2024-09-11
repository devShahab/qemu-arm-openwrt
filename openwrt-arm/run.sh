#!/bin/sh

# https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=target/linux/armsr/README;hb=HEAD
# install luci web interface
# https://openwrt.org/docs/guide-user/luci/luci.essentials

VERSION=23.05.4

D_IMAGE=openwrt-$VERSION-armsr-armv7-generic-ext4-rootfs.img
D_KERNAL=openwrt-$VERSION-armsr-armv7-generic-kernel.bin

IMAGE=openwrt-armsr-armv7-generic-ext4-rootfs.img
KERNAL=openwrt-armsr-armv7-generic-kernel.bin

TAP_FACE=tap0

# check if kernal.bin exists
if test -f "$KERNAL"
then
    echo "$KERNAL exists."
else
    echo "$KERNAL does not exist. downloading..."
    wget https://downloads.openwrt.org/releases/$VERSION/targets/armsr/armv7/$D_KERNAL
    mv $D_KERNAL $KERNAL
fi

# check if img file exists
if test -f "$IMAGE"
then
    echo "$IMAGE exists."
else
    echo "$IMAGE does not exist. downloading..."
    wget https://downloads.openwrt.org/releases/$VERSION/targets/armsr/armv7/$D_IMAGE.gz
    gzip -d $D_IMAGE.gz
    mv $D_IMAGE $IMAGE
fi

qemu-system-arm \
-M virt \
-kernel $KERNAL \
-drive file=$IMAGE,format=raw,if=virtio \
-append 'root=/dev/vda rootwait' \
-m 64 \
-no-reboot \
-device virtio-net-pci,netdev=lan \
-netdev tap,id=lan,ifname=$TAP_FACE,script=no,downscript=no \
-device virtio-net-pci,netdev=wan \
-netdev user,id=wan,ipv4=on,hostfwd=tcp::2222-:22,hostfwd=tcp::80-:80 \
-nographic

# access luci on http://192.168.10.1/cgi-bin/luci/ 