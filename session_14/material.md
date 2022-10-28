# Session 13: Closed Subroutines

## Date: October 26, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Closed Subroutines

----

## 1. Closed Subroutines

Closed subroutines do not rely on macros. They are placed outside the main or any other subroutine.

Building a closed subroutine :

```assembly
label:		stp	x29, x30, [sp, alloc]!
                mov	x29, sp

                // Body of Subroutine
                ....

                ldp	x29, x30, [sp], -alloc
                ret
```

- **label**: Name of the subroutine. Used with bl instruction
- **alloc**: Assembler equate denoting the size in bytes to allocate in the stack frame.

### Invoking Closed Subroutine

Closed subrotuines are are invoked using the branch and linking `bl` instruction (Subroutine Linkage). 

```assembly
                bl	label
```


1. The bl instruction stores the return address (PC+4) in link register (x30) and changes the sp to the label. 
2. The CPU then starts execution from the updated program counter (PC)
3. The ret instruction loads address from LR (x30) back into PC.

Example:
```c

void printHello() {
        printf("Hello ");
}

void printWorld() {
        printf("World \n");
}

void printMessage() {
        printHello();
        printWorld();
}

int main() {
        printMessage();
        return 0;
}

```

**Equivalent Assembly Code**
```assembly

str_hello:	.string	"Hello "
str_world:	.string	"World \n"

                .global main
                .balign 4

printHello:	stp	x29, x30, [sp, -16]!
                mov	x29, sp

                ldr	x0, =str_hello
                bl	printf
                
                ldp	x29, x30, [sp], 16
                ret

printWorld:	stp	x29, x30, [sp, -16]!
                mov	x29, sp

                ldr	x0, =str_world
                bl	printf
                
                ldp	x29, x30, [sp], 16
                ret

// printMessage Function
printMessage:	stp	x29, x30, [sp, -16]!
                mov	x29, sp

                bl	printHello
                bl	printWorld
                
                ldp	x29, x30, [sp], 16
                ret
                
// Main function
main:		stp	x29, x30, [sp, -16]!
                mov	x29, sp
        
                bl	printMessage
        
                mov	x0, 0
                ldp	x29, x30, [sp], 16
                ret
```

When the first printf is invoked the stack would look like this:
```


               |                |                           
               |                |                           
 x29 --------> |================|    
           +---| Prev FP        | <---- printf
           |   | -------------- |                           
           |   | Prev LR        |                           
           |   | -------------- |                           
           |   | local vars     |                        
           +-->|================|                           
         +-----| Prev FP        | <---- printHello  
         |     | -------------- |                           
         |     | Prev LR        |                           
         +---->|================|                           
           +---| Prev FP        | <---- printMessage        
           |   | -------------- |                           
           |   | Prev LR        |                          
           +-->|================|                           
         +-----| Prev FP        | <---- main                
         |     | -------------- |                           
         |     | Prev LR        |                           
         |     |================|                             
         +---->|                |                             
               |       .        |                             
               |       .        |                             
               |       .        |                             
               |                |                             
               
```

### Arguments and Return Values to closed subroutines

- **Arguments are passed using x0-x7 registers**
- **Single Return value is stored in x0 register**

To pass in parameters to a subroutine, we generally use w0-w7 or x0-x7. It is possible to return multiple values as well by storing the return values in w0-w7 or x0-x7. The reason is simple: there is only one set of registers, and they are considered global. If a subroutine stores values in w0-w7, they will still be available to the calling code once the subroutine returns. Note that this is not true for all registers, and that w0-w7 are specificly used for passing parameters to/from subroutines.

Example: Program to calculate integer exponent using a function

C Code:
```c
#include <stdio.h>

int power(int base, int exp) {
        register int result = 1;
        while(exp > 0) {
                result = result * base;
                exp--;
        }
        return result;
}

int main() {
        int r;

        r = power(5, 3);

        printf("Result : %d \n", r);
        return 0;
}
```

Equivalent Assembly Code in `ex2.asm`

### Pointer Arguments

As we know pointers are just memory address so they will be stored in 64 bit registers (x0-x7) instead of 32 bit registers. 

It implies that the variable value is in ram at the address stored in the argument.

Example: Program to swap 2 numbers using pointers passed to functions

C Code:
```c

void swap(int *x, int *y) {
        register int temp;
        temp = *x;
        *x = *y;
        *y = temp;
}

int main() {
        int a = 5, b = 7;
        printf("a = %d, b = %d", a, b);
        swap(&a, &b);
        printf("a = %d, b = %d", a, b);
        return 0;
}
```

Equivalent Assembly Code in `ex3.asm`

---

## Exercise

### Change Example 2 to take base and exponent from the terminal, using the scanf function

```c
#include <stdio.h>

int power(int base, int exp) {
        register int result = 1;
        while(exp > 0) {
                result = result * base;
                exp--;
        }
        return result;
}

int main() {
        int b, e, r;
        // Use scanf to get users input
        scanf("%d", &b);
        scanf("%d", &e);
        r = power(b, e);

        printf("Result : %d \n", r);
        return 0;
}
```