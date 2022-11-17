str_fmt:        .string "Sum = %d\n"


                define(num1_r, w22)
                define(num2_r, w23)
                define(base_r, x20)
                define(index_r, w21)

                .global main
                .balign 4
main:	        stp	x29, x30, [sp, -16]!
                mov	x29, sp
        
                mov     base_r, x1

                mov     index_r, 1
                ldr     x0, [base_r, index_r, SXTW 3]
                bl      atoi
                mov     num1_r, w0

                mov     index_r, 2
                ldr     x0, [base_r, index_r, SXTW 3]
                bl      atoi
                mov     num2_r, w0

                ldr     x0, =str_fmt
                add     w1, num1_r, num2_r
                bl      printf
        
exit:	        mov	x0, 0
                ldp	x29, x30, [sp], 16
                ret