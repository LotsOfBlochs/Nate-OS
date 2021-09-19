#pragma once

#include <stdint.h>

/* Segment selectors */
#define KERNEL_CS 0x08

/* How every interrupt gate (handler) is defined */
typedef struct {
   uint16_t offset_1; // offset bits 0..15
   uint16_t selector; // a code segment selector in GDT or LDT
   uint8_t ist;       // bits 0..2 holds Interrupt Stack Table offset, rest of bits zero.
   uint8_t type_attr; // type and attributes
   uint16_t offset_2; // offset bits 16..31
   uint32_t offset_3; // offset bits 32..63
   uint32_t zero;     // reserved
} __attribute__((packed)) idt_gate_t ;

/* A pointer to the array of interrupt handlers.
 * Assembly instruction 'lidt' will read it */
typedef struct {
    uint16_t limit;
    uint64_t base;
} __attribute__((packed)) idt_register_t;

#define IDT_ENTRIES 256

/* Functions implemented in idt.c */
void set_idt_gate(int n, uint64_t handler);
void set_idt();