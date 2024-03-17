#include "stdio.h"


const char x = 'L';

void putc(char c) {
    char *videoMemory = (char *)0xb8000;
    *videoMemory = x;
}
