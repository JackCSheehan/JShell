; This file contains all of the implementations of the various commands that JShell offers.

; This command quits JShell
quit:
	mov	ebx, 0		; Return 0 errors
	mov	eax, 1		; OPCODE for sys_exit
	int	0x80		
	ret

; This function creates a file using the given path. Expects the file path in EBX. Preserves EAX.
mkf:
	push	eax	

	; Create file
	mov	ecx, 0o777	; Add create perms
	mov	eax, 8		; OPCODE for creat syscall
	int	0x80
	
	; Close file
	mov	eax, 6		; OPCODE for sys_close
	int	0x80

	pop	eax
	ret

; This function creates a directory using the given path. Expects the file path in EBX.
; Preserves EAX.
mkdr:
	push	eax

	mov	ecx, 0o755	; Mode
	mov	eax, 39		; OPCODE for mkdir syscall
	int	0x80

	pop	eax
	ret


