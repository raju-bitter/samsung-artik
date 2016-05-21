#!/bin/bash
TMP_DIR="usr/tmp-mod"
BIN_NAME="modules.img"
sudo echo "dummy for get permission" > /dev/null
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabi-
make artik10_defconfig
make exynos5422-artik10.dtb
make -j8 zImage
cat arch/arm/boot/zImage arch/arm/boot/dts/exynos5422-artik10.dtb > zImage
make modules
make modules_install INSTALL_MOD_PATH=${TMP_DIR}
# modules image size is dynamically determined
BIN_SIZE=`du -s ${TMP_DIR}/lib | awk {'printf $1;'}`
let BIN_SIZE=${BIN_SIZE}+1024+512 # 1 MB journal + 512 KB buffer
cd ${TMP_DIR}/lib
mkdir -p tmp
dd if=/dev/zero of=${BIN_NAME} count=${BIN_SIZE} bs=1024
mkfs.ext4 -q -F -t ext4 -b 1024 ${BIN_NAME}
sudo -n mount -t ext4 ${BIN_NAME} ./tmp -o loop
if [ "$?" != "0" ]; then
    echo "Failed to mount (or sudo)"
    exit 1
fi
cp modules/* ./tmp -rf
sudo -n chown root:root ./tmp -R
sync
sudo -n umount ./tmp
if [ "$?" != "0" ]; then
    echo "Failed to umount (or sudo)"
    exit 1
fi
mv ${BIN_NAME} ../
cd ../
rm lib -rf
cd ../../
cp ${TMP_DIR}/${BIN_NAME} .
sudo e2label modules.img modules