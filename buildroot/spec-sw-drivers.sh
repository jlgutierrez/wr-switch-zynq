
#!/bin/sh
########################################################################
#  spec-sw-drivers.sh
# 
# blablabla
# 
#   Created on: Sep 17, 2014
#   Authors:
#  		- José Luis Gutiérrez
#	Institutions: 
#		- University of Granada
########################################################################
PATCHES_SPECSW=patches/spec-sw
OUTPUT=output
USERSPACE=userspace
BUILDROOT=$PWD
WR_SPEC_INSTALL_ROOT=$PWD/output/target/wr/lib/modules
## Let's build userspace ##

## Set ARCH & CROSS_COMPILE
export ARCH=arm

# Check own buildroot cross-compiler exists

if [ -f output/host/usr/bin/arm-linux-gcc ]; then
export CROSS_COMPILE=$PWD/output/host/usr/bin/arm-linux-
else 
	echo -e "\e[91mError: arm-linux-gcc does not exist in buildroot folder\e[39m"
	echo -e "\e[91mExiting...\e[39m"
	echo "Please run make to generate buildroot cross-compiler"
	exit
fi

if [ -d output/build/linux-3.14.4 ]; then
export LINUX=$PWD/output/build/linux-3.14.4
else 
	echo -e "\e[91mError: linux-3.14.4 not found in buildroot build folder\e[39m"
	echo -e "\e[91mExiting...\e[39m"
	echo "Please run make to generate buildroot linux-3.14.4 headers and sources."
	exit
fi

echo "*********************************************************************"
echo "**** Removing, downloading, patching and copying ko drivers to output/target/wr/lib/modules:"
echo "**** ARCH=$ARCH"
echo "**** CROSS_COMPILE=$CROSS_COMPILE"
echo "**** INSTALL_KO_FOLDER=$WR_SPEC_INSTALL_ROOT"
echo "**** LINUX=$LINUX"
echo "**** PATCHES_DIR=$PATCHES_SPECSW"
echo "*********************************************************************"
sleep 3

rm -rf output/build/spec-sw/
cd output/build
git clone git://ohwr.org/fmc-projects/spec/spec-sw.git
cd spec-sw
git submodule init && git submodule update


# Apply patches
echo -e "\e[92mAppying patches\e[39m"
cp $BUILDROOT/$PATCHES_SPECSW/0001fmc-bus-zedboard-kernel-3.14.4-fix.patch fmc-bus/
cp $BUILDROOT/$PATCHES_SPECSW/0002spec-sw-zedboard-kernel3.14.4-adaptation.patch ./
cd fmc-bus/
git apply 0001fmc-bus-zedboard-kernel-3.14.4-fix.patch
cd ..
git apply 0002spec-sw-zedboard-kernel3.14.4-adaptation.patch
sleep 3

# Compile drivers
echo -e "\e[92mCompiling drivers\e[39m"
make clean
make
sleep 3

# Copy *.ko files to buildroot/output/target/wr/lib/modules
mkdir -p $WR_SPEC_INSTALL_ROOT
cp fmc-bus/kernel/*.ko $WR_SPEC_INSTALL_ROOT
cp kernel/*.ko $WR_SPEC_INSTALL_ROOT
echo -e "\e[92m*.ko files are now copied to buildroot/output/target/wr/lib/modules\e[39m"

#echo -e "\e[92mRecompiling rootfilesystem with spec-sw drivers\e[39m"
#cd $BUILDROOT
#make







