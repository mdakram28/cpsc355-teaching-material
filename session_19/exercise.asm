str_fmt:        .string "Result = %d\n"

                define(num1_r, w22)
                define(num2_r, w23)
                define(operation_r, w24)
                define(base_r, x20)
                define(index_r, w21)

define(load_int_arg, `
                mov     index_r, $1
                ldr     x0, [base_r, index_r, SXTW 3]
                bl      atoi
                mov     $2, w0
')

                .global main
                .balign 4
main:	        stp	x29, x30, [sp, -16]!
                mov	x29, sp
        
                mov     base_r, x1

                // register int num1 = atoi(argv[1]);
                load_int_arg(1, num1_r)

                // register int num2 = atoi(argv[3]);
                load_int_arg(3, num2_r)

                // register char operation = argv[2][0];
                mov     index_r, 2
                ldr     x25, [base_r, index_r, SXTW 3]
                ldrb    operation_r, [x25]

                // if (operation == '+')
                cmp     operation_r, '+'
                b.eq    if_plus
                // else if (operation == '-')
                cmp     operation_r, '-'
                b.eq    if_minus
                b       end_if

if_plus:        // printf("Result = %d\n", num1 + num2);
                mov     x0, =str_fmt
                add     w1, num1_r, num2_r
                bl      printf
                b       end_if

if_minus:       // printf("Result = %d\n", num1 - num2);
                mov     x0, =str_fmt
                sub     w1, num1_r, num2_r
                bl      printf

end_if:


        
exit:	        mov	x0, 0
                ldp	x29, x30, [sp], 16
                ret