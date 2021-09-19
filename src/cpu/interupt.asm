%macro PUSHALL 0
  	push rax
  	push rcx
  	push rdx
    push rbx
    mov rax, rsp
    add rax, 0x10
    push rax
    push rbp
    push rsi
    push rdi
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
    pop rdi
    pop rsi
    pop rbp
    pop rax
    pop rbx
  	pop rdx
  	pop rcx
  	pop rax

%endmacro

%macro popToReg 0
    ;push rbp
    ;mov rbp, rsp 
    ;jmp $
%endmacro

; Defined in isr.c
[extern isr_handler]
[extern irq_handler]
; Common ISR code
isr_common_stub:
break:
    ; 1. Save CPU state
	PUSHALL ; Pushes edi,esi,ebp,esp,ebx,edx,ecx,eax
	mov ax, ds ; Lower 16-bits of eax = ds.
	push rax ; save the data segment descriptor
	mov ax, 0x10  ; kernel data segment descriptor
    mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	push rsp ; registers_t *r
    ; 2. Call C handler
    cld ; C code following the sysV ABI requires DF to be clear on function entry
    call isr_handler
	
    ; 3. Restore state
	pop rax 
    pop rax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	POPALL
breakpoint1:
	add rsp, 8 ; Cleans up the pushed error code and pushed ISR number
breakpoint2:
    ;pop rbp
    iret ; pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP

; Common IRQ code. Identical to ISR code except for the 'call' 
; and the 'pop ebx'
irq_common_stub:
break2:
    PUSHALL 
    mov ax, ds
    push rax
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    push rsp
    cld
    call irq_handler ; Different than the ISR code
    pop rbx  ; Different than the ISR code
    pop rbx
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx
    POPALL
breakpoint3:
    add rsp, 8
breakpoint4:
    pop rbp
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
    popToReg
    ;mov [0xb8000], byte '0'
break3:
    push byte 0
break4:
    push byte 1
    jmp isr_common_stub

; 1: Debug Exception
isr1:
    popToReg
    mov [0xb8000], byte '1'
    push byte 0
    push byte 1
    jmp isr_common_stub

; 2: Non Maskable Interrupt Exception
isr2:
    popToReg
    mov [0xb8000], byte '2'
    push byte 0
    push byte 2
    jmp isr_common_stub

; 3: Int 3 Exception
isr3:
    popToReg
    mov [0xb8000], byte '3'
    push byte 0
    push byte 3
    jmp isr_common_stub

; 4: INTO Exception
isr4:
    popToReg
    mov [0xb8000], byte '4'
    push byte 0
    push byte 4
    jmp isr_common_stub

; 5: Out of Bounds Exception
isr5:
    popToReg
    mov [0xb8000], byte '5'
    push byte 0
    push byte 5
    jmp isr_common_stub

; 6: Invalid Opcode Exception
isr6:
    popToReg
    mov [0xb8000], byte '6'
    push byte 0
    push byte 6
    jmp isr_common_stub

; 7: Coprocessor Not Available Exception
isr7:
    popToReg
    mov [0xb8000], byte '7'
    push byte 0
    push byte 7
    jmp isr_common_stub

; 8: Double Fault Exception (With Error Code!)
isr8:
    popToReg
    mov [0xb8000], byte '8'
    ; Do not push fake error code CPU pushes error code for us
    push byte 8
    jmp isr_common_stub

; 9: Coprocessor Segment Overrun Exception
isr9:
    popToReg
    mov [0xb8000], byte '9'
    push byte 0
    push byte 9
    jmp isr_common_stub

; 10: Bad TSS Exception (With Error Code!)
isr10:
    popToReg
    mov [0xb8000], byte 'a'
    ; Do not push fake error code CPU pushes error code for us
    push byte 10
    jmp isr_common_stub

; 11: Segment Not Present Exception (With Error Code!)
isr11:
    popToReg
    mov [0xb8000], byte 'b'
    push byte 0
    push byte 11
    jmp isr_common_stub

; 12: Stack Fault Exception (With Error Code!)
isr12:
    popToReg
    mov [0xb8000], byte 'c'
    ; Do not push fake error code CPU pushes error code for us
    push byte 12
    jmp isr_common_stub

