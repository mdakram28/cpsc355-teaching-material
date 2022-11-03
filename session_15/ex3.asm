str_fmt:.string "Color( r=%d, g=%d, b=%d )\n"

	.global main
	.balign 4

        // Define constants for struct col
        color_size = 12
        color_r_s = 0
        color_g_s = 4
        color_b_s = 8


	define(col_base_r, x22)
        main_alloc = -(16 + color_size) & -16
        col_s = 16
main:	stp	x29, x30, [sp, main_alloc]!
	mov	x29, sp

	add	col_base_r, x29, col_s
	mov	w19, 100
	str	w19, [col_base_r, color_r_s]
	mov	w19, 200
	str	w19, [col_base_r, color_g_s]
	mov	w19, 300
	str	w19, [col_base_r, color_b_s]

        add     x0, x29, col_s
        mov     w1, 5
        bl      lighten

        add     col_base_r, x29, col_s
        ldr     x0, =str_fmt
        ldr     w1, [col_base_r, color_r_s]
        ldr     w2, [col_base_r, color_g_s]
        ldr     w3, [col_base_r, color_b_s]
        bl      printf

        mov	x0, 0
	ldp	x29, x30, [sp], -main_alloc
	ret










        lighten_alloc = -(16) & -16
lighten:stp	x29, x30, [sp, lighten_alloc]!
	mov	x29, sp

        // Modify origcol r,g,b
        ldr     w19, [x0, color_r_s]
        mul     w19, w19, w1
        str     w19, [x0, color_r_s]
        ldr     w19, [x0, color_g_s]
        mul     w19, w19, w1
        str     w19, [x0, color_g_s]
        ldr     w19, [x0, color_b_s]
        mul     w19, w19, w1
        str     w19, [x0, color_b_s]

        ldp	x29, x30, [sp], -lighten_alloc
	ret





















