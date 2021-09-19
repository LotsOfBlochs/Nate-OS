%macro PUSHALL 0
  	push rax
  	push rcx
  	push rdx
  	push r8
  	push r9
  	push r10
  	push r11
%endmacro

%macro POPALL 0
  	pop r11
  	pop r10
  	pop r9
  	pop r8
  	pop rdx
  	pop rcx
  	pop rax

%endmacro

%macro popToReg 0
    ;pop r8
    ;pop r9
    ;jmp $
%endmacro

; Defined in isr.c
[extern isr_handler]
[extern irq_handler]
; Common ISR code
isr_common_stub:
    mov bp, 0x7c00
break:
    ; 1. Save CPU state
	PUSHALL ; Pushes edi,esi,ebp,esp,ebx,edx,ecx,eax
	;mov ax, ds ; Lower 16-bits of eax = ds.
	;push rax ; save the data segment descriptor
	;mov ax, 0x10  ; kernel data segment descriptor
    ;mov ds, ax
	;mov es, ax
	;mov fs, ax
	;mov gs, ax
	push rsp ; registers_t *r
    ; 2. Call C handler
    cld ; C code following the sysV ABI requires DF to be clear on function entry
    call isr_handler
	
    ; 3. Restore state
	;pop rax 
    ;pop rax
	;mov ds, ax
	;mov es, ax
	;mov fs, ax
	;mov gs, ax
	POPALL
breakpoint1:
	add rsp, 8 ; Cleans up the pushed error code and pushed ISR number
breakpoint2:
    iret ; pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP

; Common IRQ code. Identical to ISR code except for the 'call' 
; and the 'pop ebx'
irq_common_stub:
    mov bp, 0x7c00
    PUSHALL 
    ;mov ax, ds
    ;push rax
    ;mov ax, 0x10
    ;mov ds, ax
    ;mov es, ax
    ;mov fs, ax
    ;mov gs, ax
    push rsp
    cld
    call irq_handler ; Different than the ISR code
    ;pop rbx  ; Different than the ISR code
    ;pop rbx
    ;mov ds, bx
    ;mov es, bx
    ;mov fs, bx
    ;mov gs, bx
    POPALL
breakpoint3:
    add rsp, 8
breakpoint4:
    iret
	
; We don't get information about which interrupt was caller
; when the handler is run, so we will need to have a different handler
; for every interrupt.
; Furthermore, some interrupts push an error code onto the stack but others
; don't, so we will push a dummy error code for those which don't, so that
; we have a consistent stack for all of them.

; First make the ISRs global
global isr0
global isr1
global isr2
global isr3
global isr4
global isr5
global isr6
global isr7
global isr8
global isr9
global isr10
global isr11
global isr12
global isr13
global isr14
global isr15
global isr16
global isr17
global isr18
global isr19
global isr20
global isr21
global isr22
global isr23
global isr24
global isr25
global isr26
global isr27
global isr28
global isr29
global isr30
global isr31
; IRQs
global irq0
global irq1
global irq2
global irq3
global irq4
global irq5
global irq6
global irq7
global irq8
global irq9
global irq10
global irq11
global irq12
global irq13
global irq14
global irq15

; 0: Divide By Zero Exception
isr0:
    mov [0xb8000], byte '0'
    push 0x0000
    popToReg
    jmp isr_common_stub

; 1: Debug Exception
isr1:
    mov [0xb8000], byte '1'
    push byte 0
    push byte 1
    popToReg
    jmp isr_common_stub

; 2: Non Maskable Interrupt Exception
isr2:
    mov [0xb8000], byte '2'
    push byte 0
    push byte 2
    popToReg
    jmp isr_common_stub

; 3: Int 3 Exception
isr3:
    mov [0xb8000], byte '3'
    push byte 0
    push byte 3
    popToReg
    jmp isr_common_stub

; 4: INTO Exception
isr4:
    mov [0xb8000], byte '4'
    push byte 0
    push byte 4
    popToReg
    jmp isr_common_stub

; 5: Out of Bounds Exception
isr5:
    mov [0xb8000], byte '5'
    push byte 0
    push byte 5
    popToReg
    jmp isr_common_stub

; 6: Invalid Opcode Exception
isr6:
    mov [0xb8000], byte '6'
    push byte 0
    push byte 6
    popToReg
    jmp isr_common_stub

; 7: Coprocessor Not Available Exception
isr7:
    mov [0xb8000], byte '7'
    push byte 0
    push byte 7
    popToReg
    jmp isr_common_stub

; 8: Double Fault Exception (With Error Code!)
isr8:
    mov [0xb8000], byte '8'
    ; Do not push fake error code CPU pushes error code for us
    push byte 8
    popToReg
    jmp isr_common_stub

