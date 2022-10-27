
str_hello:	.string	"Hello "
str_world:	.string	"World \n"

		.global main
		.balign 4

printHello:	stp	x29, x30, [sp, -16]!
		mov	x29, sp

		ldr	x0, =str_hello
		bl	printf
		
		ldp	x29, x30, [sp], 16
		ret

printWorld:	stp	x29, x30, [sp, -16]!
		mov	x29, sp

		ldr	x0, =str_world
		bl	printf
		
		ldp	x29, x30, [sp], 16
		ret

// printMessage Function
printMessage:	stp	x29, x30, [sp, -16]!
		mov	x29, sp

		bl	printHello
		bl	printWorld
		
		ldp	x29, x30, [sp], 16
		ret
		
// Main function
main:		stp	x29, x30, [sp, -16]!
		mov	x29, sp
	
		bl	printMessage
	
		mov	x0, 0
		ldp	x29, x30, [sp], 16
		ret