; AddTwo.asm - adds two 32-bit integers.
; Chapter 3 example
include irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.code
main proc

	mov al,+127
	neg al


	push 5
	push 67
	call stfram

	invoke ExitProcess,0
main endp

stfram proc

	push ebp
	mov ebp, esp

	push 5
	pop eax
	pop ebp
	ret
stfram endp
end main