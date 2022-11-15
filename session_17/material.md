# Session 17: External Pointer Arrays

## Date: November 17, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. External Pointers
2. External Pointer Arrays

----

## 1. External Pointers

**Pointers** are variables which store the address of another variable in memory.

Example:
```c
void increment(int *ptr) {
    *ptr = *ptr + 1;
}

int main() {
    int i = 5;
    int *ptr_i = &i;

    printf("i = %d\n", i);
    increment(ptr_i);
    printf("i = %d\n", i);

    return 0;
}
```

**External Pointers** are pointers which point to a variable not in the stack memory.

Example: a string literal is defined outside the stack. We just pass the address of the string to printf.

Example:
```c
int main() {
        // String literals are not stored in the stack.
        char *msg1 = "Hello ";
        char *msg2 = "World!\n";
        
        // First argument to printf is a pointer to a string (char *)
        printf(msg1);
        printf(msg2);
}
```

Example:
```assembly
msg1:   .string "Hello "
msg2:   .string "World!\n"


        .global main
        .balign 4

        
        ptr_size = 8
        alloc = -(16 + ptr_size + ptr_size) & -16
        msg1_s = 16
        msg2_s = 24

main:	stp	x29, x30, [sp, -16]!
        mov	x29, sp
        
        // char *msg1 = "Hello ";
        ldr     x21, =msg1
        str     x21, [x29, msg1_s]

        // char *msg2 = "World!\n";
        ldr     x21, =msg2
        str     x21, [x29, msg2_s]

        // printf(msg1);
        ldr     x0, [x29, msg1_s]
        bl      printf

        // printf(msg2);
        ldr     x0, [x29, msg2_s]
        bl      printf

exit:	mov	x0, 0
        ldp	x29, x30, [sp], 16
        ret

```

## 2. External Pointer Arrays

External Pointer arrays are several pointers (address to variables in external memory) stored sequentially.

### Defining external pointer arrays
```assembly
arr_label:      .dword  ptr1    ptr2    ptr3    ...
```

Example:
```assembly
str_jan:        .string "January"
str_feb:        .string "February"
str_mar:        .string "March"
str_apr:        .string "April"
str_may:        .string "May"
str_jun:        .string "June"
str_jul:        .string "July"
str_aug:        .string "August"
str_sep:        .string "September"
str_oct:        .string "October"
str_nov:        .string "November"
str_dec:        .string "December"

...

months:         .dword  str_jan, str_feb, str_mar, str_apr, str_may, str_jun, str_jul, str_aug, str_sep, str_oct, str_nov, str_dec

...
```

### Accessing value inside external pointer arrays

Values inside external arrays are accessed using the same method as any other array:

> `address of i-th item = BASE_ADDRESS + INDEX * SIZE`

For accessing values inside external pointer arrays SIZE = 8 bytes

> `address of i-th item = BASE_ADDRESS + INDEX * 8`

Example:

```assembly
define(base_r, x20)
define(index_r, x21)

ldr     base_r, =months
ldr     x21, [base_r, index_r, SXTW 3]
```

Note: We are using SXTW 3 since size of items inside array is 8 (2^3)

## Data sections

1. **.text** section is read only pre-initialized memory. It stores read only strings and assembly code.
2. **.data** section is read-write pre-initialized memory. It stores global variables. Data section should be doubleword aligned.

Example:
```assembly
// Store string literals in .text
                .text
str_fmt:        .string "months[%d] = %s\n"

str_jan:        .string "January"
str_feb:        .string "February"
str_mar:        .string "March"
str_apr:        .string "April"
str_may:        .string "May"
str_jun:        .string "June"
str_jul:        .string "July"
str_aug:        .string "August"
str_sep:        .string "September"
str_oct:        .string "October"
str_nov:        .string "November"
str_dec:        .string "December"

// Store global variables (pointer array) in .data section.
                .data
                .balign 8
months:         .dword  str_jan, str_feb , str_mar, str_apr, str_may, str_jun, str_jul, str_aug, str_sep, str_oct, str_nov, str_dec

// Store Code in .text section
                .text
                .balign 4
                .global main
main:           stp	x29, x30, [sp, -16]!
                mov	x29, sp

                mov     w19, 0
loop_top:       cmp     w19, 12
                b.ge    loop_end

                // printf("months[%d] = %s\n", w19, months[w19])
                ldr     x0, =str_fmt
                mov     w1, w19
                ldr     x20, =months
                ldr     x2, [x20, w19, SXTW 3]
                bl      printf

                add     w19, w19, 1
                b       loop_top
loop_end:       
                
exit:	        mov     x0, 0
                ldp	x29, x30, [sp], 16
                ret
```