; 13: General Protection Fault Exception (With Error Code!)
isr13:
    popToReg
    mov [0xb8000], byte 'd'
    ; Do not push fake error code CPU pushes error code for us
    push byte 13
    jmp isr_common_stub

; 14: Page Fault Exception (With Error Code!)
isr14:
    popToReg
    mov [0xb8000], byte 'e'
    ; Do not push fake error code CPU pushes error code for us
    push byte 14
    jmp isr_common_stub

; 15: Reserved Exception
isr15:
    popToReg
    mov [0xb8000], byte 'f'
    push byte 0
    push byte 15
    jmp isr_common_stub

; 16: Floating Point Exception
isr16:
    popToReg
    mov [0xb8000], byte 'g'
    push byte 0
    push byte 16
    jmp isr_common_stub

; 17: Alignment Check Exception
isr17:
    popToReg
    mov [0xb8000], byte 'h'
    push byte 0
    push byte 17
    jmp isr_common_stub

; 18: Machine Check Exception
isr18:
    popToReg
    mov [0xb8000], byte 'i'
    push byte 0
    push byte 18
    jmp isr_common_stub

; 19: Reserved
isr19:
    popToReg
    push byte 0
    push byte 19
    jmp isr_common_stub

; 20: Reserved
isr20:
    popToReg
    push byte 0
    push byte 20
    jmp isr_common_stub

; 21: Reserved
isr21:
    popToReg
    push byte 0
    push byte 21
    jmp isr_common_stub

; 22: Reserved
isr22:
    popToReg
    push byte 0
    push byte 22
    jmp isr_common_stub

; 23: Reserved
isr23:
    popToReg
    push byte 0
    push byte 23
    jmp isr_common_stub

; 24: Reserved
isr24:
    popToReg
    push byte 0
    push byte 24
    jmp isr_common_stub

; 25: Reserved
isr25:
    popToReg
    push byte 0
    push byte 25
    jmp isr_common_stub

; 26: Reserved
isr26:
    popToReg
    push byte 0
    push byte 26
    jmp isr_common_stub

; 27: Reserved
isr27:
    popToReg
    push byte 0
    push byte 27
    jmp isr_common_stub

; 28: Reserved
isr28:
    popToReg
    push byte 0
    push byte 28
    jmp isr_common_stub

; 29: Reserved
isr29:
    popToReg
    push byte 0
    push byte 29
    jmp isr_common_stub

; 30: Reserved
isr30:
    popToReg
    push byte 0
    push byte 30
    jmp isr_common_stub

; 31: Reserved
isr31:
    popToReg
    push byte 0
    push byte 31
    jmp isr_common_stub

; IRQ handlers
irq0:
    popToReg
	push byte 0
	push byte 32
	jmp irq_common_stub

irq1:
    popToReg
	push byte 1
	push byte 33
	jmp irq_common_stub

irq2:
    popToReg
	push byte 2
	push byte 34
	jmp irq_common_stub

irq3:
    popToReg
	push byte 3
	push byte 35
	jmp irq_common_stub

irq4:
    popToReg
	push byte 4
	push byte 36
	jmp irq_common_stub

irq5:
    popToReg
	push byte 5
	push byte 37
	jmp irq_common_stub

irq6:
    popToReg
	push byte 6
	push byte 38
	jmp irq_common_stub

irq7:
    popToReg
	push byte 7
	push byte 39
	jmp irq_common_stub

irq8:
    popToReg
	push byte 8
	push byte 40
	jmp irq_common_stub

irq9:
    popToReg
	push byte 9
	push byte 41
	jmp irq_common_stub

irq10:
    popToReg
	push byte 10
	push byte 42
	jmp irq_common_stub

irq11:
    popToReg
	push byte 11
	push byte 43
	jmp irq_common_stub

irq12:
    popToReg
	push byte 12
	push byte 44
	jmp irq_common_stub

irq13:
    popToReg
	push byte 13
	push byte 45
	jmp irq_common_stub

irq14:
    popToReg
	push byte 14
	push byte 46
	jmp irq_common_stub

irq15:
    popToReg
	push byte 15
	push byte 47
	jmp irq_common_stub