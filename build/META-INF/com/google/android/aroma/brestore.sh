#!/sbin/sh
dd if=/sdcard/Scream/Backup/boot.img of=/dev/block/bootdevice/by-name/boot && unzip modules.zip && cp -faRf modules /system/lib
