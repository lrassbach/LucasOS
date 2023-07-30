/* x86 crti.s */
.section .init
.global _init
.type _init, @function
_init:
        push %ebp
        mov %esp, %ebp
        /* gcc will nicely put the contents of crtbegins.o's .init section here. */

.section .fini
.global _fini
.type _fini, @function
_fini:
        push %ebp
        mov %esp, %ebp
        /* gcc will nicely put the contents of crtbegin.o's fini section here */
