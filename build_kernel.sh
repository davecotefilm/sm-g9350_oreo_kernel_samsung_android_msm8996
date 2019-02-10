#!/bin/bash

export CROSS_COMPILE=$(pwd)/lazy-prebuilt/aarch64-linux-android-4.9/bin/aarch64-linux-android-

ROOT_DIR=$(pwd)
OUT_DIR=$ROOT_DIR/toxic
BUILDING_DIR=$OUT_DIR/davecotefilm
rm -rf out
rm -rf $OUT_DIR
mkdir $OUT_DIR
mkdir $BUILDING_DIR

export ARCH=arm64
export SEC_BUILD_OPTION_HW_REVISION=02
make -C $(pwd) O=$(pwd)/out KCFLAGS=-mno-android hero2qlte_chnzh_defconfig
make -C $(pwd) O=$(pwd)/out KCFLAGS=-mno-android

cp out/arch/arm64/boot/Image $(pwd)/arch/arm64/boot/Image
cp out/arch/arm64/boot/Image $(pwd)/arch/arm64/boot/Image

DTBTOOL=$ROOT_DIR/tools/dtbTool

$DTBTOOL -v -s 4096 -o $BUILDING_DIR/dtb $ROOT_DIR/out/arch/arm64/boot/dts/samsung/

cp -r $ROOT_DIR/anykernel-prebuilt/* $BUILDING_DIR
cp $ROOT_DIR/out/arch/arm64/boot/Image.gz $BUILDING_DIR/zImage
mkdir $BUILDING_DIR/modules
find $ROOT_DIR/out -type f -name "*.ko" | xargs cp -t $BUILDING_DIR/modules
cd $BUILDING_DIR
zip -r ToxicKernel.zip ./*
cd $ROOT_DIR
rm -f ToxicKernel.zip
cp $BUILDING_DIR/ToxicKernel.zip $ROOT_DIR

