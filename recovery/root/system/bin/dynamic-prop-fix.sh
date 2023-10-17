#!/system/bin/sh

# Remove dynamic partitions props for compatibility reason
if dd if=/dev/block/by-name/system bs=256k count=1|strings|grep qti_dynamic_partitions > /dev/null; then
    exit 1
else
    resetprop ro.boot.dynamic_partitions ""
    resetprop ro.boot.dynamic_partitions_retrofit ""
fi
exit 0
