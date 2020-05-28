; This program takes some command inputs and can create template files for various programming tasks.

%include "io-utils.asm"	; Useful functions for IO

section .data
tstIns:	db	"test", 0x00		; Test instruction
msg1:	db	"Strings match!", 0x00	; Message if strings match

section .text
global _start

_start:
	pop	ecx		; Get number of arguments
	pop	eax		; Discard first argument
	pop	eax		; Get second argument 
	
	mov	ebx, tstIns	; Put test instruction into EBX
	call	cmpStr		; Compare the strings in EAX and EBX
	
	cmp	ecx, 0		; Compare result of cmpStr function with 0
	jz	equalStrs	; If the strings are equal, print that they match
	jnz	quit

equalStrs:
	mov	eax, msg1	; Move message into EAX for printing
	call	println

;loop:
;	cmp	ecx, 0		; Loop while ecx > 0
;	jz	exit
;	pop	eax		; Pop next argument into EAX
;	call 	println		; Print the string
;	dec	ecx		; Decrment argument counter
;	jmp	loop

quit:				; Exit routiness
	mov	ebx, 0		; Return 0 errors
	mov	eax, 1		; OPCODE for sys_exit
	int	0x80
