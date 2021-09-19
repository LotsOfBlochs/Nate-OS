#include "idt.h"
#include "type.h"

idt_gate_t idt[IDT_ENTRIES];
idt_register_t idt_reg;

void set_idt_gate(int n, uint64_t handler) {
    idt[n].offset_1 = low_16(handler);
    idt[n].selector = KERNEL_CS;
    idt[n].ist = 0;
    idt[n].type_attr = 0x8E; 
    idt[n].offset_2 = mid_16(handler);
    idt[n].offset_3 = high_32(handler);
    idt[n].zero = 0;
}

void set_idt() {
    idt_reg.base = (uint32_t) &idt;
    idt_reg.limit = IDT_ENTRIES * sizeof(idt_gate_t) - 1;
    /* Don't make the mistake of loading &idt -- always load &idt_reg */
    asm volatile("lidtq (%0)" : : "r" (&idt_reg));
    //asm volatile("sti");
}