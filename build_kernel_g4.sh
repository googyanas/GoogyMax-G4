#!/bin/sh
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
# export CROSS_COMPILE=/home/googy/Kernel/Googy-Max-G4/toolchain/bin/aarch64-linux-android-
# export CROSS_COMPILE=/usr/bin/aarch64-linux-gnu-
export CROSS_COMPILE=/home/googy/Downloads/linaro49/bin/aarch64-linux-gnu-
export KCONFIG_NOTIMESTAMP=true

VER="\"-Googy-Max-G4-v$1\""
cp -f /home/googy/Kernel/Googy-Max-G4/Kernel/arch/arm64/configs/googymax-g4_defconfig /home/googy/Kernel/Googy-Max-G4/googymax-g4_defconfig
sed "s#^CONFIG_LOCALVERSION=.*#CONFIG_LOCALVERSION=$VER#" /home/googy/Kernel/Googy-Max-G4/googymax-g4_defconfig > /home/googy/Kernel/Googy-Max-G4/Kernel/arch/arm64/configs/googymax-g4_defconfig

export ARCH=arm64

rm -f /home/googy/Kernel/Googy-Max-G4/Kernel/arch/arm64/boot/Image*.*
rm -f /home/googy/Kernel/Googy-Max-G4/Kernel/arch/arm64/boot/.Image*.*
make googymax-g4_defconfig || exit 1

make -j4 || exit 1

mkdir -p /home/googy/Kernel/Googy-Max-G4/Out/ramdisk/system/lib/modules
rm -rf /home/googy/Kernel/Googy-Max-G4/Out/ramdisk/system/lib/modules/*
find -name '*.ko' -exec cp -av {} /home/googy/Kernel/Googy-Max-G4/Out/ramdisk/system/lib/modules/ \;
${CROSS_COMPILE}strip --strip-unneeded /home/googy/Kernel/Googy-Max-G4/Out/ramdisk/system/lib/modules/*

# ./tools/dtbToolCM -o /home/googy/Kernel/Googy-Max-G4/Out/dt.img -s 4096 -p ./scripts/dtc/ arch/arm64/boot/dts/

cd /home/googy/Kernel/Googy-Max-G4/Out
./packimg.sh

cd /home/googy/Kernel/Googy-Max-G4/Release
zip -r ../Googy-Max-G4_Kernel_${1}.zip .

adb push /home/googy/Kernel/Googy-Max-G4/Googy-Max-G4_Kernel_${1}.zip /sdcard/Googy-Max-G4_Kernel_${1}.zip

adb kill-server

echo "Googy-Max-G4_Kernel_${1}.zip READY !"
