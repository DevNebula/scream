#!/sbin/sh

 #
 # Copyright � 2014, Varun Chitre "varun.chitre15" <varun.chitre15@gmail.com> 
 #
 # Live ramdisk patching script
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
 # Please maintain this if you use this script or any part of it
 #
cmd="console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 ramoops_memreserve=4M buildvariant=userdebug androidboot.selinux=permissive"
dim=/tmp/dt.img
zim=/tmp/Image
cd /tmp/
/sbin/busybox dd if=/dev/block/bootdevice/by-name/boot of=./boot.img
./unpackbootimg -i /tmp/boot.img
mkdir /tmp/ramdisk
cp /tmp/boot.img-ramdisk.gz /tmp/ramdisk/
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/boot.img-ramdisk.gz | cpio -i
rm /tmp/ramdisk/boot.img-ramdisk.gz
rm /tmp/ramdisk/init.qcom.power.rc
rm /tmp/boot.img-ramdisk.gz
#if ! [ '$grep -c "TUNGSTEN_sysinitd" /tmp/ramdisk/init.qcom.rc' == 0 ]; then
#	echo "`cat /tmp/init-append`" >> /tmp/ramdisk/init.qcom.rc
#	echo " Applied modification to init.qcom.rc ! "
#fi
find . | cpio -o -H newc | gzip > /tmp/boot.img-ramdisk.gz
rm -r /tmp/ramdisk
cd /tmp/
./mkbootimg --kernel $zim --ramdisk /tmp/boot.img-ramdisk.gz --cmdline "$cmd"  --base 0x80000000 --pagesize 2048 --ramdisk_offset 0x02000000 --tags_offset 0x01e00000 --dt $dim -o /tmp/newboot.img
/sbin/busybox dd if=/tmp/newboot.img of=/dev/block/bootdevice/by-name/boot
