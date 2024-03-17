#include "stdio.h"

void putc(char c) {
    char *videoMemory = (char *)0xb8000;

    *videoMemory = c;
}
