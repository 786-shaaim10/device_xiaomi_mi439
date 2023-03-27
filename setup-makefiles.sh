#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2022 The LineageOS Project
# Copyright (C) 2023 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=mi439
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        --kernel-4.19 )
                KERNEL_4_19=true
                ;;
    esac
    shift
done

# Initialize the helper for device
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}"

# Warning headers and guards
write_headers

# The standard device blobs
write_makefiles "${MY_DIR}/proprietary-files.txt" true
if [ "${KERNEL_4_19}" != "true" ]; then
   # Kernel 4.9
   write_makefiles "${MY_DIR}/proprietary-files/4.9/qcom-system.txt" true
   write_makefiles "${MY_DIR}/proprietary-files/4.9/qcom-vendor.txt" true
   write_makefiles "${MY_DIR}/proprietary-files/4.9/qcom-vendor-32.txt" true
else
   # Kernel 4.19
   write_makefiles "${MY_DIR}/proprietary-files/4.19/qcom-system.txt" true
   write_makefiles "${MY_DIR}/proprietary-files/4.19/qcom-vendor.txt" true
   write_makefiles "${MY_DIR}/proprietary-files/4.19/qcom-vendor-32.txt" true
fi

# Finish
write_footers
