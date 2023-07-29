#include <stdio.h>
#include <stdlib.h>

__attribute__((__noreturn__))
void abort(void) {
#if defined(__is_libj)
    // TODO add proper kernel panic
    printf("kernel: panic: abort()");
    asm volatile("hlt");

#else 
    // TODO: Abnormally terminate the process as if by SIGABRT
    printf("abort()\n");
#endif
    while (1) { }
    __builtin_unreachable();
}