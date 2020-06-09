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

; Error shown when path cannot be found.
showPnfErr:
	pop	eax		; Pop EAX value pushed by mk commands	
	push	eax

	mov	eax, pnfErr
	call	println

	pop	eax

	jmp	repeat

; Error shown if file or dir cannot be made.
showMkErr:
	pop	eax		; Pop EAX value pushed by mk commands
	push	eax

	mov	eax, mkErr
	call	println

	pop	eax

	jmp	repeat

; Error show if file could not be read.
showRdFileErr:
	pop	eax		; Pop EAX value pushed by print command
	push	eax

	mov	eax, rdFileErr
	call	println

	pop	eax

	jmp	repeat
