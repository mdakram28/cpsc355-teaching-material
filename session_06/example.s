
	.global main
	.balign 4
main:	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	
	// Body of main function
	mov	x19, 0b0101
	mov	x20, 0b0011

	// Bitwise Instructions
bitwise:
	orr	x21, x19, x20
	and	x21, x19, x20
	eor	x21, x19, x20
	mvn	x21, x19

	// Shift Instructions
shift:
	mov x20, 1
	
	lsl	x21, x19, x20
	lsr	x21, x19, x20
	asr	x21, x19, x20

	
	
exit:	mov	x0, 0
	ldp	x29, x30, [sp], 16
	ret
