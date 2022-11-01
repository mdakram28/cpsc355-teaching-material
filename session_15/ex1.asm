
	.global main
	.balign 4

        // Define constants for struct col
        color_size = 12
        color_r_s = 0
        color_g_s = 4
        color_b_s = 8


        
        main_alloc = -(16 + color_size) & -16
        col_s = 16
main:	stp	x29, x30, [sp, main_alloc]!
	mov	x29, sp
	
        // Store address of col in x8
	add     x8, x29, col_s
        bl      black
	
        mov	x0, 0
	ldp	x29, x30, [sp], -main_alloc
	ret


define(newcol_base_r, x21)

        black_alloc = -(16 + color_size) & -16
        newcol_s = 16
black:	stp	x29, x30, [sp, black_alloc]!
	mov	x29, sp
	
        // Calculate local struct base
        add     newcol_base_r, x29, newcol_s
        
        str     xzr, [newcol_base_r, color_r_s]
        str     xzr, [newcol_base_r, color_g_s]
        str     xzr, [newcol_base_r, color_b_s]

        // Copy local struct to struct at [x8]
        ldr     x19, [newcol_base_r, color_r_s]
        str     x19, [x8, color_r_s]
        ldr     x19, [newcol_base_r, color_g_s]
        str     x19, [x8, color_g_s]
        ldr     x19, [newcol_base_r, color_b_s]
        str     x19, [x8, color_b_s]
	
        ldp	x29, x30, [sp], -black_alloc
	ret