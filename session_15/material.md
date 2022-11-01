# Session 15: Subroutine arguments and returned values

## Date: November 01, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Passing Struct Value
2. Passing Struct Pointer

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
        return 0;
}
```

Equivalent Assembly Code:
```asssembly


	.global main
	.balign 4
main:	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	
	// Body of main function

	
exit:	mov	x0, 0
	ldp	x29, x30, [sp], 16
	ret


```