#!/bin/sh

DEST_FOLDER=/home/jlgutierrez/zedboot
echo Destination folder is $DEST_FOLDER
echo Deleting old files
rm $DEST_FOLDER/devicetree.dtb 
rm $DEST_FOLDER/uImage
rm $DEST_FOLDER/uramdisk.image.gz
echo Fixing Ethernet Register Device-Tree
dtc -I dtb -O dts -o output/images/zynq-zed.dts output/images/zynq-zed.dtb
sed -i 's/<0x7>/<0x0>/g' output/images/zynq-zed.dts
rm output/images/zynq-zed.dtb
dtc -I dts -O dtb -o output/images/zynq-zed.dtb output/images/zynq-zed.dts
echo Copying uImage uRamdisk and Device-Tree to $DEST_FOLDER
cp output/images/zynq-zed.dtb $DEST_FOLDER/devicetree.dtb
cp output/images/uImage $DEST_FOLDER/uImage
cp output/images/rootfs.cpio.uboot $DEST_FOLDER/uramdisk.image.gz
echo Finished...

