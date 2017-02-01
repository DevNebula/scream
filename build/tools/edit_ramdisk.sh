#!/sbin/sh

### SCREAM USER SPECIFIC TWEAKS ... THANKS TO @UMANG96 FOR THE SCRIPT

CONFIGFILE="/system/etc/init.qcom.post_boot.sh"
echo "" >> $CONFIGFILE
echo "######################################################SCREAM / TUNGSTEN USER SPECIFIC TWEAKS...##################################################" >> $CONFIGFILE

DT2W=$(cat /tmp/aroma/dt2w.prop | cut -d '=' -f2)
if [ $DT2W == 1 ]; then
DTP=1
VIBS=75
elif [ $DT2W == 2 ]; then
DTP=1
VIBS=0
elif [ $DT2W == 3 ]; then
DTP=0
VIBS=75
fi
echo "# DT2W" >> $CONFIGFILE
echo "echo "$DTP" > /sys/android_touch/doubletap2wake;"  >> $CONFIGFILE
echo "echo "$VIBS" > /sys/android_touch/vib_strength;" >> $CONFIGFILE
echo "" >> $CONFIGFILE
COLOR=$(cat /tmp/aroma/color.prop | cut -d '=' -f2)
echo "# KCAL" >> $CONFIGFILE
if [ $COLOR == 1 ]; then
echo "echo "1" > /sys/devices/platform/kcal_ctrl.0/kcal_enable;" >> $CONFIGFILE
elif [ $COLOR == 2 ]; then
echo "echo "0" > /sys/devices/platform/kcal_ctrl.0/kcal_enable;" >> $CONFIGFILE
fi
echo "" >> $CONFIGFILE
echo "# CHARGING RATE" >> $CONFIGFILE
CRATE=$(cat /tmp/aroma/crate.prop | cut -d '=' -f2)
if [ $CRATE == 1 ]; then
echo "echo "1" > /sys/kernel/fast_charge/force_fast_charge;" >> $CONFIGFILE
elif [ $CRATE == 2 ]; then
echo "echo "0" > /sys/kernel/fast_charge/force_fast_charge;" >> $CONFIGFILE
fi 
IDLER=$(cat /tmp/aroma/idler.prop | cut -d '=' -f2)
echo "" >> $CONFIGFILE
echo "# ADRENO IDLER" >> $CONFIGFILE
if [ $IDLER == 1 ]; then
echo "echo "Y" > /sys/module/adreno_idler/parameters/adreno_idler_active;" >> $CONFIGFILE
elif [ $IDLER == 2 ]; then
echo "echo "N" > /sys/module/adreno_idler/parameters/adreno_idler_active;" >> $CONFIGFILE
fi
echo "" >> $CONFIGFILE
echo "#ADRENO BOOST" >> $CONFIGFILE
GPU=$(cat /tmp/aroma/gpuboost.prop | cut -d '=' -f2);
if [ $GPU == 1 ]; then
	OPT=1;
elif [ $GPU == 2 ]; then
	OPT=2;
elif [ $GPU == 3 ]; then
	OPT=3;
elif [ $GPU == 4 ]; then
	OPT=0;
fi;
echo " echo "$OPT" > /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost;" >> $CONFIGFILE;
echo "" >> $CONFIGFILE
echo "" >> $CONFIGFILE