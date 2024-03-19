#include "stdio.h"

#define SCR_MAX_COLS 80
#define SCR_MAX_ROWS 25

static char *videoMemory = (char *)0xb8000;
unsigned int scrX = 0, scrY = 0;

void putc(char c) {
    *(videoMemory + (scrX++ * 2)) = c;
    if (scrX >= SCR_MAX_COLS) {
        scrX = 0;
        scrY++;
    }
}

void puts(char *s) {
    for (unsigned i = 0; *(s+i); i++) putc(*(s+i));
}
