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
os=$(cat /tmp/aroma/os.prop | cut -d '=' -f2)
selinx=$(cat /tmp/aroma/sel.prop | cut -d '=' -f2)

##################### LINEAGE OS
if ([ $os -eq 1 ]); then
if ([ $selinx -eq 1 ]); then
cmd="console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 ramoops_memreserve=4M androidboot.selinux=permissive"
dim=/tmp/dt.img
zim=/tmp/Image
elif ([ $selinx -eq 2 ]); then
cmd="console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 ramoops_memreserve=4M androidboot.selinux=enforcing"
dim=/tmp/dt.img
zim=/tmp/Image
fi
cd /tmp/
/sbin/busybox dd if=/dev/block/bootdevice/by-name/boot of=./boot.img
./unpackbootimg -i /tmp/boot.img
mkdir /tmp/ramdisk
cp /tmp/boot.img-ramdisk.gz /tmp/ramdisk/
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/boot.img-ramdisk.gz | cpio -i
rm /tmp/ramdisk/boot.img-ramdisk.gz
rm /tmp/boot.img-ramdisk.gz
rm -rf /tmp/ramdisk/init.qcom.power.rc
cp -faRf /tmp/init.qcom.power.rc /tmp/ramdisk/;
cp -faRf /tmp/init.scream.rc /tmp/ramdisk/;
if [ $(grep -c "import init.scream.rc" /tmp/ramdisk/init.qcom.rc) == 0 ]; then
	sed -i "/import \init\.qcom\.power\.rc/aimport init.scream.rc" /tmp/ramdisk/init.qcom.rc;
fi;
find . | cpio -o -H newc | gzip > /tmp/boot.img-ramdisk.gz
rm -r /tmp/ramdisk
cd /tmp/
./mkbootimg --kernel $zim --ramdisk /tmp/boot.img-ramdisk.gz --cmdline "$cmd"  --base 0x80000000 --pagesize 2048 --ramdisk_offset 0x02000000 --tags_offset 0x01e00000 --dt $dim -o /tmp/newboot.img
/sbin/busybox dd if=/tmp/newboot.img of=/dev/block/bootdevice/by-name/boot
fi
##################### LINEAGE OS END

########################## MIUI
if ([ $os -eq 2 ]); then
if ([ $selinx -eq 1 ]); then
cmd="console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 ramoops_memreserve=4M androidboot.selinux=permissive"
dim=/tmp/dt.img
zim=/tmp/Image
elif ([ $selinx -eq 2 ]); then
cmd="console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 ramoops_memreserve=4M androidboot.selinux=enforcing"
dim=/tmp/dt.img
zim=/tmp/Image
fi
cd /tmp/
/sbin/busybox dd if=/dev/block/bootdevice/by-name/boot of=./boot.img
./unpackbootimg -i /tmp/boot.img
mkdir /tmp/ramdisk
cp /tmp/boot.img-ramdisk.gz /tmp/ramdisk/
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/boot.img-ramdisk.gz | cpio -i
rm /tmp/ramdisk/boot.img-ramdisk.gz
rm /tmp/boot.img-ramdisk.gz
find . | cpio -o -H newc | gzip > /tmp/boot.img-ramdisk.gz
rm -r /tmp/ramdisk
cd /tmp/
./mkbootimg --kernel $zim --ramdisk /tmp/boot.img-ramdisk.gz --cmdline "$cmd"  --base 0x80000000 --pagesize 2048 --ramdisk_offset 0x02000000 --tags_offset 0x01e00000 --dt $dim -o /tmp/newboot.img
/sbin/busybox dd if=/tmp/newboot.img of=/dev/block/bootdevice/by-name/boot
fi
######################## MIUI ENDS

