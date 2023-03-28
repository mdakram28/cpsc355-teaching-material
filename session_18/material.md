# Session 18: Global Variables and Linking

## Date: November 17, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Using .data and .bss section to store global variables
2. Separate Compilation
3. Using makefile for automating compilation
----

## 1. Using .data and .bss section to store global variables


### Global Variables

Global variables are variables which 
- have a fixed place in memory 
- they exist throughout the lifetime of the process
- they can be accessed from any function (globally)

In C, any variable defined outside the functions is a global variable.

Example (c):
```c
#include <stdio.h>

int num = 10;

void printNum1() {
        printf("num1 = %d\n", num);
        num++;
}

void printNum2() {
        printf("num2 = %d\n", num);
        num++;
}

int main() {
        printNum1();
        printNum2();
        printNum1();
        printNum2();

        return 0;
}

/* Output:
num1 = 10
num2 = 11
num1 = 12
num2 = 13
*/
```

### Static Variables

static variables 
- like global variables, have a fixed (static) place in memory
- unlike global variables, they are defined and used inside a function only
- unlike local variables, the value of static variables persists accross multiple calls of the same function.

Example (c):
```c
#include <stdio.h>

void printNum1() {
        static int num = 10;
        printf("num1 = %d\n", num);
        num++;
}

void printNum2() {
        static int num = 10;
        printf("num2 = %d\n", num);
        num++;
}

int main() {
        printNum1();
        printNum2();
        printNum1();
        printNum2();

        return 0;
}

/* Output : 
num1 = 10
num2 = 10
num1 = 11
num2 = 11
*/
```


### .data and .bss sections


```
                  +---- +======================+ 
                  :     |                      |               
                  :     |                      |   Read-Only memory
                  :     |       .text          |   Stores Instructions     
                  :     |                      |   Stores String Literals                   
                  :     |                      |                      
                  :     +----------------------+                      
                  :     |                      |     
                  :     |                      |   Read-Write memory
  Global Memory---+     |        .data         |   Stores pre-initialized global variables                   
                  :     |                      |                      
                  :     |                      |                      
                  :     +----------------------+                      
                  :     |                      |                      
                  :     |                      |   Read-Write memory
                  :     |         .bss         |   Stores zero-initialized global variables
                  :     |                      |                      
                  :     |                      |                      
                  +---  +======================+                                              
                        |                      |                      
                        |                      |                      
                        |         HEAP         |                      
                        |                      |                      
                        |                      |                      
                        +======================+                      
                        |                      |                      
                        |                      |                      
                        |         STACK        |                      
                        |                      |                      
                        |                      |                      
                        +======================+                      
                                                                      
```

1. .text section are meant to store (constant) string literals and instructions
2. .data and .bss sections are meant to store global variables
3. Pre-Initialized Data can be stores in these sections using these pseudo-ops:
	- `.dword` : Double Word (8 bytes)
	- `.word`  : Word (4 bytes)
	- `.hword` : Half Word (2 bytes)
	- `.byte` : byte (1 byte)
4. Uninitialized space can be allocated using `.skip` pseudo-op followed by the number of bytes. Use this inside .bss section.

Example:
```assembly

// Pre-Initialized Single Value
var1:   .word   1234

// Pre-Initialized Multiple Values (Array)
arr1:   .word   1, 2, 3, 4

// Uninitialized Space (E.g. for an int - 4 bytes)
var2:   .skip   4

// Uninitialized Space (E.g. for an int array - 4 * 10 bytes)
arr2:   .skip   4 * 10
```

Example 1 (C):
```c
#include <stdio.h>

int a = 5;
int b;

void printResult() {
        printf("Sum = %d\n", a + b);
}

int main() {
        printResult();
        b = 10;
        printResult();
        return 0;
}

/* Output:
Sum = 5
Sum = 15
*/

```

