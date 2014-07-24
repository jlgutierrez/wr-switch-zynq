wr-switch-zynq
==============
This project creates a linux based system for the Zedboard development platform. 


Folder Description
==================
* SDK_Export - Zedboard SDK project. Used to create the boot.bin which must be included in the SD card. Includes:
    - system.bin: Hardware FPGA bitstream
    - u-boot.elf: Bootloader (generated using buildroot)
    - zynq_fbsl_0: First zedboard bootloader
    - boot.bin: Boot binary for the SD card
    - boot.bif: Description file to create the boot.bin binary.
* buildroot - Tool-chain to generate:
    - u-boot bootloader
    - Linux kernel image for the zedboard
    - root file system
* buildroot/userspace - Contains the filesystem you want to add to the output filesystem.
* sdboot: Contains a precompiled boot.bin binary file for the SD card
* xilinx - Some tests


Adding New Features & Programms
===============================
By default, buildroot configures a set of tools, programs and libraries complete enough to work with. If you need to include new programs you just need to run the following makes in the buildroot folder:

* make xconfig: for buildroot configuration (libraries, programs, daemons, etc)
* make linux-xconfig: for linux kernel customization

For more info please visit the Buildroot website: http://buildroot.uclibc.org/downloads/manual/manual.html

NOTE: If you want to include your own files or programs, just copy them in the buildroot/userspace folder and they will be added to the uramdisk image after "make" command.


Usage & Installation
====================
At this point this project targets (and has been prepared) to load the boot.bin boot file from the SD card.
Both uImage kernel and root filesystem are loaded from a tftp server. The tftp server must be configured in your computer.

Four files are necessary to load a linux system in the zedboard: 

    - a linux kernel (uImage) [tftp]
    - the root filesystem (uramdisk.image.gz) [tftp]
    - the bootloader (boot.bin) [SD]
    - the device tree file (devicetree.dtb) [tftp]
    
The linux kernel, the root filesystem and the device tree are compiled/generated using the buildroot toolchain (already configured). Moreover, it compiles a u-boot.elf file, 
necessary to generate the SD bootloader (boot.bin) using Vivado SDK.
The bootloader (boot.bin) has been generated using the u-boot bootloader compiled, the synthesized hardware bitstream and a pre-bootloader (fsbl) for the zedboard. 
The boot.bin file is in sdboot/ folder, so that it is not neccesary to compile it again, just put it into your SD card.

Next steps will guide you in the generation process of compiling the linux kernel, the root filesystem and device tree that must be loaded using a tftp server in your computer.

NOTE: You shall have installed a cross-compiler. Xilinx arm cross-compiler recommended.

Steps:

1. Prepare your tftp server:

    - sudo apt-get install xinetd
    - nano /etc/xinetd.d/tftp
    - edit line:  server_args     = /path/to/your/tftpboot/folder/
    - sudo service xinetd restart

    NOTE: If it tftp does not work, try to copy /etc/xinetd.d/tftp to /etc/xinetd.conf and restart the service again (check permissions too)
  
2. Copy sdboot/boot.bin into your SD card and configure the zedboard jumpers to load the boot system from the SD card as shown.

        | |X|X| | |  
        |X|X|X|X|X| 
        |X| | |X|X|

3. Compile the u-boot bootloader, device-tree, linux kernel and create the root filesystem. Buildroot is already configure for the zedboard.
    - cd builroot
    - make clean
    - make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- (do not use "make -j", compilation crashes)
    
    After this, you should have a zynq-zed.dtb file (device tree), the kernel image (uImage) and the root file system (rootfs.cpio.uboot).
    A u-boot bootloader is created too. It must be used (in case you don't use the one in sdboot/) to create the boot.bin file for the SD Card using the Vivado SDK but you can use the one in sdboot/ folder.

4. Run the copy_to_tftpfolder.sh script. It will :
    - check whether xinetd (tftp daemon) is running
    - check whether kernet, device tree and root filesystem files have been created in output/images/ folder.
    - fix an ethernet bug in device-tree file
    - Copy and rename those files to you tftp folder set in /etc/xinetd.d/tftp

5. Open a serial port terminal and connect to the Zedboard uart port. If everything is fine you should see the zedboard u-boot prompt.
6. Configuring Zedboard IP and TFTP server. By default the Zedboard would not have an IP address and does not know where the tftp server is. 
    In the u-boot prompt:
    - setenv gatewayip 192.168.1.1
    - setenv netmask 255.255.255.0
    - setenv ipaddr 192.168.1.80
    - setenv serverip 192.168.1.61
    - setenv bootcmd run jtagboot
    - saveenv
   
Reboot and everthing should work.

- User = root
- Pass = ""

Have fun!
    
    
    
    
    
    
    
    
    
    