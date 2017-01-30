#!/system/bin/sh
#
# Device			: Xiaomi Redmi Note 3 Pro (kenzo)
# Tweaks & Mods		: MOVZX (http://forum.xda-developers.com/member.php?u=4460588)
#

############################################## TUNGSTEN / SCREAM TWEAK SCRIPT SPECIAL THANKS TO @MOVZX and @UMANG96 ############################################


################################################################### DARKNESS TWEAKS START ######################################################################

# Definitions
BCL=`ls -d /sys/devices/soc.0/qcom,bcl.*`;
THERM=`ls -d /sys/module/msm_thermal/core_control`;
CPU_LITTLE_CTL=`ls -d /sys/devices/system/cpu/cpu0/core_ctl`;
CPU_LITTLE_FREQ=`ls -d /sys/devices/system/cpu/cpu0/cpufreq`;
# CPU_LITTLE_MIN_FREQ="691200";
CPU_BIG_CTL=`ls -d /sys/devices/system/cpu/cpu4/core_ctl`;
CPU_BIG_FREQ=`ls -d /sys/devices/system/cpu/cpu4/cpufreq`;
# CPU_BIG_MIN_FREQ="883200";
ZRAM_SWAP="536870912";
KERNEL=`ls -d /proc/sys/kernel`;
MMC0=`ls -d /sys/block/mmcblk0/queue`;
MMC1=`ls -d /sys/block/mmcblk1/queue`;
LMK=`ls -d /sys/module/lowmemorykiller/parameters`;

# CPU Tweaks
echo "CPU Tweaks";
#
# Disable Thermal & BCL Core Control
echo "    Disabling Thermal & BCL Core Control";
#
echo "0" > $THERM/enabled;
for mode in $BCL/mode; do
	echo -n disable > $mode;
done;
for hotplug_mask in $BCL/hotplug_mask; do
	bcl_hotplug_mask=`cat $hotplug_mask`;
	echo 0 > $hotplug_mask;
done;
for hotplug_soc_mask in $BCL/hotplug_soc_mask; do
	bcl_soc_hotplug_mask=`cat $hotplug_soc_mask`;
	echo 0 > $hotplug_soc_mask;
done;
for mode in $BCL/mode; do
	echo -n enable > $mode;
done;
#
# CPU Core Control
echo "    Set CPU Core Control" ;
#
for c in $CPU_LITTLE_CTL; do
	echo "        Set min_cpus" ;
	chmod 666 $c/min_cpus;
	echo "1" > $c/min_cpus;
	chmod 444 $c/min_cpus;
	echo "        Set max_cpus" ;
	echo "4" > $c/max_cpus;
	echo "        Set busy_up_thres" ;
	echo "13" > $c/busy_up_thres;
	echo "        Set busy_down_thres" ;
	echo "8" > $c/busy_down_thres;
	echo "        Set offline_delay_ms" ;
	echo "2100" > $c/offline_delay_ms;
	echo "        Set not_preferred" ;
	echo "1 0 0 0" > $c/not_preferred;
	echo "        Set is_big_cluster" ;
	echo "0" > $c/is_big_cluster;
done;
for c in $CPU_BIG_CTL; do
	echo "        Set min_cpus" ;
	chmod 666 $c/min_cpus;
	echo "1" > $c/min_cpus;
	chmod 444 $c/min_cpus;
	echo "        Set max_cpus" ;
	echo "2" > $c/max_cpus;
	echo "        Set busy_up_thres" ;
	echo "21" > $c/busy_up_thres;
	echo "        Set busy_down_thres" ;
	echo "13" > $c/busy_down_thres;
	echo "        Set offline_delay_ms" ;
	echo "1300" > $c/offline_delay_ms;
	echo "        Set task_thres" ;
	echo "4" > $c/task_thres;
	echo "        Set not_preferred" ;
	echo "1 0" > $c/not_preferred;
	echo "        Set is_big_cluster" ;
	echo "1" > $c/is_big_cluster;
done;
#
# CPU Little Cluster
echo "    Set CPU Little Cluster" ;
#
echo "1" > /sys/devices/system/cpu/cpu0/online;
for l in $CPU_LITTLE_FREQ; do
	echo "        Set scaling_governor" ;
	echo "interactive" > $l/scaling_governor;
	echo "        Set scaling_min_freq" ;
	echo $CPU_LITTLE_MIN_FREQ > $l/scaling_min_freq;
	echo "        Set target_loads" ;
	echo "80 1305600:85 1478400:90" > $l/interactive/target_loads;
	echo "        Set above_hispeed_delay" ;
	echo "55000" > $l/interactive/above_hispeed_delay;
	echo "        Set hispeed_freq" ;
	echo "1305600" > $l/interactive/hispeed_freq;
	echo "        Set go_hispeed_load" ;
	echo "85" > $l/interactive/go_hispeed_load;
	echo "        Set timer_rate" ;
	echo "20000" > $l/interactive/timer_rate;
	echo "        Set timer_slack" ;
	echo "10000" > $l/interactive/timer_slack;
	echo "        Set max_freq_hysteresis" ;
	echo "10000" > $l/interactive/max_freq_hysteresis;
	echo "        Set min_sample_time" ;
	echo "50000" > $l/interactive/min_sample_time;
	echo "        Set io_is_busy" ;
	echo "0" > $l/interactive/io_is_busy;
	echo "        Set use_migration_notif" ;
	echo "1" > $l/interactive/use_migration_notif;
	echo "        Set use_sched_load" ;
	echo "0" > $l/interactive/use_sched_load;
	echo "        Set align_windows" ;
	echo "1" > $l/interactive/align_windows;
