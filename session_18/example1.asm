		.text
str_fmt:	.string	"Sum = %d\n"

		.data
a_m:		.word	5

		.bss
b_m:		.skip	4



		.text
		.balign 4

		
		define(addr_r, x19)
		alloc_printResult = -(16 + 8*3) & -16
printResult:	stp	x29, x30, [sp, alloc_printResult]!
		mov	x29, sp

		// Preserve addr_r, x21, x22
		str	addr_r, [x29, 16 + 8*0]
		str	x21, [x29, 16 + 8]
		str	x22, [x29, 16 + 8*2]
		
		// Load a
		ldr	addr_r, =a_m
		ldr	w21, [addr_r]

		// Load b
		ldr	addr_r, =b_m
		ldr	w22, [addr_r]

		// Print a+b
		ldr	x0, =str_fmt
		add	w1, w21, w22
		bl	printf

		// Restore addr_r, x21, x22
		ldr	addr_r, [x29, 16 + 8*0]
		ldr	x21, [x29, 16 + 8]
		ldr	x22, [x29, 16 + 8*2]

		mov	x0, 0
		ldp	x29, x30, [sp], -alloc_printResult
		ret



		.global main
main:		stp	x29, x30, [sp, -16]!
		mov	x29, sp
	
		bl	printResult

		mov	w21, 10
		ldr	addr_r, =b_m
		str	w21, [addr_r]
	
		bl	printResult

		mov	x0, 0
		ldp	x29, x30, [sp], 16
		ret
