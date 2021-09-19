gdt_null_desc:
	dd 0
	dd 0
gdt_code_desc:	; code
	dw 0xffff	; Limit
	dw 0x0000	; base (low)
	db 0x00		; base (medium)
	db 10011010b	; Flags
	db 11001111b	; Flags + Upper Limit
	db 0x00		; Base (high)
gdt_data_desc:	; data
	dw 0xffff
	dw 0x0000
	db 0x00
	db 10010010b
	db 11001111b
	db 0x00	

gdt_end:

gdt_descriptor:
	gdt_size:
		dw gdt_end - gdt_null_desc - 1
		dq gdt_null_desc

codeseg equ gdt_code_desc - gdt_null_desc
dataseg equ gdt_data_desc - gdt_null_desc
[bits 32]
EditGDT:
	mov [gdt_code_desc + 6], byte 10101111b

	mov [gdt_data_desc + 6], byte 10101111b
	ret
[bits 16]