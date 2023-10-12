#!/system/bin/sh

# Dynamic Partitions

echo >> /system/etc/recovery.fstab
echo >> /system/etc/twrp.flags

if dd if=/dev/block/by-name/system bs=256k count=1|strings|grep qti_dynamic_partitions > /dev/null; then
    for p in system system_ext product vendor odm; do
        echo "${p} /${p} ext4 rw,barrier=1,discard wait,logical" >> /system/etc/recovery.fstab
    done
else
    for p in vendor cust; do
        echo "/dev/block/bootdevice/by-name/${p} /${p} ext4 rw,barrier=1 wait,formattable" >> /system/etc/recovery.fstab
    done
    echo "/dev/block/bootdevice/by-name/system /system_root ext4 rw,barrier=1 wait,formattable" >> /system/etc/recovery.fstab

    cat /system/etc/twrp.flags.nondynamic >> /system/etc/twrp.flags
fi
