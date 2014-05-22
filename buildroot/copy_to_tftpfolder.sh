#!/bin/sh

echo Deleting old files
rm ~/tftpboot/devicetree.dtb 
rm ~/tftpboot/uImage
rm ~/tftpboot/uramdisk.image.gz
echo Copying uImage uRamdisk and  Device-Tree to ~/tftpfolder
cp output/images/zynq-zed.dtb ~/tftpboot/devicetree.dtb
cp output/images/uImage ~/tftpboot/uImage
cp output/images/rootfs.cpio.uboot ~/tftpboot/uramdisk.image.gz
echo Finished...

