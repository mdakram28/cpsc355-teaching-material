# Session 15: Subroutine arguments and returned values

## Date: March 14, 2023

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Passing/Returning Struct Value
2. Passing/Returning Struct Pointer

----

## 1. Passing/Returning Struct Value

Structs are mostly bigger than 8 bytes. Hence, they cannot be passed/returned in registers (x0-x7).

**Returning struct value**

- The calling code allocates, the memory for the returned struct in it's stack and stores the address of the allocated struct in **x8**. 
- The invoked function then modifies the struct at the memory pointed by x8.

Example:
C Code
```c
struct color {
        int r;
        int g;
        int b;
}

struct color black() {
        struct color newcol;
        newcol.r = 0;
        newcol.g = 0;
        newcol.b = 0;
        return newcol;
}

int main() {
        struct color col;
        col = black();
        printf("Color( r=%d, g=%d, b=%d )\n", col.r, col.g, col.b)
        return 0;
}
```

Equivalent Assembly Code:
```asssembly
str_fmt:.string "Color( r=%d, g=%d, b=%d )\n"

	.global main
	.balign 4

        // Define constants for struct col
        color_size = 12
        color_r_s = 0
        color_g_s = 4
        color_b_s = 8


        define(col_base_r, x21)
        main_alloc = -(16 + color_size) & -16
        col_s = 16
main:	stp	x29, x30, [sp, main_alloc]!
	mov	x29, sp
	
        // Store address of col in x8
	add     x8, x29, col_s
        bl      black

        add     col_base_r, x29, col_s
        ldr     x0, =str_fmt
        ldr     w1, [col_base_r, color_r_s]
        ldr     w2, [col_base_r, color_g_s]
        ldr     w3, [col_base_r, color_b_s]
        bl      printf
	
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
        
        str     wzr, [newcol_base_r, color_r_s]
        str     wzr, [newcol_base_r, color_g_s]
        str     wzr, [newcol_base_r, color_b_s]

        // Copy local struct to struct at [x8]
        ldr     w19, [newcol_base_r, color_r_s]
        str     w19, [x8, color_r_s]
        ldr     w19, [newcol_base_r, color_g_s]
        str     w19, [x8, color_g_s]
        ldr     w19, [newcol_base_r, color_b_s]
        str     w19, [x8, color_b_s]
	
        ldp	x29, x30, [sp], -black_alloc
	ret
```
**Passing struct value**

Passing struct by value is done using the same method as returning struct by value.
The address of the local variable to pass is stored in x0-x7. The subroutine then copies the struct to its stack from x0-x7.

**Example 2**: ex2.c, ex2.asm - Program to lighten color passed as value and return new color

---

## 2. Passing/Returning Struct Pointer

Passing by value is not very efficient, since the whole struct is copied before passing or returning. But it also makes sure that the original struct is not modified.

But sometimes, we might need to modify the original struct passed to the subroutine or we might neeed to just read the struct. In such cases, we do not need to allocate the struct in the subroutine's stack frame. Instead, we can pass the base address of the struct (pointer) and directly modify the memory at the address passed.

Example 3: ex3.c, ex3.asm - Modify example 2 lighten function to modify the original color passed instead of creating a new color.
