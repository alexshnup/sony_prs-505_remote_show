#!/bin/sh
echo $'\n===============\nSTART SCRYPT\n'  >> /dev/console


#TODO "here need Kernel Event instead while and sleep bottom placed"
function waitnewdata
{
	echo $'\n===============\nWait new data\n'  >> /dev/console

	#Show only modify time the image file
	MODIFYTIMEOLD=`ls -l --full-time /tmp/raw.img | awk ' {print $9} '`
	MODIFYTIMENEW=$MODIFYTIMEOLD

	while [ "$MODIFYTIMEOLD" == "$MODIFYTIMENEW" ]
	do
	MODIFYTIMENEW=`ls -l --full-time /tmp/raw.img | awk ' {print $9} '`

	sleep 0.2 
	done

	showpic
}

function showpic
{
	echo $'\n===============\nNew data received\n'  >> /dev/console

	if [ "$MODIFYTIMEOLD" != "$MODIFYTIMENEW" ]
	then
	echo $'\n===============\nOK!!! New data received\n'  >> /dev/console

	#Back Screen for best clear e-ink (optional)
	dd if=/dev/zero of=/tmp/img.raw bs=1k count=480
	/Data/showpic /tmp/img.raw

	dd if=/tmp/raw.img of=/tmp/img.raw bs=1k count=480
	/Data/showpic /tmp/img.raw
	fi
	waitnewdata
}


#ldconfig
PATH="/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games:/usr/local/sony/bin:/usr/sbin:/sbin"
LD_LIBRARY_PATH="/Data/opt/sony/ebook/application:/lib:/usr/lib:/usr/local/sony/lib:/opt/sony/ebook/lib"
export PATH LD_LIBRARY_PATH

# set initial date
/bin/date 0101000007

#echo $'\n===============\nRUN MY SCRYPT\n'  >> /dev/console
#echo $'\n===============\nkillall tinyhttp\n'  >> /dev/console
#killall tinyhttp.sh
#killall tinyhttp
echo $'\n===============\nrmmod g_file_storage\n'  >> /dev/console
rmmod g_file_storage





#Create raw file 1Mb 
echo $'\n===============\nDD\n'  >> /dev/console
dd if=/dev/zero of=/tmp/raw.img bs=1k count=1k

#echo $'\n===============\nmkdosfs\n'  >> /dev/console
#mkdosfs /tmp/fat.img
#insmod g_file_storage file=/dev/mtdblock17,/tmp/fat.img

grep Data /proc/mtd > /dev/null
if [ $? == 0 ]; then
		echo $'\n===============\nLoad g_file_storage with mtd\n'  >> /dev/console

        NUM=`grep Data /proc/mtd | awk -F: '{print $1}' | awk -Fd '{print$2}'`
        insmod /lib/modules/2.4.17_n12/kernel/drivers/usb/g_file_storage.o file=/dev/mtdblock$NUM,/dev/sdmscard/r5c807b,/dev/sdmscard/r5c807a,/tmp/raw.img ProductID=$MODEL VendorSpecific=$VENDOR sn_select=0 iSerialNumber=$ID
else
		echo $'\n===============\nLoad g_file_storage without mtd\n'  >> /dev/console
        insmod /lib/modules/2.4.17_n12/kernel/drivers/usb/g_file_storage.o file=/dev/sdmscard/r5c807b,/dev/sdmscard/r5c807a ProductID=$MODEL VendorSpecific=$VENDOR sn_select=0 iSerialNumber=$ID
		echo $'\n===============\nno Data pertition\n'  >> /dev/console
fi


echo $'\n===============\nSet Env\n'  >> /dev/console


#start kbook application
nohup  /opt/sony/ebook/application/tinyhttp > /dev/null &

waitnewdata




