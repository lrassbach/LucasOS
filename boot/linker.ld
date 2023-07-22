/* The bootloader will look at this image and start execution at the symbol designated as the entry point. */

OBJS:=*.o

CRTI_OBJ=crti.o
CRTBEGIN_OBJ:=$(shell $(CC) $(CFLAGS) -print-file-name=crtbegin.o)
CRTEND_OBJ:=$(shell $(CC) $(CFLAGS) -print-file-name=crtend.o)
CRTN_OBJ=crtn.o

OBJ_LINK_LIST:=$(CRTI_OBJ) $(CRTBEGIN_OBJ) $(OBJS) $(CRTEND_OBJ) $(CRTN_OBJ)
INTERNAL_OBJS:=$(CRTI_OBJ) $(OBJS) $(CRTN_OBJ)

myos.kernel: $(OBJ_LINK_LIST)
	$(CC) -o myos.kernel $(OBJ_LINK_LIST) -nostdlib -lgcc

clean:
	rm -f myos.kernel $(INTERNAL_OBJS)


ENTRY(_start)

/* Tell where the various sections of the object files will be put in the final kernel image */

SECTIONS
{
	/* Begin putting sections at 1MiB a conventional place for kernels to be loaded at by the bootloader */
	. = 1M;

	/* First put the multiboot header as it is required to be put very early in the image or the bootloader wont recognize the file format. Next is .text section. */
	.text BLOCK(4K) : ALIGN(4K)
	{
		*(.multiboot)
		*(.text)
	}

	/* read only data */
	.rodata BLOCK(4K) : ALIGN(4K)
	{
		*(.rodata)
	}

	/* read-write data (initialized) */
	.data BLOCK(4K) : ALIGN(4K)
	{
		*(.data)
	}

	/* Read-write data (unitialized) and stack */
	.bss BLOCK(4K) : ALIGN(4K)
	{
		*(COMMON)
		*(.bss)
	}

	/* the compiler may produce other sections by default it will put them in a segment with the same name. Add additional sections as needed manually. */
}
