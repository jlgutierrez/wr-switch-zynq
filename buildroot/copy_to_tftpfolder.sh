#!/bin/sh
########################################################################
#  copy_to_tftpfolder.sh
# 
#  It checks whether the xinetd daemon is running or not and  
#  in addition, fixes the ethernet bug in the device-tree file. 
#  After this, it copies the kernel, device-tree and root filesystem
#  to the tftp folder in your computer.
# 
#   Created on: May 3, 2014
#   Authors:
#  		- José Luis Gutiérrez
#	Institutions: 
#		- University of Granada
########################################################################

#Check tftp server status
xinetd_pid=$(pidof xinetd)
if [ -z $xinetd_pid ];
then
	echo -e "\e[93mWarning: xinetd is not running\e[39m"
else
	echo -e "\e[92mXinetd is running (pid $xinetd_pid)\e[39m"
fi
#Show TFTP folder and set destination folder
tftpfolder=$(cat /etc/xinetd.d/tftp | grep server_args | awk '{print $3}')

if [ -z $tftpfolder ]; then
	echo TFTP folder does not exist. Please check /etc/xinetd.d/tftp
	$DEST_FOLDER = ~/
else
	DEST_FOLDER=$tftpfolder
fi
echo TFTP folder is set to: $tftpfolder
echo Destination folder set to $DEST_FOLDER

#Check zynq-zed.dtb, uImage and rootfs.cpio.uboot exists
if [ -f output/images/zynq-zed.dtb ]; then
	echo Device tree found: output/images/zynq-zed.dtb
else
	echo -e "\e[91mError: device tree file not found\e[39m"
fi

if [ -f output/images/uImage ]; then
	echo kernel image found: output/images/uImage
else
	echo -e "\e[91mError: Kernel image not found\e[39m"
fi

if [ -f output/images/rootfs.cpio.uboot ]; then
	echo Root file system found: output/images/rootfs.cpio.uboot
else
	echo -e "\e[91mError: root file system not found\e[39m"
fi


if [ -f output/images/zynq-zed.dtb ] && [ -f output/images/uImage ] && [ -f output/images/rootfs.cpio.uboot ]; then
	echo Deleting old files $DEST_FOLDER/devicetree.dtb $DEST_FOLDER/uImage $DEST_FOLDER/uramdisk.image.gz
	rm $DEST_FOLDER/devicetree.dtb 
	rm $DEST_FOLDER/uImage
	rm $DEST_FOLDER/uramdisk.image.gz
	
	#Fix the devicetree ethernet register bug
	echo Fixing Ethernet Register Device-Tree
	dtc -I dtb -O dts -o output/images/zynq-zed.dts output/images/zynq-zed.dtb
	sed -i 's/<0x7>/<0x0>/g' output/images/zynq-zed.dts
	rm output/images/zynq-zed.dtb
	dtc -I dts -O dtb -o output/images/zynq-zed.dtb output/images/zynq-zed.dts
	
	#Copy files to the tftp folder
	echo Copying uImage uRamdisk and Device-Tree to $DEST_FOLDER
	cp output/images/zynq-zed.dtb $DEST_FOLDER/devicetree.dtb
	cp output/images/uImage $DEST_FOLDER/uImage
	cp output/images/rootfs.cpio.uboot $DEST_FOLDER/uramdisk.image.gz
	echo -e "\e[92mFinished!\e[39m"
else
	echo -e "\e[91mError: Process stopped.\e[39m"
	echo Please check zynq-zed.dtb, uImage and rootfs.cpio.uboot exists in output/images/ folder
	echo Try \"\$make\" in buildroot folder
fi

