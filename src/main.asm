; This program takes some command inputs and can create template files for various programming tasks.

%include "io-utils.asm"	; Useful functions for IO

SECTION .data
initMsg:	db	"Welcome to JShell. Copyright (c) 2020 Jack Sheehan.", 0x00	; Greeting message for user
prompt:		db	"> ", 0x00							; Prompt to type commands

; Commands
quitComm:	db	"quit", 0x0A, 0x00						; Command to quit

SECTION .bss
input:		resb	100		; Reserve 100 bytes for input

SECTION .text
global _start

_start:
	; Display greetting message
	mov	eax, initMsg
	call	println

inLoop:				; Input Loop
	; Display prompt
	mov	eax, prompt
	call	print	
	
	; Get input
	mov	eax, input	; Move buffer into EAX and get the input
	call	getln

	; Check input
	mov	ebx, quitComm	; Move quit command into EBX
	call	cmpStr		; Compare input to quit command
	cmp	ecx, 0		; Compare ECX to 0
	jz	quit		; If the user entered the quit command, quit program

	call	clrBuff		; Clear the input buffer

	jmp	inLoop

quit:				; Exit routines
	mov	ebx, 0		; Return 0 errors
	mov	eax, 1		; OPCODE for sys_exit
	int	0x80
