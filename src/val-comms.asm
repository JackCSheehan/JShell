; Labels for validating commands (these are not functions) and calling commands' functions

; Calls quit function
callQuit:
	call	quit

; Check args for mkf command
checkMkf:
	call	getNextArg	; Get the argument for the make file command
	cmp	ebx, 0		; If EBX contains 0, there are too few args
	jz	showTooFewArgsErr
	jnz	callMkf		; Jump to mkf call routines

; Calls mkf command and jumps back to input loop
callMkf:
	call	termAtReturn	; Remove newline from input
	call	mkf		; Call make file function
	jmp	repeat

; Check args for mkdr commands
checkMkdr:
	call	getNextArg	; Get arguemnt for the make file command
	cmp	ebx, 0		; If EBX contains 0, there are too few args
	jz	showTooFewArgsErr
	jnz	callMkdr	; Jump to mkdr call routines

; Call routines for mkdr
callMkdr:
	call	termAtReturn	; Remove newline from input
	call	mkdr
	jmp	repeat
