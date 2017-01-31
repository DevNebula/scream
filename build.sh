#
# Custom build script for Radon kernel
#
# Copyright 2016 Umang Leekha (Umang96@xda)
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it.
#

yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
gre='\e[0;32m'
echo -e ""
echo -e "$yellow ==================\n\n Welcome to Tungsten building program !\n\n ===============\n"
echo -e "$white"
KERNEL_DIR=$PWD
cd arch/arm/boot/dts/
rm .msm8956*
rm *.dtb
cd $KERNEL_DIR
Start=$(date +"%s")
DTBTOOL=$KERNEL_DIR/dtbTool
cd $KERNEL_DIR
export ARCH=arm64
export CROSS_COMPILE="/home/kabir_47_chd/gcc-4.9/bin/aarch64-linux-android-"
export LD_LIBRARY_PATH=/home/kabir_47_chd/gcc-4.9/lib
STRIP="/home/kabir_47_chd/gcc-4.9/bin/aarch64-linux-android-strip"
git reset --hard
git clean -fd
make clean
rm -rf $KERNEL_DIR/build/modules
mkdir -p $KERNEL_DIR/build/modules/pronto
mkdir -p $KERNEL_DIR/build/system/lib
make cyanogenmod_kenzo_defconfig
export KBUILD_BUILD_HOST="Ubuntu-PC"
export KBUILD_BUILD_USER="kabir"
make -j64
make -j64 modules
time=$(date +"%d-%m-%y-%T")
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/tools/dt.img
cp $KERNEL_DIR/arch/arm64/boot/Image $KERNEL_DIR/build/tools/Image
cp $KERNEL_DIR/drivers/staging/prima/wlan.ko $KERNEL_DIR/build/modules/wlan.ko
cp $KERNEL_DIR/drivers/staging/prima/wlan.ko $KERNEL_DIR/build/modules/pronto/pronto_wlan.ko
mkdir -p $KERNEL_DIR/build/modules/pronto
cd $KERNEL_DIR/build/modules/
$STRIP --strip-unneeded wlan.ko
cd $KERNEL_DIR/build/modules/pronto
$STRIP --strip-unneeded pronto_wlan.ko
cd $KERNEL_DIR/build/system/lib
cd $KERNEL_DIR/build
mv modules $KERNEL_DIR/build/system/lib
zimage=$KERNEL_DIR/arch/arm64/boot/Image
if ! [ -a $zimage ];
then
echo -e "$red << Failed to compile zImage, fix the errors first >>$white"
else
cd $KERNEL_DIR/build
rm *.zip
rm -r Image1
rm -r dt11.img
zip -r Scream_MIUI.zip *
End=$(date +"%s")
Diff=$(($End - $Start))
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds >>$white"
fi
cd $KERNEL_DIR

