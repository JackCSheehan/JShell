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

; Check for args for rmf command
checkRmf:
	call	getNextArg;	; Get argument
	cmp	ebx, 0		; If EBX contains 0, there are too few args
	jz	showTooFewArgsErr
	jnz	callRmf		; Jump to rmf call routines

; Call routines for rmf command
callRmf:
	call	termAtReturn	; Remove newline from input
	call	rmf
	jmp	repeat

; Check for args for rmf command
checkRmdr:
	call	getNextArg	; Get argument
	cmp	ebx, 0		; IF EBX contains 0, there are too few args
	jz	showTooFewArgsErr
	jnz	callRmdr	; Jump to rmdr call routines
	
; Call routines for rmdr
callRmdr:
	call	termAtReturn	; Remove newline from input
	call	rmdr
	jmp	repeat

; Check for args for rn command
checkRn:
	; Grab first arg
	call	getNextArg	; Get argument

	cmp	ebx, 0		; If EBX contains 0, there are too few args
	jz	showTooFewArgsErr
	call	termAtSpace	; Terminate arg at space
	
	push	ebx		; If first arg found, push onto stack

	; Grab second arg	
	call	getNextArg

	cmp	ebx, 0		; If EBX contains 0, there are too few args
	jz	showTooFewArgsErr
	call	termAtReturn	; Remove newline from arg
	
	mov	ecx, ebx	; EBX now contains new name for file; move into ECX for syscall
	pop	ebx		; Pop first arg into EBX; now EBX contains the old name; needed for syscall
	
	jmp	callRn

; Call routines for rn
callRn:
	call	rn		
	jmp	repeat
