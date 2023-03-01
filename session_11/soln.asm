
fmt: 	.string "arr[i] = %d\n"

define(ARR_ITEMS, 10)
define(base_r, x22)
define(index_r, w23)

arr_s = 16
i_s = arr_s + 4*ARR_ITEMS
alloc = -(16 + 4*ARR_ITEMS + 4 ) & -16

	.global main
	.balign 4
main:	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	
	// Body of main function
	mov	index_r, 0
	str	index_r, [x29, i_s]
	
	b	loop_test
loop_start:
	// arr[i] = rand() & 0xFF
	bl	rand
	and	w19, w0, 0xFF
	add	base_r, x29, arr_s
	ldr	index_r, [x29, i_s]
	str	w19, [base_r, index_r, SXTW 2]

	// i++
	ldr	index_r, [x29, i_s]
	add	index_r, index_r, 1
	str	index_r, [x29, i_s]

loop_test:
	// i < ARR_ITEMS
	ldr	index_r, [x29, i_s]
	cmp	index_r, ARR_ITEMS
	b.lt	loop_start


	mov	index_r, 0
	str	index_r, [x29, i_s]
	
	b	loop2_test
loop2_start:
	ldr	index_r, [x29, i_s]
	add	base_r, x29, arr_s
	ldr	w1, [base_r, index_r, SXTW 2]
	ldr	x0, =fmt
	bl	printf
	
	ldr	index_r, [x29, i_s]
	add	index_r, index_r, 1
	str	index_r, [x29, i_s]
loop2_test:
	// i < ARR_ITEMS
        ldr     index_r, [x29, i_s]
        cmp     index_r, ARR_ITEMS
        b.lt    loop2_start
	
exit:	mov	x0, 0
	ldp	x29, x30, [sp], 16
	ret
