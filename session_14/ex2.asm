

str_res:        .string "Result: %d \n"

define(result_r, w21)

                .global main
                .balign 4


// Power Function
power:          stp     x29, x30, [sp, -16]!
                mov     x29, sp

                mov     result_r, 1
                b       loop_test
loop_start:
                mul     result_r, result_r, w0

                sub     w1, w1, 1
loop_test:      cmp     w1, 0
                b.gt    loop_start

                mov     w0, result_r

                ldp     x29, x30, [sp], 16
                ret



// Main Function
                r_s = 16
                main_alloc = -(16 + 4) & -16
main:           stp     x29, x30, [sp, main_alloc]!
                mov     x29, sp

                mov     w0, 5
                mov     w1, 3
                bl      power
                str     w0, [x29, r_s]

                ldr     x0, =str_res
                ldr     w1, [x29, r_s]
                bl      printf


exit:           mov     x0, 0
                ldp     x29, x30, [sp], -main_alloc
                ret