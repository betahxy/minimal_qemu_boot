#include "multiboot2.h"

/** 
 * Multiboot2-compliant booting code for i386/x86_64 target architecture
 * @author:betahxy
 */

#define VGA_addr 0xb8000

int kmain(){
    char *str = "Hello world! This is elf-32 + multiboot2.";
    unsigned char * vga_ptr = (unsigned char*)VGA_addr;
    while(*str != '\0'){
        *(vga_ptr++) = *(str++);
        *(vga_ptr++) = 12; /* red color */
    }
    while(1){}
}