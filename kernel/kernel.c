#include "../drivers/display.h"

void printLogo();

void kernel() {
    init_tty();
    printLogo();

    putstr("\n\n\n$> ");
}


void printLogo() {
    putstr(" __  __       _                    ___  ____\n");
    putstr("|  \\/  | __ _| |_ _   _ _ __ __ _ / _ \\/ ___|\n");
    putstr("| |\\/| |/ _` | __| | | | '__/ _` | | | \\___ \\\n");
    putstr("| |  | | (_| | |_| |_| | | | (_| | |_| |___) |\n");
    putstr("|_|  |_|\\__,_|\\__|\\__,_|_|  \\__,_|\\___/|____/\n");
    putchar('\n');
    putstr("Pozdravljeni v MaturaOS - najbolj povprecnem operacijskem sistemu");
}

