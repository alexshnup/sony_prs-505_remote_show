/* showpic.c 
from habrahabr.ru user Сергей @dlinyj */
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <string.h>


#define FBIO_EINK_GET_TEMPERATURE        0x46A1    //Returns temperature in degree Celsius
#define FBIO_EINK_DISP_PIC                0x46A2    //Displays picture

int main (int argc, char* argv[])
{
    printf ("Show image\n");

    int *fb, *image;
    int pio_fd = open ( "/dev/fb0", O_RDWR);
    int f_image = open ( argv[1], O_RDWR);                                 //open file into arg
    int t= ioctl (pio_fd, FBIO_EINK_GET_TEMPERATURE, NULL);    //configure framebuffer

    fb= mmap(0, 800*600, PROT_WRITE, MAP_SHARED, pio_fd, 0);    //map device into memory
    image= mmap(0, 800*600, PROT_READ, MAP_SHARED, f_image, 0); //load image into memory
    
    memcpy(fb,image,800*600);
    ioctl (pio_fd, FBIO_EINK_DISP_PIC, 0);
    
    close(pio_fd);
    close(f_image);
    return 0;
}
