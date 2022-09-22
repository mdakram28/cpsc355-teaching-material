	.extern printf	

fmt:	.string "%d\n"

	.global main
	.balign 4
main:	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	
	
	mov	x19, 0
	b	test
top:	// Loop Body

	ldr	x0, =fmt
	mov	x1, x19
	bl	printf	

	// Increment
	add	x19, x19, 1
test:	// Test condition
	cmp	x19, 10
	b.lt	top
	
	// Loop Ended	




	
exit:	mov	x0, 0
	ldp	x29, x30, [sp], 16
	ret
