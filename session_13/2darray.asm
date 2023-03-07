fmt_int32:	.string "val = %d\n"

NROWS = 3
NCOLS = 4
arr_size = NROWS * NCOLS * 4
arr_s = 16
alloc = -(16 + arr_size) & -16

define(i_r, w19)
define(j_r, w20)
define(base_r, x21)
define(offset_r, w22)
define(temp_r, w23)

define(increment, `
	add	$1, $1, 1
')

define(print_int32, `
	ldr	x0, =fmt_int32
	mov	w1, $1
	bl	printf
')

	.global main
	.balign 4
main:	stp	x29, x30, [sp, alloc]!
	mov	x29, sp
	
	add	base_r, x29, arr_s	

	mov	i_r, 0
	b	outer_loop_test	
outer_loop:
	
	mov	j_r, 0
	b	inner_loop_test
inner_loop:

	print_int32(i_r)
	print_int32(j_r)

	mov	temp_r, NCOLS
	mul	offset_r, i_r, temp_r
	add	offset_r, offset_r, j_r
	
	str	offset_r, [base_r, offset_r, SXTW 2]
	print_int32(offset_r)

	increment(j_r)
inner_loop_test:
	cmp	j_r, NCOLS
	b.lt	inner_loop
	
	increment(i_r)
outer_loop_test:
	cmp	i_r, NROWS
	b.lt	outer_loop

	
exit:	mov	x0, 0
	ldp	x29, x30, [sp], -alloc
	ret
