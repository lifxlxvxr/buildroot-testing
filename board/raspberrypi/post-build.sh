#!/bin/sh

set -u
set -e

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
# systemd doesn't use /etc/inittab, enable getty.tty1.service instead
elif [ -d ${TARGET_DIR}/etc/systemd ]; then
    mkdir -p "${TARGET_DIR}/etc/systemd/system/getty.target.wants"
    ln -sf /lib/systemd/system/getty@.service \
       "${TARGET_DIR}/etc/systemd/system/getty.target.wants/getty@tty1.service"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S')" > ${TARGET_DIR}/etc/build-date

if [ -f ${TARGET_DIR}/etc/init.d/S40xorg ]; then
    mv ${TARGET_DIR}/etc/init.d/S40xorg ${TARGET_DIR}/etc/init.d/S70xorg
fi

if [ -f ${TARGET_DIR}/etc/init.d/S49ntp ]; then
    mv ${TARGET_DIR}/etc/init.d/S49ntp ${TARGET_DIR}/etc/init.d/S90ntp
fi


