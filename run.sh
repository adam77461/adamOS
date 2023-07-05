#!/bin/sh



if test "`whoami`" != "root" ; then
	echo "You must be logged in as root to build (for loopback mounting)"
	echo "Enter 'su' or 'sudo bash' to switch to root"
	exit
fi


if [ ! -e adam_os.flp ]
then
	mkdosfs -C adam_os.flp 1440 
fi


nasm -O0 -w+orphan-labels -f bin -o  bootloader.bin Bootloader.asm

nasm -O0 -w+orphan-labels -f bin -o kernel.bin Kernel.asm 

dd status=noxfer conv=notrunc if=bootloader.bin of=adam_os.flp


rm -rf tmp-loop

mkdir tmp-loop && mount -o loop -t vfat adam_os.flp tmp-loop && cp kernel.bin tmp-loop/

sleep 0.2

umount tmp-loop 

rm -rf tmp-loop

rm -f adam_os.iso
mkisofs -quiet -V 'ADAM_OS' -input-charset iso8859-1 -o adam_os.iso -b adam_os.flp ./ 


echo '>>> Done!'
