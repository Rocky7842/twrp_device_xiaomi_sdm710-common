#
# Copyright (C) 2023 Team Win Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

TARGET_USES_XIAOMI_SDM710_COMMON_TREE := true

# Inherit AOSP product makefiles
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Fstab
MI710_FSTAB_VARIANT ?= xiaomi-sdm710-devs

ifeq ($(filter xiaomi-sdm710-devs stock,$(MI710_FSTAB_VARIANT)),)
$(error Invalid Xiaomi SDM710 fstab variant: $(MI710_FSTAB_VARIANT))
endif

# Partitions
ifeq ($(MI710_FSTAB_VARIANT),xiaomi-sdm710-devs)
PRODUCT_USE_DYNAMIC_PARTITIONS := true
endif

# Crypto
PRODUCT_PACKAGES += \
    qcom_decrypt_fbe \
    qcom_decrypt

MI710_KEYMASTER_VERSION ?= 4.0

# Debug
PRODUCT_PACKAGES += \
    crash_dump \
    libprocinfo.recovery

PRODUCT_COPY_FILES += \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/system/apex/com.android.runtime/bin/crash_dump32:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/crash_dump32 \
    $(OUT_DIR)/target/product/$(PRODUCT_RELEASE_NAME)/system/apex/com.android.runtime/bin/crash_dump64:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/crash_dump64

# Fstab
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(LOCAL_PATH)/fstab/$(MI710_FSTAB_VARIANT)/,$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/)

# Proprietary - BEGIN
ifneq ($(MI710_USES_DEVICE_SPECIFIC_BLOBS),true)

# Proprietary - QSEECOMd
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/qseecomd/system/,$(TARGET_COPY_OUT_RECOVERY)/root/system/)

# Proprietary - QTI Gatekeeper 1.0
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/qti-gatekeeper-1-0/system/,$(TARGET_COPY_OUT_RECOVERY)/root/system/)

# Proprietary - QTI Keymaster
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/qti-keymaster-common/system/,$(TARGET_COPY_OUT_RECOVERY)/root/system/)
ifeq ($(MI710_KEYMASTER_VERSION),3.0)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/qti-keymaster-3-0/system/,$(TARGET_COPY_OUT_RECOVERY)/root/system/)
else ifeq ($(MI710_KEYMASTER_VERSION),4.0)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/proprietary/qti-keymaster-4-0/system/,$(TARGET_COPY_OUT_RECOVERY)/root/system/)
endif

# Proprietary - END
endif # MI710_USES_DEVICE_SPECIFIC_BLOBS

# Vintf - Keymaster
ifeq ($(MI710_KEYMASTER_VERSION),3.0)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/vintf/keymaster-3-0.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/keymaster-3-0.xml
else ifeq ($(MI710_KEYMASTER_VERSION),4.0)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/vintf/keymaster-4-0.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest/keymaster-4-0.xml
endif

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit extra if exists
$(call inherit-product-if-exists, vendor/extra/product.mk)