Example 1 (Assembly) :
```assembly

                .text
str_fmt:	.string	"Sum = %d\n"

                .data
a_m:		.word	5

                .bss
b_m:		.skip	4



                .text
                .balign 4

                
                define(addr_r, x19)
                alloc_printResult = -(16 + 8*3) & -16
printResult:	stp	x29, x30, [sp, alloc_printResult]!
                mov	x29, sp

                // Preserve addr_r, x21, x22
                str	addr_r, [x29, 16 + 8*0]
                str	x21, [x29, 16 + 8]
                str	x22, [x29, 16 + 8*2]
                
                // Load a
                ldr	addr_r, =a_m
                ldr	w21, [addr_r]

                // Load b
                ldr	addr_r, =b_m
                ldr	w22, [addr_r]

                // Print a+b
                ldr	x0, =str_fmt
                add	w1, w21, w22
                bl	printf

                // Restore addr_r, x21, x22
                ldr	addr_r, [x29, 16 + 8*0]
                ldr	x21, [x29, 16 + 8]
                ldr	x22, [x29, 16 + 8*2]

                mov	x0, 0
                ldp	x29, x30, [sp], -alloc_printResult
                ret



                .global main
main:		stp	x29, x30, [sp, -16]!
                mov	x29, sp
        
                bl	printResult

                mov	w21, 10
                ldr	addr_r, =b_m
                str	w21, [addr_r]
        
                bl	printResult

                mov	x0, 0
                ldp	x29, x30, [sp], 16
                ret


```


---

## 2. Separate Compilation

Till now we have written all of our code in one file.
We can instead split our code into multiple files.

This allows us to:
1. Avoid large confusing code files
2. Put commonly used code in a common code file
3. Invoke C from assembly and vice-versa

**Build process : **

![Build Process](https://courses.engr.illinois.edu/cs232/sp2009/lectures/Examples/lecture6/multi_assemble.jpg)

1. Assembling
	- Each code file is compiled into object files individually.
	- For C files, use the command `gcc c_code.c -o c_code.o -c`
	- For assembly files, use the command `gcc asm_code.s -o asm_code.o -c`
2. Linking
	- All the assembled object files are compiled into a single executable while also linking the required library code.
	- Use the command `gcc c_code.o asm_code.o -o exec` for linking `c_code.o` and `asm_code.o`

### Calling assembly code from c

**Example 2**

asm_code.asm:
```assembly
        .balign 4
        .global sum     // Make the function visible outside for linking
sum:    add     w0, w0, w1
        ret
```

c_code.c:
```c
#include<stdio.h>

// Declare the external function without body
extern int sum(int a, int b);

int main() {
        register int a = 10;
        register int b = 50;
        printf("%d + %d = %d\n", a, b, sum(a, b));
        return 0;
}
```

Terminal
```bash
# asm_code.asm -> asm_code.o
m4 asm_code.asm > asm_code.s
gcc -c asm_code.s -o asm_code.o

# c_code.c -> c_code.o
gcc -c c_code.c -o c_code.o

# c_code.o, asm_code.o -> build
gcc c_code.o asm_code.o -o build

# Run executable 
./build
```

### Calling C code from assembly

**Example 3**

c_code.c:
```c
#include <stdio.h>

// These are defined in asm_code.asm
extern int a, b;

int swap(int *var1, int *var2) {
        register int t = *var1;
        *var1 = *var2;
        *var2 = t;
}

void printAB() {
        printf("a = %d, b = %d\n", a, b);
}
```

asm_code.asm:
```assembly
        .data
        .global a
        .global b
a:      .word   23
b:      .word   56

        .text
        .global main
        .balign 4
main:	stp	x29, x30, [sp, -16]!
        mov	x29, sp

        bl      printAB
        
        ldr     x0, =a
        ldr     x1, =b
        bl      swap

        bl      printAB
        
exit:	mov	x0, 0
        ldp	x29, x30, [sp], 16
        ret

```

### Exercise

Create the above executable through separate compilation process


---

## 3. Using makefile for automating compilation

We can use makefile to automate the build process from inidividual source files to the final executable.

1. Define the build process in a files named `Makefile`
2. Use the `make` command to run the build process from `Makefile`

Example 3 : Simple Makefile
```make
build:
	# Create c_code.o
	gcc -c c_code.c -o c_code.o

	# Create asm_code.o
	m4 asm_code.asm > asm_code.s
	gcc -c asm_code.s -o asm_code.o

	# c_code.o + asm_code.o --> build
	gcc c_code.o asm_code.o -o build
```

Example 4 : Generic makefile
```make

%.s: %.asm
	m4 $< > $@

%.o: %.s
	gcc -c $< -o $@

%.o: %.c
	gcc -c $< -o $@

build:  c_code.o asm_code.o
	gcc $^ -o $@
```

### Exercise

Crete a makefile to automate the above build process
