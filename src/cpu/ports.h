#pragma once

#include <stdint.h>

unsigned char inb (uint16_t port);
void outb (uint16_t port, uint8_t data);
unsigned short port_word_in (uint16_t port);
void port_word_out (uint16_t port, uint16_t data);
