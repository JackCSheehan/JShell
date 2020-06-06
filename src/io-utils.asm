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
	jmp	lenLoop	; Loop back 

strEnd:			; Where to jump when null terminator has been found
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
	
; This function prints the message given in EAX; message must be terminated by a space.
; Original values of the four gen purpose registers are reserved. The message is
; printed without a newline.
prints:
	; Preserve register values
	push	edx
	push	ecx
	push	ebx
	push	eax
		
	mov	ebx, eax	; Move address of string in EAX -> EBX

slenLoop:			; Loop to find length of string
	cmp	byte [ebx], 32	; Compare byte at EBX with 0
	jz	sstrEnd	
	inc	ebx		; Increment EBX to move to next character
	jmp	slenLoop	; Loop back 

sstrEnd:			; Where to jump when null terminator has been found
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

; Compares two strings -- one in EBX and one in ECX. Stops comparing strings once the string in EBX hits a newline or space
; at the same time that the string in ECX hits an ASCII 0. This function is designed for testing commands against parsed args. 
; EDX will equal 0 if the strings match and 1 if they don't. EBX will contain the argument extracted from the input string
; and ECX will contain the command string that is being checked against.
cmpStr:
	; Preserve EBX and ECX
	push	ecx
	push	ebx

cmpLoop:			; Loop to compare each character of each string
	cmp	byte[ebx], 10	; Compare current byte pointed to by EBX to newline
	jz	checkNullTerm	; If current byte pointed to by EBX is newline, check string in ECX for ASCII 0

	cmp	byte[ebx], 32	; Compare current char to space
	jz	checkNullTerm	; If current byte is space, check for ASCII 0 in ECX string

	mov	dh, [ebx]	; Move byte pointed to by EBX into DH
	cmp	byte[ecx], dh	; Compare equivalent bytes between strings
	jnz	notEqual	; If these bytes are mismatched, then these strings are not equal

	inc	ebx		; Increment EBX and ECX to point to the next character in each string
	inc	ecx

	jmp	cmpLoop

checkNullTerm:			; Section that checks for \0 in current byte pointed to by ECX
	cmp	byte[ecx], 0	; Compares current byte in ECX to \0
	jz	equal		; If ECX points to \0 at the same time that EBX points to \n or a space, then the strings are equal
	jnz	notEqual	; If ECX doesn't point to \0, these strings are not equal

equal:				; Jump here if strings are equal
	mov	edx, 0		; Put 0 in EDX to indicate that the strings are equal
	jmp	quitCmpStr

notEqual:			; Jumps here if strings are not equal
	mov	edx, 1		; Put 1 into ECX to indicate that the strings are not the same
	jmp 	quitCmpStr

quitCmpStr:			; Function exit routines
	; Replace values in EBX and ECX
	pop 	ebx
	pop	ecx
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
	mov	ecx, 0		; ECX is a counter that goes 0 -> 99

clrBuffLoop:			; Loop for clearing buffer pointed to by EAX
	cmp	byte[ebx], 0
	jz	clrBuffExit	; Stop when a zero is encountered

	cmp	ecx, 99
	jz	clrBuffExit	; Stop wen ECX has reached 100

	mov	byte[ebx], 0	; Replace current byte in buffer with 0
	
	inc	ebx		; Increment address to move to next byte in buffer
	inc	ecx		; Increment counter

	jmp 	clrBuffLoop

clrBuffExit:
	; Restore registers
	pop	ebx
	pop	ecx
	ret

; This function is used to find the first character of the input string that is not a space. This is to allow extra
; spaces before a user's input to be ignored. This function onnly changes the value of EAX (if needed). It will
; increment EAX until a non-space character is found.
skipLeadSpace:
	cmp	byte[eax], 32	; Compare byte pointed to by EAX to space
	jz	incPtr		; Jump to label where EAX will be incremented if EAX points to a space
	jnz	quitSkipLeadSpace

incPtr:				; Label that handles incrementing condition
	inc	eax		; Increment EAX to point to next byte in string
	jmp	skipLeadSpace	; Jump back to top of function

