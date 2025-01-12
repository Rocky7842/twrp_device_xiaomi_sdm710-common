#
# Copyright (C) 2023 Team Win Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/xiaomi/sdm710-common

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := kryo385

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := kryo385

# Bootloader
TARGET_NO_BOOTLOADER := true

# Build
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
ALLOW_MISSING_DEPENDENCIES := true

# Kernel
BOARD_KERNEL_CMDLINE := console=ttyMSM0,115200n8 earlycon=msm_geni_serial,0xA90000 androidboot.hardware=qcom androidboot.console=ttyMSM0 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 service_locator.enable=1 androidboot.configfs=true androidboot.usbcontroller=a600000.dwc3 swiotlb=1 loop.max_part=7
BOARD_KERNEL_CMDLINE += firmware_class.path=/system/etc/firmware printk.devkmsg=on
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

ifeq ($(PRODUCT_USE_DYNAMIC_PARTITIONS),true)
BOARD_KERNEL_CMDLINE += androidboot.android_dt_dir=/non-existent
ifeq ($(TARGET_USE_EMMC),true)
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=soc/7c4000.sdhci
else
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=soc/1d84000.ufshc
endif
endif

BOARD_BOOT_HEADER_VERSION := 2
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x04000000
TARGET_COPY_OUT_VENDOR := vendor
TARGET_USERIMAGES_USE_F2FS := true

ifeq ($(MI710_FSTAB_VARIANT),xiaomi-sdm710-devs)
BOARD_USES_METADATA_PARTITION := true
endif

# Partitions - dynamic
ifeq ($(PRODUCT_USE_DYNAMIC_PARTITIONS),true)
SSI_PARTITIONS := product system system_ext
TREBLE_PARTITIONS := odm vendor
ALL_PARTITIONS := $(SSI_PARTITIONS) $(TREBLE_PARTITIONS)

BOARD_SUPER_PARTITION_BLOCK_DEVICES := system vendor cust
BOARD_SUPER_PARTITION_METADATA_DEVICE := system
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions

BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 3758096384
BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE := 1610612736
BOARD_SUPER_PARTITION_CUST_DEVICE_SIZE := 1073741824
BOARD_SUPER_PARTITION_SIZE := $(shell expr $(BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE) + $(BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE) + $(BOARD_SUPER_PARTITION_CUST_DEVICE_SIZE))
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE :=$(shell expr $(BOARD_SUPER_PARTITION_SIZE) - 4194304)
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := $(ALL_PARTITIONS)

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(COMMON_PATH)/fstab/merge-fstab/bin/,$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/) \
    $(call find-copy-subdir-files,*,$(COMMON_PATH)/fstab/merge-fstab/init/,$(TARGET_COPY_OUT_RECOVERY)/root/)
endif

# Properties
ifeq ($(MI710_FSTAB_VARIANT),xiaomi-sdm710-devs)
TARGET_VENDOR_PROP += $(COMMON_PATH)/vendor_fbev1.prop
endif

# Recovery
TARGET_RECOVERY_DEVICE_DIRS += $(COMMON_PATH)
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

# Storage
ifeq ($(TARGET_USE_EMMC),true)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(COMMON_PATH)/fstab/merge-fstab-emmc/bin/,$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/) \
    $(call find-copy-subdir-files,*,$(COMMON_PATH)/fstab/merge-fstab-emmc/init/,$(TARGET_COPY_OUT_RECOVERY)/root/)
endif
ifeq ($(TARGET_USE_SDCARD),true)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(COMMON_PATH)/fstab/merge-fstab-sdcard/bin/,$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/) \
    $(call find-copy-subdir-files,*,$(COMMON_PATH)/fstab/merge-fstab-sdcard/etc/,$(TARGET_COPY_OUT_RECOVERY)/root/system/etc) \
    $(call find-copy-subdir-files,*,$(COMMON_PATH)/fstab/merge-fstab-sdcard/init/,$(TARGET_COPY_OUT_RECOVERY)/root/)
endif

# TWRP
TARGET_RECOVERY_QCOM_RTC_FIX := true
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_CUSTOM_CPU_TEMP_PATH := /sys/devices/virtual/thermal/thermal_zone9/temp
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_SCREEN_BLANK_ON_BOOT := true
TW_THEME := portrait_hdpi

TW_HAS_EDL_MODE := true
TW_ENABLE_BLKDISCARD := true
TW_EXCLUDE_APEX := true
TW_EXCLUDE_PYTHON := true
TW_INCLUDE_RESETPROP := true

TW_EXTRA_LANGUAGES := true

TW_DEVICE_VERSION := 0_Rocky7842

# TWRP - Crypto
TW_INCLUDE_CRYPTO := true

PLATFORM_VERSION := 16.1.0
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

TARGET_RECOVERY_DEVICE_MODULES += \
    vendor.display.config@1.0 \
    vendor.display.config@2.0

RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@1.0.so \
    $(TARGET_OUT_SYSTEM_EXT_SHARED_LIBRARIES)/vendor.display.config@2.0.so

# TWRP - Crypto - FBE
BOARD_USES_QCOM_FBE_DECRYPTION := true
TW_USE_FSCRYPT_POLICY := 1

# TWRP - Debug
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true

TARGET_RECOVERY_DEVICE_MODULES += \
    debuggerd \
    strace \
    tombstoned

RECOVERY_BINARY_SOURCE_FILES += \
    $(TARGET_OUT_EXECUTABLES)/debuggerd \
    $(TARGET_OUT_EXECUTABLES)/strace \
    $(TARGET_OUT_EXECUTABLES)/tombstoned

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# Vibrator
TARGET_RECOVERY_DEVICE_MODULES += \
    android.hardware.vibrator-V2-ndk.so \
    libqtivibratoreffectoffload.so \
    libqtivibratoreffect.so

RECOVERY_LIBRARY_SOURCE_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.vibrator-V2-ndk.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/libqtivibratoreffectoffload.so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/libqtivibratoreffect.so \

TW_SUPPORT_INPUT_AIDL_HAPTICS := true
TW_SUPPORT_INPUT_AIDL_HAPTICS_FIX_OFF := true

# Inherit extra if exists
-include vendor/extra/BoardConfigExtra.mk
