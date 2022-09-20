# AARCH64 assembly tutorial example 01

	.extern printf
	.extern fflush
	.extern sdout
message:
	.string "Hello World!\n"
fmt:
	.string "x19 = %d\t"



	.balign 4
	.global main
main:
	stp 	x29, x30, [sp, -16]!	// Save FP and LR to stack
	mov 	x29, sp
	
	mov 	x19, #1;
loop_top:
	cmp 	x19, #10
	b.gt	loop_end
	
	ldr	x0, =fmt
	mov 	x1, x19
	bl 	printf
	
	ldr	x0, stdout
	bl	fflush
	

	bl 	write
	bl 	write
	add	x19, x19, #1
	b 	loop_top
loop_end:
	b 	exit
	

write:
	stp x29, x30, [sp, -16]!
	mov x29, sp

	mov x8, #0x40
	mov x0, #1
	ldr x1, =message
	mov x2, #13
	svc 0
	
	ldp x29, x30, [sp], 16
	ret

exit:	
	// return 0
	mov x0, 0
	ldp x29, x30, [sp], 16
	ret


