; This program takes some command inputs and can create template files for various programming tasks.

%include "io-utils.asm"	; Useful functions for IO
%include "commands.asm"	; Implementations for commands

SECTION .data
; Prompts/messages
initMsg:	db	"Welcome to JShell. Copyright (c) 2020 Jack Sheehan.", 0x00	; Greeting message for user
prompt:		db	"> ", 0x00							; Prompt to type commands

; Commands
quitComm:	db	"quit", 0x00							; Command to quit
mkfComm:	db	"mkf", 0x00							; Command to create a new file

; Errors
tooFewArgsErr:	db	"The command you entered was not given enough arguments.", 0x00	; Message shown if command isn't provided with enough arguments

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
	
	; Remove leading whitespace from input string
	call	skipLeadSpace

	; Extract command from input
	mov	ebx, eax	; move pointer to input string into EBX since the command is the first word type

	; Check for quit command
	mov	ecx, quitComm	; Move quit command into ECX to compare it with the command
	call	cmpStr		; Compare target command with command pulled from input string
	cmp	edx, 0		; If EDX is 0, then the target command and command read from input string are the same
	jz	callQuit	; Jump to quit if quit command is found	

	; Check for make file command
	mov	ecx, mkfComm	; Move make file command into ECX
	call	cmpStr		; Compare target command with command pulled from input string
	cmp	edx, 0		; If EDX is 0, then the user called the mkf command
	
	call	getNextArg	; Get the argument for the make file command
	cmp	ebx, 0		; If EBX contains 0, there are too few args
	jz	showTooFewArgsErr
	jnz	callMkf

	call	clrBuff		; Clear the input buffer
	jmp	inLoop

; Errors
showTooFewArgsErr:
	mov	eax, tooFewArgsErr
	call	println
	jmp	inLoop

; Commands
callQuit:
	call	quit		; Call the quit function on quit command

callMkf:
	call 	mkf		; Call make file function
	jmp	inLoop
