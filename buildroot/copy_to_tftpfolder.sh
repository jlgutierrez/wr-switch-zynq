#!/bin/sh

echo Deleting old files
rm ~/tftpboot/devicetree.dtb 
rm ~/tftpboot/uImage
rm ~/tftpboot/uramdisk.image.gz
echo Fixing Ethernet Register Device-Tree
dtc -I dtb -O dts -o output/images/zynq-zed.dts output/images/zynq-zed.dtb
sed -i 's/<0x7>/<0x0>/g' output/images/zynq-zed.dts
rm output/images/zynq-zed.dtb
dtc -I dts -O dtb -o output/images/zynq-zed.dtb output/images/zynq-zed.dts
echo Copying uImage uRamdisk and  Device-Tree to ~/tftpfolder
cp output/images/zynq-zed.dtb ~/tftpboot/devicetree.dtb
cp output/images/uImage ~/tftpboot/uImage
cp output/images/rootfs.cpio.uboot ~/tftpboot/uramdisk.image.gz
echo Finished...

