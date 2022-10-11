# Session 09: Stack Memory

## Date: October 11, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Memory Organisation

2. Stack Memory
3. Local Variables
4. GDB Inspect Memory (x command)



----

## 1. Memory Organisation



![Stack and Heap Layout of Embedded Projects – VisualGDB Documentation](https://visualgdb.com/w/wp-content/uploads/2021/02/stack2.png)



- **Global Variables** declared outside functions/methods are placed directly after each other starting at the beginning of RAM.
- **Local (automatic) variables** declared in functions and methods are stored in the **stack**.
- Variables allocated dynamically (vie the **malloc()** function or the **new()** operator) are stored in the **heap**.





---

## 2. Stack Memory

![img](https://azeria-labs.com/wp-content/uploads/2017/04/stackframe.png)



1. Frame Pointer (FP/x29) points to the starting address of the current stack frame. It is set once at the beginning of the function and does not change through the function. 
2. Link Register (LR/x30) points to the instruction from where a function was called. It is set when using the **bl** instruction. It is used to go back to the calling function after return.
3. Stack Pointer (sp) points to the starting address of the stack which included temporary variables declared during the function. The sp register is decremented as variables are created and it is incremented as local variables go out of scope.

#### Making a function

1. Move the stack pointer back to make room for local variables and calling function's FP & LR. 
   `[sp, -16]!`
2. Store Calling functions FP & LR at the starting of stack (SP).
   `stp	x29, x30, [sp, -16]!`
3. Store the new SP value to current FP.
   `mov	x29, sp`
4. Function body ....
5. Load calling functions FP & LR from the starting of stack (SP) to x29, x30
   `ldp	x29, x30, [sp]`
6. Increment SP to the original position.
   `ldp	x29, x30, [sp]`
7. Return



---

## 3. Local Variables

Local variables are stored in the same manner as calling function's FP and LR are stored.



C Code:

```c
int main() {
    int a=10;
    printf("Value of a = %d \n", a);
    return 0;
}
```

Equivalent Assembly Code:

```assembly
fmt:
	.string	"Value of a = %d \n"


a_s = 16							// Start of a
alloc = -(16+4) & -16				// Bytes to alloc (negative number will be added to decrement SP)

	.global main
	.balign 4
main:
	stp		x29, x30, [sp, alloc]!	// Increment SP by -(16+4) & -16
	mov		x29, sp					// Set current FP to new SP
	
	// int a = 10;
	mov 	w19, 10					// Store 10 temporarily in w19
	str		w19, [sp, a_s]			// Load 10 at (sp + 16)
	
	// printf("%d", a);
	ldr		x0, =fmt				// First arg = address of format string
	ldr		w1, [sp, a_s]			// Second arg = value stored at (sp + 16)
	bl		printf					// Call printf
	
exit:
	mov		x0, 0					// Set return value 0
	ldp		x29, x30, [sp], -alloc	// Restore Values from (sp) to x29 and (sp+8) to x30. Restore SP
	ret
```





---

## 4. GDB Inspect Memory (x command)



The x command in GDB is used to view the content of RAM at a specific address. It has 3 modes.

1. `x [Address]` 
2. `x/[Format] [Address]`
3. `x/[Length][Format] [Address]`



Example:

1. `x/g $sp`
   View the 8 bytes of memory at address stored in stack pointer (Top of stack).
2. x/10g $sp
   View 8 bytes of memory 10 times starting from address stored in SP.
3. x/dw $fp+16
   View 4 bytes (w) of memory in decimal (d) at 16 bytes ahead of Frame Pointer ($fp+16)