quitSkipLeadSpace:		; Function exit routines once first input chracter has been found
	ret

; This function finds the next arg in the input string. Takes a pointer to the first character of an argument in EBX.
; Stores a pointer to the first character of the next argument in EBX. For example, in the
; input string 'mkf main.asm -f', '-f' and 'main.asm' are both arguments. If this function was called with a pointer
; to the first character of 'main.asm' in EBX, the function would put a pointer to the first character of '-f' in
; EBX. If EBX currently points to the first character of the last argument, EBX will contain 0. This function uses
; Both spaces and \0s as delimeters. This is because certain commands take multiple arguments, and those arguments
; need to be null-terminated before being passed as args to syscalls.
getNextArg:	
;TODO: update comments
findDelimSpace:			; Loop that searches the input string until the space between args is found. If a newline is found, function move 0 into EBX
	cmp	byte[ebx], 10	; Compare current byte pointed to by EAX to the newline chracter
	jz	foundLastArg	; If the current byte is a newline, then this is the last argument and there are no more to look for

	cmp	byte[ebx], 32	; Compare current byte pointed to by EAX to a space
	jz	findFirstChar	; If the current character is a space, then the delimiting space between args has been found; jump to label that will find first char of next arg

	cmp	byte[ebx], 0	; Compare current byte to 0
	jz	findFirstChar	; If current char is 0, then delimiting char between args has been found; jump to label that will find first char of next arg

	inc	ebx		; Increment EAX to point to next byte in input string
	jmp	findDelimSpace

findFirstChar:			; Section that handles finding the first char of the next arg	
	cmp	byte[ebx], 10	; If EAX points to a newline before any characters have been found, then there are no more args
	jz	foundLastArg

	cmp	byte[ebx], 32	; Compare current byte pointed to by EAX to a space
	jnz	checkForNull	; If current char is not a space, then check EBX for a 0

	inc	ebx		; Increment EAX to point to next byte in string
	jmp	findFirstChar

checkForNull:			; Section of code that checks non-space chars to see if they are \0s (acts as an && operator)
	cmp	byte[ebx], 0	; Compare current byte to 0
	jnz	foundNextArg	; If this byte isn't a space AND it's not a 0, then EBX points to the first char of the next arg

	inc	ebx		; If control has to return to loop, increment EBX
	jz	findFirstChar	; If the current char is a 0, then it is the delimiting 0 between two args. Must go back to loop to find an actual character

foundNextArg:			; Section that handles what to do when next arg has been found
	jmp	quitGetNextArg	; Jump to quit routines

foundLastArg:			; Section that handles if there are no more args to look for
	mov	ebx, 0		; Move 0 into EDX to indicate that there are no more args

quitGetNextArg:			; Exit routines for this function
	; Replace EAX value
	ret

; This function expects a pointer to a newline-terminated argument in EBX and replaces the newline with an ASCII 0. Used for
; creating files and directories to prevent the newline ending up in the name. Preserves EBX.
termAtReturn:
	push	ebx		; Preserve EBX

findReturn:			; Loop that finds newline
	cmp	byte[ebx], 10	; Compare byte pointed to by EBX to newline
	jz 	termR		; Terminate string if current byte is newline

	inc	ebx		; Increment EBX to point to next byte
	jmp	findReturn

termR:				; Section of code that actually terminates the string at the newline
	mov	byte[ebx], 0	; Move \0 into current byte
	
	pop	ebx		; Restore EBX value
	ret

; This function expects a pointer to a space-terminated argument in EBX and reeplaces the space with an ASCII 0. Use for
; renaming files where two arguments are needed for the syscall.
termAtSpace:
	push	ebx		; Preserve EBX

findSpace:			; Loop that finds space
	cmp	byte[ebx], 32	; Compare current byte in EBX to a space
	jz	termS		; Terminate if current byte is newline

	inc	ebx		; Increment EBX to point to next byte
	jmp	findSpace

termS:				; Section of code that terminates string at space
	mov	byte[ebx], 0	; Terminate at space

	pop	ebx		; Restore EBX value to point to the beginning of the arg
	ret








