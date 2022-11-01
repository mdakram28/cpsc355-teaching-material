str_fmt:.string "Color( r=%d, g=%d, b=%d )\n"

	.global main
	.balign 4

        // Define constants for struct col
        color_size = 12
        color_r_s = 0
        color_g_s = 4
        color_b_s = 8

// macro to copy struct from [$1] to [$2]
define(copy_color, `
        ldr     w19, [$1, color_r_s]
        str     w19, [$2, color_r_s]
        ldr     w19, [$1, color_g_s]
        str     w19, [$2, color_g_s]
        ldr     w19, [$1, color_b_s]
        str     w19, [$2, color_b_s]
')

	
	define(col_base_r, x22)
        define(lightcol_base_r, x21)
        main_alloc = -(16 + color_size*2) & -16
        col_s = 16
        lightcol_s = 16 + color_size
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
        add     x8, x29, lightcol_s
        bl      lighten

        add     lightcol_base_r, x29, lightcol_s
        ldr     x0, =str_fmt
        ldr     w1, [lightcol_base_r, color_r_s]
        ldr     w2, [lightcol_base_r, color_g_s]
        ldr     w3, [lightcol_base_r, color_b_s]
        bl      printf
	
        mov	x0, 0
	ldp	x29, x30, [sp], -main_alloc
	ret





        define(origcol_base_r, x21)
        define(newcol_base_r, x22)
        lighten_alloc = -(16 + color_size + color_size) & -16
        origcol_s = 16
        newcol_s = 16 + color_size
lighten:	stp	x29, x30, [sp, lighten_alloc]!
	mov	x29, sp
	
        // [x0] ->  origcol
        add     origcol_base_r, x29, origcol_s
        copy_color(x0, origcol_base_r)

        // Compute newcol r,g,b
        add     newcol_base_r, x29, newcol_s
        ldr     w19, [origcol_base_r, color_r_s]
        mul     w19, w19, w1
        str     w19, [newcol_base_r, color_r_s]
        ldr     w19, [origcol_base_r, color_g_s]
        mul     w19, w19, w1
        str     w19, [newcol_base_r, color_g_s]
        ldr     w19, [origcol_base_r, color_b_s]
        mul     w19, w19, w1
        str     w19, [newcol_base_r, color_b_s]
        
        // newcol -> [x8]
        copy_color(newcol_base_r, x8)
	
        ldp	x29, x30, [sp], -lighten_alloc
	ret 
