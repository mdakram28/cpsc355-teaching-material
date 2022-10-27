str_fmt:        .string "a = %d, b = %d \n"


define(temp_r, w21)
define(print_ab, `
                ldr     x0, =str_fmt
                ldr     w1, [x29, a_s]
                ldr     w2, [x29, b_s]
                bl      printf
')

                .global main
                .balign 4

swap:           stp     x29, x30, [sp, -16]!
                mov     x29, sp

                ldr     temp_r, [x0]
                ldr     w20, [x1]
                str     w20, [x0]
                str     temp_r, [x1]

                ldp     x29, x30, [sp], 16
                ret


                a_s = 16
                b_s = 20
                main_alloc = -(16 + 4*2) & -16
main:           stp     x29, x30, [sp, main_alloc]!
                mov     x29, sp

                // Body of main function
                mov     w20, 5
                str     w20, [x29, a_s]
                mov     w20, 7
                str     w20, [x29, b_s]


                print_ab()

                add     x0, x29, a_s
                add     x1, x29, b_s
                bl      swap

                print_ab()

                mov     x0, 0
                ldp     x29, x30, [sp], main_alloc
                ret