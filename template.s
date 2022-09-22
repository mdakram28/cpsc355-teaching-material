
	.global main
	.balign 4
main:	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	
	// Body of main function

	
exit:	mov	x0, 0
	ldp	x29, x30, [sp], 16
	ret
