; Labels that show error messages

; Error that shows when there are not enough args given to a command. Preserves EAX.
showTooFewArgsErr:
	push	eax	

	mov	eax, tooFewArgsErr
	call	println
	
	pop	eax

	jmp	repeat

; Error that shows when there are not enough args given to a command. Preserves EAX.
showNoCommErr:
	push	eax

	mov	eax, noCommErr
	call	println
	
	pop	eax

	jmp	repeat
