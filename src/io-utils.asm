; Helpful functions for IO

; This function prints the message given in EAX; message must be null-terminated.
; Original values of the four gen purposes registers are reserved. The message
; is printed with a newline.
println:
	; Print message
	call	print

	; Preserve register values
	push	edx
	push	ecx
	push	ebx
	push	eax

	; Print newline
	mov	eax, 0x0A	; Put newline into EAX
	push	eax		; Put EAX on to stack

	mov	edx, 1		; Length of newline
	mov	ecx, esp	; Puts address of newline into ECX
	mov	ebx, 1		; STDOUT
	mov	eax, 4		; sys_write
	int	0x80

	pop	eax		; Remove newline from stack

	; Restore register values
	pop	eax
	pop	ebx
	pop	ecx
	pop	edx
	ret

; This function prints the message given in EAX; message must be null-terminated.
; Original values of the four gen purpose registers are reserved. The message is
; printed without a newline.
print:
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

; This function gets a line of input from STDIN. EAX needs a pointer to the input buffer. This function will 
; read a maximum of 100 characters. EBX, ECX, and EDX values are preserved. EAX will contain the input after
; the function is called.
getln:
	; Preserve EBX, ECX, and EDX values
	push	edx
	push	ecx
	push	ebx

	mov	edx, 100	; A max of 100 charaters are read
	mov	ecx, eax	; Move buffer into ECX	
	mov	ebx, 0		; Read from STDIN
	mov	eax, 3		; Call sys_read
	int	0x80

	mov	eax, ecx	; Put input into EAX

	; Restore register values
	pop	ebx
	pop	ecx
	pop	edx
	ret

; This function takes an input buffer in EAX and clears it. EBX and ECX are used but preserved.
; NOTE: Assumes buffer size is 100.
clrBuff:
	; Preserve values of registers
	push	ecx
	push	ebx

	mov	ebx, eax	; Use EBX as a pointer for incrementing through buffer
	mov	ecx, 0		; ECX is a counter that goes 0 -> 100

clrBuffLoop:			; Loop for clearing buffer pointed to by EAX
	cmp	byte[ebx], 0
	jz	clrBuffExit	; Stop when a zero is encountered

	cmp	ecx, 100
	jz	clrBuffExit	; Stop wen ECX has reached 100

	mov	byte[ebx], 0	; Replace current byte in buffer with 0
	inc	ebx		; Increment address to move to next byte in buffer

	jmp 	clrBuffLoop

clrBuffExit:
	; Restore registers
	pop	ebx
	pop	ecx
	ret

; This function takes the console input buffer in EAX and reads out the first argument. For example, in the the command
; 'mkf main.asm', 'mkf' is the command and 'main.asm' is the first argument. This first argument will be put into a
; buffer expected in EBX. ECX and EDX are preserved. Arguments are expected to be separated with one or more space (ASCII 32).
getFirstArg:
	; Preserve register values
	push	edx
	push	ecx
; TODO: add checks to null-terminator

findSpace:			; Loop to find the boundary between the command the argument
	cmp	byte[eax], 32	; Compare the current character in EAX with ASCII 32 (space)
	jz	findArgstart	; If a space was encountered, jump to a loop that looks for the start of the arg;
				; needed so that the user can put more than one space between the command and the argument
				; and it will still work.
	inc	eax		; If the current character is not a space, increment EAX until a space is found
	jmp	findSpace

findFirstArg:			; Loop to find the starting charater of the first arg
	cmp	byte[eax], 32	; Compare current byte in EAX string with space
	jnz	extractArg	; If the current byte is not a space, then EAX currently points to the first char of argument 1

	inc	eax		; Increment EAX to next byte
	jmp 	findFirstArg

extractArg:			; Loop to extract argument 1 from the string pointed to by EAX
	; TODO: put byte[EAX] into ECX and put THAT char into byte[ebx]
	;mov	byte[ebx], byte[eax]	; Move current byte from EAX into EBX (needed to copy string over)
	;NOTE: above line won't assemble if uncommented -- meant only as a placeholder until this function is finished

