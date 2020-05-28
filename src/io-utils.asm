; Helpful functions for IO

; This function prints the message given in EAX; message must be null-terminated
; Original values of the four gen purpose registers are reserved
println:
	; Preserve register values
	push	edx
	push	ecx
	push	ebx
	push	eax
		
	mov	ebx, eax	; Move address of string in EAX -> EBX

lenLoop:			; Loop to find length of string
	cmp	byte [ebx], 0	; Compare byte at EBX with 0
	jz	strEnd	
	inc	ebx		; Increment EBX to move to next character
	jmp	lenLoop		; Loop back 

strEnd:				; Where to jump when null terminator has been found
	sub	ebx, eax	; Calculate number of characters; result is stored in EBX
	
	mov	edx, ebx	; Store length of string in EDX
	mov	ecx, eax	; Move address of string to ECX
	mov	ebx, 1		; Store 1 in EBX; indicates STDOUT
	mov	eax, 4		; Store 4 in EAX; incates sys_write
	int	0x80		; Call interrupt handler to print the string
	
	; Print newline
	mov	eax, 0x0A	; Put newline into EAX
	push	eax		; Push EAX to stack

	mov	edx, 1		; Length of newline
	mov	ecx, esp	; Put stack pointer address into ECX since ECX needs a pointer to a string
	mov	ebx, 1
	mov	eax, 4
	int	0x80

	pop	eax		; Remove access data from stack

	; Restore values of registers
	pop	eax
	pop	ebx
	pop	ecx
	pop	edx
	ret

; Compares two strings -- one in EAX and one in EBX. If they are equal, 0 is put into ECX.
; If they aren't, 1 is put into ECX. The original values of EAX, EBX, and EDX are preserved
; Strings MUST be null-terminated.
cmpStr:
	; Preserve EAX, EBX, and EDX
	push	edx
	push	ebx
	push	eax

cmpLoop:			; Loop to compare each character of each string
	mov	dh, byte[eax]
	cmp	byte[ebx], dh	; Compare the equivalent bytes of each string
	jnz	notEqual	; If there's a mismatch, jump to notEqual
	
	cmp	byte[eax], 0	; Compare EAX to 0
	jz	equal		; If execution gets this far then we know the characters are equivalent. If one of the characters
				; is 0, then we have reached the end of both strings without any mismatch. We know, then, that
				; these strings are equivalent.
	inc	eax		; Increment both EAX and EBX addresses
	inc	ebx		
	
	jmp 	cmpLoop

equal:				; Jumps here if strings are equal
	mov	ecx, 0		; Put 0 into ECX to indicate that the strings are the same
	jmp 	exit

notEqual:			; Jumps here if strings are not equal
	mov	ecx, 1		; Put 1 into ECX to indicate that the strings are not the same
	jmp 	exit

exit:				; Function exit routines
	; Replace values in EAX, EBX, and EDX registers
	pop 	eax
	pop	ebx
	pop	edx
	ret











