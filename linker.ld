/** 
 * Multiboot2-compliant booting linker script for i386/x86_64 target architecture
 * @author:betahxy
 */

ENTRY (entry_point)
phys = 0x00100000;  		
SECTIONS {

    . = phys  ;	

    /* You have to make this first section 64-bit(8 bytes) alitned.
     * Since multiboot2 requires that the multiboot2 header must be 64-bit aligned in image file and within its first 8K bytes
     * Linker will not be be 64-bit aligned by default, it depends on different architectures. 
     * For example, for 32-bit i386 target, the default alignment is 4 bytes, which means it could be possible that the 
     * alignment of multiboot2 header is not 8 bytes aligned in the image file after compiled.
     * However, for 64-bit x86_64 target, the default alignment is 8 bytes, which would be perfect for multiboot2.
     */

    .text :  AT(phys) ALIGN(8) {
        *(.multiboot)
        *(.text)
    }
  
    end = .;	
}