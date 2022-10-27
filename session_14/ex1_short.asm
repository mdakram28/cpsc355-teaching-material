str_hello:	.string	"Hello "
str_world:	.string	"World \n"

define(CREATE_FUNC, `
$1:		stp	x29, x30, [sp, -16]!
		mov	x29, sp
		$2		
		ldp	x29, x30, [sp], 16
		ret
')

		.global main
		.balign 4

CREATE_FUNC(printHello, `
		ldr	x0, =str_hello
		bl	printf
')

CREATE_FUNC(printWorld, `
		ldr	x0, =str_world
		bl	printf
')

CREATE_FUNC(printMessage, `
		bl	printHello
		bl	printWorld
')

CREATE_FUNC(main, `
		bl	printMessage
		mov	x0, 0
')