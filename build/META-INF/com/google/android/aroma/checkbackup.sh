#!/sbin/sh
if [ -e /sdcard/Scream/Backup/Status.txt ]
then
  exit 0
else
  exit 1
fi