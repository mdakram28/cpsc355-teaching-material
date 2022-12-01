# Session 22: Floating Point Numbers

## Date: December 01, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Floating Point Registers
2. Flaoting Point Arithmetic

----

## 1. Floating Point Registers


- Floating point numbers are processed only using the floating point registers.
- d8-d15 are callee saved registers
- d0-d7 and d16-d31 may be overwritten by subroutines.
- d0-d7 are used to pass floating point arguments into a function

### Table: Operand name for differently sized floats

| Precision | Size (bits)	| Name |
| --- | --- | --- |
| Half | 16	| Hn |
| Single | 32	| Sn |
| Double | 64	| Dn |

### Figure: Arrangement of floating-point values

![Arrangement](./assets/arrangement.svg)



### Use .single or .double pseudo-ops to allocate and initialize

```assembly
                .data
a_m:            .single         0r5.0                   // 4 bytes
b_m:            .double         0r5.33e-18              // 8 bytes
array_m:        .single         0r2.5,  0r3.5,  0r4.5   // 4*3 bytes
```

---

## 2. Floating Point Arithmetic

### Loading and Storing FP registers

```assembly
ldr     s0, [base_r, offset_r]  // Loads 4 bytes
str     d1, [x29, 16]           // Stores 8 bytes
```

### Basic Floating Point Instructions

```assembly
// Addition
fadd    s1, s2, s3              // s1 = s2 + s3

// Subtraction
fsub    s1, s2, s3              // s1 = s2 - s3

// Mutliplication
fmul    s1, s2, s3              // s1 = s2 * s3

// Multiply negative
fnmul   s1, s2, s3              // s1 = -(s2 * s3)

// Division
fdiv    s1, s2, s3              // s1 = s2 / s3

// Multiply Add
fmadd   s1, s2, s3, s4          // s1 = s4 + (s2 * s3)

// Multiply Subtract
fmsub   s1, s2, s3, s4          // s1 = s4 - (s2 * s3)

// Absolute value
fabs    s1, s2                  // s1 = abs(s2)

// Negation
fneg    s1, s2                  // s1 = -s2

// Move register <- register
fmov    s1, s2                  // s1 = s2

// Move register <- immediate
fmov    s1, 0.25                // s1 = 0.25

// Conversion
fcvt    s1, d2                  // s1 = d2

// Convert Float -> Integer
fcvtns  w1, s2                  // Convert to nearest signed integer
fcvtnu  w1, s2                  // Convert to nearest unsigned integer

// Convert Integer -> Float
scvtf   s1, w2                  // Convert signed integer to float
ucvtf   s1, w2                  // Convert unsigned integer to float

// Compare
fcmp    s1, s2
fcmp    s1, 0.0
```


Example (asm) : Divide 7.5 by 2.0

```assembly
                .data
x_m:            .double 0r7.5
y_m:            .double 0r2.0
res_m:          .double 0r0.0


                .text
                ...
                // x = 7.5;
                ldr     x19, =x_m
                ldr     d0, [x19]
                
                // y = 2.0;
                ldr     x19, =y_m
                ldr     d1, [x19]

                // res = x/y;
                fdiv    d2, d0, d1
                ldr     x19, =res_m
                str     d2, [x19]
                ...
                
```

---

## Exercise

### Calulate the approximate value of PI $(\pi)$ using the formula. Print PI at each step upto 10 decimal places.

$\frac{\pi}{4} = \frac{1}{1} - \frac{1}{3} + \frac{1}{5} - \frac{1}{7} + \frac{1}{9} \dots$

**Solution (c)**
```c
#include <stdio.h>

int main() {
        register double pi = 0;
        register double den = 1;

        while(1) {
                pi += 1/den;
                den += 2;
                pi -= 1/den;
                den += 2;
                printf("PI = %.10f\n", 4*pi);
        }
}
```

**Solution (asm)**
```assembly
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

                // Utility constants
                fmov    one_r, 1.0
                fmov    two_r, 2.0
                fmov    four_r, 4.0

                ldr     x19, =dzero
                ldr     pi_r, [x19]
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

```

