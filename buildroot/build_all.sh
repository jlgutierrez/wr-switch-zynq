#!/bin/sh
########################################################################
#  compile_userspace.sh
# 
# blablabla
# 
#   Created on: Sep 1, 2014
#   Authors:
#  		- José Luis Gutiérrez
#	Institutions: 
#		- University of Granada
########################################################################

USERSPACE=userspace
BUILDROOT=$PWD
WR_INSTALL_ROOT=$PWD/output/target/wr
## Let's build userspace ##

## Set ARCH & CROSS_COMPILE
export ARCH=arm

# Check own buildroot cross-compiler exists and zedboard defconfig
if [ -f output/host/usr/bin/arm-linux-gcc ]; then
export CROSS_COMPILE=$PWD/output/host/usr/bin/arm-linux-
else 
	echo -e "\e[91mError: arm-linux-gcc does not exist in buildroot folder\e[39m"
	echo -e "\e[91mPlease compile buildroot first\e[39m"
	echo "Running make to generate buildroot cross-compiler"
	make
	if [ -f output/build/linux-3.14.4/arch/arm/configs/xilinx_zynq_defconfig ]; then
		echo "xilinx_zynq_defconfig file found..."
	else
		echo "xilinx_zynq_defconfig not found. Copying from buildroot folder to destination"
		cp xilinx_zynq_defconfig output/build/linux-3.14.4/arch/arm/configs/xilinx_zynq_defconfig
		make
	fi
	
	export CROSS_COMPILE=$PWD/output/host/usr/bin/arm-linux-
fi
if [ -d output/build/linux-3.14.4 ]; then
export LINUX=$PWD/output/build/linux-3.14.4
else 
	echo -e "\e[91mError: linux-3.14.4 not found in buildroot build folder\e[39m"
	echo -e "\e[91mExiting...\e[39m"
	make
	
fi

echo "*********************************************************************"
echo "**** Compiling userspace with the following parameters:"
echo "**** ARCH=$ARCH"
echo "**** CROSS_COMPILE=$CROSS_COMPILE"
echo "**** WR_INSTALL_ROOT=$WR_INSTALL_ROOT"
echo "**** LINUX=$LINUX"
echo "*********************************************************************"


sleep 5

## We clean all ##
cd $PWD/$USERSPACE
make clean
cd $BUILDROOT

### Apply patches to kernel ##
#echo "Applying kernel patches"
#patchdir="$BUILDROOT/patches/kernel/v2.6.39"

## go to the build dir and compile it, using our configuration
#cd $PWD/output/build
#dirname="linux-xilinx-v14.5"
## apply patches
#cd $dirname
#for n in ${patchdir}/00*; do
    #patch -p1 < $n || wrs_die "patch kernel"
#done
#cd $BUILDROOT
#echo "Kernel patches applied"
#sleep 5

### Compile Kernel Drivers ###
#echo -e "\e[92mCompiling kernel drivers\e[39m"
#cd $PWD/kernel
#make clean
#make all
#echo -e "\e[92mKernel drivers compiled\e[39m"
#sleep 5

##Copy .ko by hand
#echo -e "\e[92mCopying kernel drivers to target filesystem\e[39m"
#mkdir -p $WR_INSTALL_ROOT/lib/modules
#cp at91_softpwm/*.ko $WR_INSTALL_ROOT/lib/modules
#cp wr_nic/*.ko $WR_INSTALL_ROOT/lib/modules
#cp wr_pstats/*.ko $WR_INSTALL_ROOT/lib/modules
#cp wr_rtu/*.ko $WR_INSTALL_ROOT/lib/modules
#cp wr_vic/*.ko $WR_INSTALL_ROOT/lib/modules
#cd $BUILDROOT
#echo -e "\e[92mKernel drivers copied\e[39m"
#sleep 5


## subdirectories we want to compile
#cd $PWD/$USERSPACE/libptpnetif
#make clean
#make
#cd $BUILDROOT
#echo -e "\e[92mlibptpnetif built\e[39m"
#sleep 5


#cd $PWD/$USERSPACE/mini-rpc
#make clean
#make
#cd $BUILDROOT
#echo -e "\e[92mmini-rpc built\e[39m"
#sleep 5


#cd $PWD/$USERSPACE/libswitchhw
#make clean
#make
#cd $BUILDROOT
#echo -e "\e[92mlibswitchhw  built\e[39m"
#sleep 5


#cd $PWD/$USERSPACE/wrsw_hal
#make clean
#make
#cd $BUILDROOT
#echo -e "\e[92mwrsw_hal built\e[39m"
#sleep 5

#cd $PWD/$USERSPACE/wrsw_rtud
#make clean
#make
#cd $BUILDROOT
#echo -e "\e[92mwrsw_rtud built\e[39m"
#sleep 5

#cd $PWD/$USERSPACE/ptp-noposix
#make clean
#make
#cd $BUILDROOT
#echo -e "\e[92mptp-noposix built\e[39m"
#sleep 5

#cd $PWD/$USERSPACE/tools
#make clean
#make 
#make install
#cd $BUILDROOT
#echo -e "\e[92mtools built\e[39m"
#sleep 5

##Let's now copy binaries to the generated buildroot filesystem#
#echo "do not forget to copy binaries"
#echo "make buildroot again"

### Install (copy) drivers .ko, binaries and libraries to target/
#cd $PWD/$USERSPACE/
#make install
#cd $BUILDROOT


## Compile Spec drivers
./spec-sw-drivers.sh
## Re-Generate root filesystem
cd $BUILDROOT
make 

## Run copy_to_tftpfolder 
./copy_to_tftpfolder.sh