done;
#
# CPU Big Cluster
$BB echo "    Set CPU Big Cluster" | $BB tee -a $LOG;
#
echo "1" > /sys/devices/system/cpu/cpu4/online;
for b in $CPU_BIG_FREQ; do
	echo "        Set scaling_governor" ;
	echo "interactive" > $b/scaling_governor;
	echo "        Set scaling_min_freq" ;
	echo $CPU_BIG_MIN_FREQ > $b/scaling_min_freq;
	echo "        Set target_loads" ;
	echo "80 1382400:85 1843200:90" > $b/interactive/target_loads;
	echo "        Set above_hispeed_delay" ;
	echo "13000 1382400:34000" > $b/interactive/above_hispeed_delay;
	echo "        Set hispeed_freq" ;
	echo "1382400" > $b/interactive/hispeed_freq;
	echo "        Set go_hispeed_load" ;
	echo "85" > $b/interactive/go_hispeed_load;
	echo "        Set timer_rate" ;
	echo "20000" > $b/interactive/timer_rate;
	echo "        Set timer_slack" ;
	echo "10000" > $b/interactive/timer_slack;
	echo "        Set max_freq_hysteresis" ;
	echo "10000" > $b/interactive/max_freq_hysteresis;
	echo "        Set min_sample_time" ;
	echo "50000" > $l/interactive/min_sample_time;
	echo "        Set io_is_busy" ;
	echo "0" > $b/interactive/io_is_busy;
	echo "        Set use_migration_notif" ;
	echo "1" > $b/interactive/use_migration_notif;
	echo "        Set use_sched_load" ;
	echo "0" > $b/interactive/use_sched_load;
	echo "        Set align_windows" ;
	echo "1" > $b/interactive/align_windows;
done;
#
# Enable Thermal & BCL Core Control
echo "    Enabling Thermal & BCL Core Control" ;
#
echo "1" > $THERM/enabled; 
for mode in $BCL/mode; do
	echo -n disable > $mode;
done;
for hotplug_mask in $BCL/hotplug_mask; do
	echo $bcl_hotplug_mask > $hotplug_mask;
done;
for hotplug_soc_mask in $BCL/hotplug_soc_mask; do
	echo $bcl_soc_hotplug_mask > $hotplug_soc_mask;
done;
for mode in $BCL/mode; do
	echo -n enable > $mode;
done;
#
## Intelli-Therm Kernel Thermal Management Driver
#
echo "Y" > /sys/module/msm_thermal/parameters/enabled;
echo "50" > /sys/module/msm_thermal/parameters/temp_threshold;
echo "55" > /sys/module/msm_thermal/parameters/core_limit_temp_degC;
echo "200" > /sys/module/msm_thermal/parameters/poll_ms;
################################################################### DARKNESS TWEAKS END ########################################################################

################################################################### SCREAM / TUNGSTEN TWEAKS START #############################################################
#
## KCAL Tweaks
#
echo "235 250 240" > /sys/devices/platform/kcal_ctrl.0/kcal;
echo "1" > /sys/devices/platform/kcal_ctrl.0/kcal_enable;
echo "285" > /sys/devices/platform/kcal_ctrl.0/kcal_sat;
echo "263" > /sys/devices/platform/kcal_ctrl.0/kcal_cont;
echo "253" > /sys/devices/platform/kcal_ctrl.0/kcal_val;
#
## Adreno Idler
#
echo "N" > /sys/module/adreno_idler/parameters/adreno_idler_active;
echo "20" > /sys/module/adreno_idler/parameters/adreno_idler_idlewait;
echo "3000" > /sys/module/adreno_idler/parameters/adreno_idler_idleworkload;
echo "15" > /sys/module/adreno_idler/parameters/adreno_idler_downdifferential;
#
##FAST CHARGE
#
echo "1" > /sys/kernel/fast_charge/force_fast_charge;
#
## Vibration Defaults
#
echo "3248" > /sys/class/timed_output/vibrator/vtg_level;
#
## Default Hostname
#
setprop net.hostname Tungsten;
#
## Wake Gestures Disable
#
echo "0" > /sys/android_touch/sweep2wake;
# ZRAM Tweaks
swapoff /dev/block/zram0 > /dev/null 2>&1;
echo "1" > /sys/block/zram0/reset;
echo "0" > /sys/block/zram0/disksize;
echo "1" > /sys/block/zram0/max_comp_streams;
echo $ZRAM_SWAP > /sys/block/zram0/disksize;
mkswap /dev/block/zram0 > /dev/null 2>&1;
swapon /dev/block/zram0 > /dev/null 2>&1;
echo "40" > /proc/sys/vm/swappiness;
#
## FSTRIM
#
BB="/system/xbin/busybox";

CACHE="/cache"
CUST="/cust"
DATA="/data"
DSP="/dsp"
PERSIST="/persist"
SYSTEM="/system"

$BB fstrim -v $CACHE;
$BB fstrim -v $CUST;
$BB fstrim -v $DATA;
$BB fstrim -v $DSP;
$BB fstrim -v $PERSIST;
$BB fstrim -v $SYSTEM;

################################################################### SCREAM / TUNGSTEN TWEAKS END ###############################################################