; Labels that show error messages

; Error that shows when there are not enough args given to a command
showTooFewArgsErr:
	mov	eax, tooFewArgsErr
	call	println
	jmp	repeat
