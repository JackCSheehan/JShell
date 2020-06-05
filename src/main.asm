; This program takes some command inputs and can create template files for various programming tasks.

%include "io-utils.asm"	; Useful functions for IO
%include "commands.asm"	; Implementations for commands
%include "val-comms.asm"; Labels for checking commands
%include "errors.asm"	; Labels for printing errors

SECTION .data
; Prompts/messages
initMsg:	db	"Welcome to JShell. Copyright (c) 2020 Jack Sheehan.", 0x00	; Greeting message for user
prompt:		db	"> ", 0x00							; Prompt to type commands

; Commands
quitComm:	db	"quit", 0x00							; Command to quit
mkfComm:	db	"mkf", 0x00							; Command to create a new file
mkdrComm:	db	"mkdr", 0x00							; Command to create a new directory
rmfComm:	db	"rmf", 0x00							; Command to remove file
rmdrComm:	db	"rmdr", 0x00							; Command to remove directory
rnComm:		db	"fn", 0x00							; Command to rename file
printComm:	db	"print", 0x00							; Command to print file contents
lstComm:	db	"lst", 0x00							; Command to list directories
rComm:		db	"r", 0x00							; Command to run a program
timeComm:	db	"time", 0x00							; Command to give current time in UNIX
cdComm:		db	"cd", 0x00							; Command to change current working directory
rbComm:		db	"rb", 0x00							; Command to reboot system
rbConfirm:	db	"confirm", 0x00							; Argument needed to confirm reboot command

; Errors
tooFewArgsErr:	db	"Error: The command you entered was not given enough arguments", 0x00	; Message shown if command isn't provided with enough arguments
noCommErr:	db	"Error: Command not found", 0x00					; Message show if command typed in isn't found

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
	jz	checkMkf	; Jump to routines for mkf command 		

	; Check for make directory command
	mov	ecx, mkdrComm	; Move make directory command into ECX
	call	cmpStr		; Compare target command with command pulled from input string
	cmp	edx, 0		; If EDX is 0, the user called the mkdr command
	jz	checkMkdr	; Jump to routines for mkdr command

	; Check for remove file command
	mov	ecx, rmfComm	; Move remove file comamnd int ECX
	call	cmpStr		; Compare target command with command pulled from input string
	cmp	edx, 0		; If EDX is 0, the user called the rmf command
	jz	checkRmf	; Jump to routines for rmf command

	; Check for remove directory command
	mov	ecx, rmdrComm	; MOve remove directory command into ECX
	call	cmpStr		; Compare target command with command pulled from input string
	cmp	edx, 0		; If EDX is 0, user called rmdr command
	jz	checkRmdr	; Jump to routines for rmdr command

	; If no other command works, show error
	jmp	showNoCommErr

repeat:				; Label to jump to when commands need to repeat input loop	
	call	clrBuff		; Clear the input buffer
	jmp	inLoop


