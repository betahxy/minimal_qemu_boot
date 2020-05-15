# author: betahxy

# qemu's -kernel flag doesn't support 64-bit ELF image, neither support multiboot2
# Thus, it is impossible that you could use this flag plus a ELF image to load your kernel
# As a result, we use multiboot2 and grub to load our 32/64bit kernel code
# If you would like to compile the 64-bit version ELF + multiboot2 version code
# please remove the -m32 flag in $(CFLAGS) and -melf_i386 flag in $(LDFLAGS)

# It is recommended to compile a freestanding gcc tool chain, thus you don't need 
# to add too many control flags to gcc

CC = x86_64-elf-gcc
CFLAGS = -m32 -ffreestanding -fno-builtin -Wall -g -fno-builtin -nostdinc \
	-nostdlib -mno-red-zone 

LD = x86_64-elf-ld 

# -n option has to be added to tell linker do not use paging because we don't need "demand paging" currently
# this also enables multiboot2 header could appear at the beginning of final kernel image
LDFLAGS = -n -melf_i386 

QEMU = qemu-system-x86_64

OBJS =load.o main.o
TARGET = kernel.img
ISO = $(patsubst %.img,%.iso,$(TARGET))

%.o:%.S
	$(CC) $(CFLAGS) -c -o $@ $<
%.o:%.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(TARGET): $(OBJS) linker.ld 
	$(LD)  $(LDFLAGS) -T linker.ld -o $@ $(OBJS)

qemu:iso
	$(QEMU) -cdrom kernel.iso -m 1024 -no-reboot -S -s -monitor stdio 

iso: $(TARGET)
	mkdir -p iso/boot/grub
	cp grub.cfg iso/boot/grub/
	cp $(TARGET) iso/boot/
	grub-mkrescue -o $(ISO) iso
	
# GDB debug is supported if you would like to use remote gdb debug after starting your kernel
# But you have to use correct gdb version, like 32-bit gdb to debug 32-bit kernel, 64-bit gdb with 64-bit kernel
gdb:
	gdb -tui -x ./gdbinit

clean:
	rm -rf *.o $(TARGET) iso kernel.iso *.d 