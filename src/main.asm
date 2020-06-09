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
quitComm:	db	"quit", 0x00 							; Command to quit
mkfComm:	db	"mkf", 0x00							; Command to create a new file
mkdrComm:	db	"mkdr", 0x00							; Command to create a new directory
rmfComm:	db	"rmf", 0x00							; Command to remove file
rmdrComm:	db	"rmdr", 0x00							; Command to remove directory
rnComm:		db	"rn", 0x00							; Command to rename file
printComm:	db	"print", 0x00							; Command to print file contents

; Errors
tooFewArgsErr:	db	"Error: The command you entered was not given enough arguments", 0x00	; Message shown if command isn't provided with enough arguments
noCommErr:	db	"Error: Command not found", 0x00					; Message show if command typed in isn't found
pnfErr:		db	"Error: path not found", 0x00						; Message shown if path given in arg isn't found
mkErr:		db	"Error: cannot create file or directory", 0x00				; Message shown if creating path doesn't work
rdFileErr:	db	"Error: error reading given file", 0x00					; Message shown if given file couldn't be read

SECTION .bss
input:		resb	100		; Reserve 100 bytes for input
fileBuff:	resb	10000		; Reserve 10,000 bytes for file input

SECTION .text
global _start
;TODO: redo comments in getNextArg
_start:
	; Display greetting message
	mov	eax, initMsg
	call	println

inLoop:				; Input Loop
	; Display prompt
	mov	eax, prompt
	call	_print	
	
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
	mov	ecx, rmdrComm	; Move remove directory command into ECX
	call	cmpStr		; Compare target command with command pulled from input string
	cmp	edx, 0		; If EDX is 0, user called rmdr command
	jz	checkRmdr	; Jump to routines for rmdr command
	
	; Check for rename command
	mov	ecx, rnComm	; Move rename command into ECX
	call	cmpStr		; Compare target command with command pulled from input string
	cmp	edx, 0		; If EDX is 0, the user called the rn command
	jz	checkRn		; Jump to routines for rn commands

	; Check for print command
	mov	ecx, printComm	; Move print command into ECX
	call	cmpStr		; Compare target command with command pulled from input string
	cmp	edx, 0		; If EDX is 0, user called print command
	jz	checkPrint

	; If no other command works, show error
	jmp	showNoCommErr

repeat:				; Label to jump to when commands need to repeat input loop	
	mov	edx, 100	; Size of input buffer
	call	clrBuff		; Clear the input buffer
	
	mov	eax, fileBuff	; Move file buffer into EAX to clear it
	mov	edx, 10000	; Size of file buffer
	call	clrBuff		; Clear file buffer

	jmp	inLoop


