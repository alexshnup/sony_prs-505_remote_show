# Info

This script for remotely display images on the E-ink screen Sony Reader PRS-505 using tmpfs RAM drive and command "dd". Updating image takes less than a second.

#Install and use

If you have already installed the firmware [prs-plus](https://code.google.com/archive/p/prs-plus/), then you just need to put prsp.sh file to a specified "directory/database/system/PRSPlus". Reboot reader without cable connected (to allow start sctypt). Reader it will continue to operate as normal but also can remotely display images via USB cable. When connected to the USB, you will see the new RAW disk size of 1 MB. Did'nt need to format, it should be RAW. With command "dd" can display images on the screen.

#for Ubuntu

Install djpeg for convert jpg file
```
apt-get install libjpeg-turbo-progs
```

Let's find the disk size of 1MB.
```
fdisk -l
```
We find a similar line in the output:
...
Disk /dev/sde: 1 MB, 1048576 bytes
...
Now we know that we must send the image to "/dev/sde"


Create any jpg file with size  600x800
 
Now you can send image to e-ink
```
djpeg -pnm -grayscale test.jpg |dd of=/dev/sde bs=480k
```

#Additional information
This script create a tmpfs temporary drive to the RAM memory and does not save anything on the flash memory. This method will not damage your reader and is safe.

