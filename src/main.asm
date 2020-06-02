; This program takes some command inputs and can create template files for various programming tasks.

%include "io-utils.asm"	; Useful functions for IO

SECTION .data
initMsg:	db	"Welcome to JShell. Copyright (c) 2020 Jack Sheehan.", 0x00	; Greeting message for user
prompt:		db	"> ", 0x00							; Prompt to type commands

; Commands
quitComm:	db	"quit", 0x00							; Command to quit
mkfComm:	db	"mkf", 0x00							; Command to create a new file

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
	
	; Extract command from input
	mov	ebx, eax	; move pointer to input string into EBX since the command is the first word type

	; Check for quit command
	mov	ecx, quitComm	; Move quit command into ECX to compare it with the command
	call	cmpStr		; Compare command with arg pulled from input string
	cmp	edx, 0		; If EDX is 0, then the target command and command read from input string are the same
	jz	quit		; Jump to quit if quit command is found	

	jmp	inLoop

quit:				; Exit routines
	mov	ebx, 0		; Return 0 errors
	mov	eax, 1		; OPCODE for sys_exit
	int	0x80