; 9: Coprocessor Segment Overrun Exception
isr9:
    mov [0xb8000], byte '9'
    push byte 0
    push byte 9
    popToReg
    jmp isr_common_stub

; 10: Bad TSS Exception (With Error Code!)
isr10:
    mov [0xb8000], byte 'a'
    ; Do not push fake error code CPU pushes error code for us
    push byte 10
    popToReg
    jmp isr_common_stub

; 11: Segment Not Present Exception (With Error Code!)
isr11:
    mov [0xb8000], byte 'b'
    push byte 0
    push byte 11
    popToReg
    jmp isr_common_stub

; 12: Stack Fault Exception (With Error Code!)
isr12:
    mov [0xb8000], byte 'c'
    ; Do not push fake error code CPU pushes error code for us
    push byte 12
    popToReg
    jmp isr_common_stub

; 13: General Protection Fault Exception (With Error Code!)
isr13:
    mov [0xb8000], byte 'd'
    ; Do not push fake error code CPU pushes error code for us
    push byte 13
    popToReg
    jmp isr_common_stub

; 14: Page Fault Exception (With Error Code!)
isr14:
    mov [0xb8000], byte 'e'
    ; Do not push fake error code CPU pushes error code for us
    push byte 14
    popToReg
    jmp isr_common_stub

; 15: Reserved Exception
isr15:
    mov [0xb8000], byte 'f'
    push byte 0
    push byte 15
    popToReg
    jmp isr_common_stub

; 16: Floating Point Exception
isr16:
    mov [0xb8000], byte 'g'
    push byte 0
    push byte 16
    popToReg
    jmp isr_common_stub

; 17: Alignment Check Exception
isr17:
    mov [0xb8000], byte 'h'
    push byte 0
    push byte 17
    popToReg
    jmp isr_common_stub

; 18: Machine Check Exception
isr18:
    mov [0xb8000], byte 'i'
    push byte 0
    push byte 18
    popToReg
    jmp isr_common_stub

; 19: Reserved
isr19:
    push byte 0
    push byte 19
    popToReg
    jmp isr_common_stub

; 20: Reserved
isr20:
    push byte 0
    push byte 20
    jmp isr_common_stub

; 21: Reserved
isr21:
    push byte 0
    push byte 21
    jmp isr_common_stub

; 22: Reserved
isr22:
    push byte 0
    push byte 22
    jmp isr_common_stub

; 23: Reserved
isr23:
    push byte 0
    push byte 23
    jmp isr_common_stub

; 24: Reserved
isr24:
    push byte 0
    push byte 24
    jmp isr_common_stub

; 25: Reserved
isr25:
    push byte 0
    push byte 25
    jmp isr_common_stub

; 26: Reserved
isr26:
    push byte 0
    push byte 26
    jmp isr_common_stub

; 27: Reserved
isr27:
    push byte 0
    push byte 27
    jmp isr_common_stub

; 28: Reserved
isr28:
    push byte 0
    push byte 28
    jmp isr_common_stub

; 29: Reserved
isr29:
    push byte 0
    push byte 29
    jmp isr_common_stub

; 30: Reserved
isr30:
    push byte 0
    push byte 30
    jmp isr_common_stub

; 31: Reserved
isr31:
    push byte 0
    push byte 31
    jmp isr_common_stub

; IRQ handlers
irq0:
	push byte 0
	push byte 32
	jmp irq_common_stub

irq1:
	push byte 1
	push byte 33
	jmp irq_common_stub

irq2:
	push byte 2
	push byte 34
	jmp irq_common_stub

irq3:
	push byte 3
	push byte 35
	jmp irq_common_stub

irq4:
	push byte 4
	push byte 36
	jmp irq_common_stub

irq5:
	push byte 5
	push byte 37
	jmp irq_common_stub

irq6:
	push byte 6
	push byte 38
	jmp irq_common_stub

irq7:
	push byte 7
	push byte 39
	jmp irq_common_stub

irq8:
	push byte 8
	push byte 40
	jmp irq_common_stub

irq9:
	push byte 9
	push byte 41
	jmp irq_common_stub

irq10:
	push byte 10
	push byte 42
	jmp irq_common_stub

irq11:
	push byte 11
	push byte 43
	jmp irq_common_stub

irq12:
	push byte 12
	push byte 44
	jmp irq_common_stub

irq13:
	push byte 13
	push byte 45
	jmp irq_common_stub

irq14:
	push byte 14
	push byte 46
	jmp irq_common_stub

irq15:
	push byte 15
	push byte 47
	jmp irq_common_stub