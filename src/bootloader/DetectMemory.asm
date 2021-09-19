MemoryRegionCount:
	db 0
	GLOBAL MemoryRegionCount
DetectMemory:
	mov ax, 0
	mov es, ax
	mov di, 0x5000
	mov edx, 0x534d4150
	mov ebx, 0
	.repeat:
		mov eax, 0xe820
		mov ecx, 24
		int 0x15

		cmp ebx, 0
		je .finished

		add di, 24
		inc byte [MemoryRegionCount]
		jmp .repeat

	.finished:
	ret