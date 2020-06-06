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

; This function removes the given file name. Expects path in EBX. Preserves EAX.
rmf:
	push	eax

	mov	eax, 10		; OPCODE for unlink file
	int	0x80

	pop	eax
	ret

; This function removes the given directory. Expects path in EBX. Preserves EAX.
rmdr:
	push	eax

	mov	eax, 40		; OPCODE for rmdir
	int	0x80

	pop	eax
	ret

; This function renames the given directory. Preserves EAX. During validation, old name is
; put into EBX and new name is put into ECX.
rn:
	push	eax

	mov	eax, 38		; OPCODE for rename
	int	0x80

	pop	eax
	ret




