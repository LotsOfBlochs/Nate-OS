#include "keyboard.h"
#include "../cpu/ports.h"
#include "../cpu/isr.h"
#include "screen.h"
#include "../libc/string.h"
#include "../libc/function.h"
#include "../kernel/kernel.h"
#include <stdbool.h>

#define BACKSPACE 0x0E
#define ENTER 0x1C
#define LSHIFT 0x2A
#define RSHIFT 0x36
#define CAPSLOCK 0x3A

static char key_buffer[256];
static bool shifted = false;

#define SC_MAX 57
const char *uc_sc_name[] = { "ERROR", "Esc", "1", "2", "3", "4", "5", "6", 
    "7", "8", "9", "0", "-", "=", "Backspace", "Tab", "Q", "W", "E", 
        "R", "T", "Y", "U", "I", "O", "P", "[", "]", "Enter", "Lctrl", 
        "A", "S", "D", "F", "G", "H", "J", "K", "L", ";", "'", "`", 
        "LShift", "\\", "Z", "X", "C", "V", "B", "N", "M", ",", ".", 
        "?", "RShift", "Keypad *", "LAlt", "Spacebar"};
const char uc_sc_ascii[] = { 0, 0, '!', '@', '#', '$', '%', '^',     
    '&', '*', '(', ')', '_', '+', 0, 0, 'Q', 'W', 'E', 'R', 'T', 'Y', 
        'U', 'I', 'O', 'P', '{', '}', 0, 0, 'A', 'S', 'D', 'F', 'G', 
        'H', 'J', 'K', 'L', ':', '\"', '~', 0, '|', 'Z', 'X', 'C', 'V', 
        'B', 'N', 'M', '<', '>', '?', 0, 0, 0, ' '};

const char *lc_sc_name[] = { "ERROR", "Esc", "1", "2", "3", "4", "5", "6", 
    "7", "8", "9", "0", "-", "=", "Backspace", "Tab", "Q", "W", "E", 
        "R", "T", "Y", "U", "I", "O", "P", "[", "]", "Enter", "Lctrl", 
        "A", "S", "D", "F", "G", "H", "J", "K", "L", ";", "'", "`", 
        "LShift", "\\", "Z", "X", "C", "V", "B", "N", "M", ",", ".", 
        "/", "RShift", "Keypad *", "LAlt", "Spacebar"};
const char lc_sc_ascii[] = { 0, 0, '1', '2', '3', '4', '5', '6',     
    '7', '8', '9', '0', '-', '=', 0, 0, 'q', 'w', 'e', 'r', 't', 'y', 
        'u', 'i', 'o', 'p', '[', ']', 0, 0, 'a', 's', 'd', 'f', 'g', 
        'h', 'j', 'k', 'l', ';', '\'', '`', 0, '\\', 'z', 'x', 'c', 'v', 
        'b', 'n', 'm', ',', '.', '/', 0, 0, 0, ' '};

static void keyboard_callback(registers_t regs) {
    /* The PIC leaves us the scancode in port 0x60 */
    uint8_t scancode = inb(0x60);
    
    if (scancode == LSHIFT || scancode == RSHIFT) shifted = !shifted;
    else if (scancode == LSHIFT + 0x80 || scancode == RSHIFT + 0x80) shifted = !shifted;
    else if (scancode == CAPSLOCK) shifted == !shifted;
    else if (scancode > SC_MAX) return;
    else if (scancode == BACKSPACE) {
        backspace(key_buffer);
        kprint_backspace();
    } else if (scancode == ENTER) {
        kprint("\n");
        user_input(key_buffer); /* kernel-controlled function */
        key_buffer[0] = '\0';
    } else {
        char letter;
        if (shifted == true){
            letter = uc_sc_ascii[(int)scancode];
        }else{
            letter = lc_sc_ascii[(int)scancode];
        }
        /* Remember that kprint only accepts char[] */
        char str[2] = {letter, '\0'};
        append(key_buffer, letter);
        kprint(str);
    }
    UNUSED(regs);
}

void init_keyboard() {
   register_interrupt_handler(IRQ1, keyboard_callback); 
}