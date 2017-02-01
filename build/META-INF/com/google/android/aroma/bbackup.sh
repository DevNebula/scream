#!/sbin/sh
dd if=/dev/block/bootdevice/by-name/boot of=/sdcard/Scream/Backup/boot.img && zip -r modules.zip /system/lib/modules && mv modules.zip /sdcard/Scream/Backup
