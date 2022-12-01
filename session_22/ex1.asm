str_fmt:        .string "PI = %.10f\n"
dzero:          .double 0r0.0

		.global main
		.balign 4

		define(pi_r, d10)
		define(den_r, d11)
		define(one_r, d12)
		define(two_r, d13)
		define(four_r, d14)
main:           stp     x29, x30, [sp, -16]!
		mov     x29, sp

		fmov    one_r, 1.0
		fmov    two_r, 2.0
		fmov    four_r, 4.0

		ldr     pi_r, dzero
		fmov    den_r, 1.0

loop:           // pi += 1/den; den += 2;
		fdiv    d21, one_r, den_r
		fadd    pi_r, pi_r, d21
		fadd    den_r, den_r, two_r

		// pi -= 1/den; den += 2;
		fdiv    d21, one_r, den_r
		fsub    pi_r, pi_r, d21
		fadd    den_r, den_r, two_r

		// printf("PI = %.10f\n", 4*pi);
		ldr     x0, =str_fmt
		fmul    d0, pi_r, four_r
		bl      printf

		// Repeat forever
		b       loop

exit:           mov     x0, 0
		ldp     x29, x30, [sp], 16
		ret

