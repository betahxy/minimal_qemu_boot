#include "multiboot2.h"

/** 
 * Multiboot2-compliant booting code for i386/x86_64 target architecture
 * @author:betahxy
 */

/** 
You have to make this first multiboot section 64-bit(8 bytes) alitned 
in your final image file used to boot system.

Since multiboot2 requires that the multiboot2 header must be 64-bit aligned in image file 
and within its first 32768 bytes.

If you find that grub complained that "multiboot header cannot be found", possibly you 
have to check your image if it has correct multiboot headers alignment
*/

/* Multiboot2 header must be contained completely within the first 32768 bytes of the OS image, and must be 64-bit aligned */
.section .multiboot
multiboot_start:

    /* Must have multiboot2 header field */
    .long MULTIBOOT2_HEADER_MAGIC
    .long MULTIBOOT_ARCHITECTURE_I386
    .long multiboot_end - multiboot_start
    .long -(MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (multiboot_end - multiboot_start))

    /* End tag of multiboot2 */
    .short MULTIBOOT_HEADER_TAG_END
    .short 0
    .long 8

multiboot_end:


/* 
Grub enters 32-bit mode, so your first section should use 32-bit code.
You can try to jump to 64 bit yourself then if you want.
*/
.code32
.section .text
.global entry_point
entry_point:
    mov $kmain,%eax
    jmp *%eax
    jmp .


 