#include "display.h"

#include <stddef.h>
#include <stdint.h>

#define SCR_MAX_COLS 80
#define SCR_MAX_ROWS 25

static uint16_t *const videoMemory = (uint16_t *)0xb8000;
size_t scrX = 0, scrY = 0;
uint8_t terminalColor;

void clearscr();
uint8_t makeColor(enum vgacolor fg, enum vgacolor bg);
uint16_t makeVGAEntry(char c, uint8_t color);

void tty_put_char_at(char c, size_t x, size_t y, uint8_t color) {
    const uint16_t entry = makeVGAEntry(c, color);
    videoMemory[y * SCR_MAX_COLS + x] = entry;
}

void init_tty() {
    clearscr();
}

void putchar(char c) {
    if (scrX >= SCR_MAX_COLS) {
        scrX = 0;
        scrY++;
    }

    switch (c) {
        case '\n':
            scrX = 0;
            scrY++;
            return;
        case '\t':
            for (char i = 0; i < 4; i++)
                tty_put_char_at(' ', scrX++, scrY, terminalColor);
            return;
        case '\0':
            return;
    }
    
    tty_put_char_at(c, scrX++, scrY, terminalColor);
}

void putstr(char *s) {
    for (uint8_t i = 0; *(s+i); i++) putchar(*(s+i));
}

void clearscr() {
    terminalColor = makeColor(VGA_COLOR_RED, VGA_COLOR_BLACK);
    for (size_t i = 0; i < SCR_MAX_ROWS; i++) {
        for (size_t j = 0; j <= SCR_MAX_COLS; j++) {
            videoMemory[i * SCR_MAX_COLS + j] = makeVGAEntry(' ', terminalColor);
        }
    }
}

uint16_t makeVGAEntry(char c, uint8_t color) {
    return c | color << 8;
}
uint8_t makeColor(enum vgacolor fg, enum vgacolor bg) {
    return fg | bg << 4;
}
