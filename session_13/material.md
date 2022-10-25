# Session 13: Structures and Subroutines

## Date: October 25, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Multidimensional Arrays
2. Data Structures
3. Subroutines
4. Open Subroutines

----

## 1. Multidimensional Arrays

Most languages use row major order when storing arrays in RAM.

**Row Major Order**: In row-major layout, the first row of the matrix is placed in contiguous memory, then the second, and so on:

![Row major 2D](https://eli.thegreenplace.net/images/2015/row-major-2D.png)

Offset of (r,c) = (r * NCOLS + c) * ITEM_SIZE

Where NCOLS is the number of columns per row in the matrix. It's easy to see this equation fits the linear layout in the diagram shown above.



`int arr[2][3]` (Multidimensional array with 2 rows and 3 columns)

![image-20221024180426609](./images/img1.png)



Example:

```c
int main() {
	int arr[2][3];
	register int i,j;
	...
	arr[i][j] = 13;
	...
}
```

Assembly:

```assembly
define(arr_base_r, x19)
define(offset_r, w20)
define(i_r, w21)
define(j_r, w22)

...
	rows = 2
	cols = 3
	arr_size = rows * cols * 4
	alloc = -(16 + arr_size) & -16
	arr_s = 16

main:
	stp	x29, x30, [sp, alloc]!
	mov	x29, sp
	
	...
	add	arr_base_r, x29, arr_s				// Caculate arr base address
	mul	offset_r, i_r, cols				// offset = (i * NCOLS)
	add	offset_r, offset_r, j_r				// offset = (i * NCOLS) + j
	
	mov	w24, 13						
	str	w24, [arr_base_r, offset_r, SXTW 2]
		
		
```

---

## 2. Data Structures

Contains fields of different types. Each field is accessed using an offset from the base address of the struct.

Example:

```c
struct rec {
	int a;
	char b;
	short c;
}

             Base of rec
             |
             V
---+---+---+---+---+---+---+---+---+---+---+---+---
   |   |   | a | a | a | a | b | c | c |   |   |   
---+---+---+---+---+---+---+---+---+---+---+---+---
             ^               ^   ^                     
             |               |   |                   
Offsets:     a:0             b:4 c:5           

```

```assembly

// Offsets
rec_a = 0
rec_b = 4
rec_c = 5

// Access fields of struct pointed by x19
ldr	w20, [x19, rec_a]
ldsb	w21, [x19, rec_b]
ldrsq	w22, [x19, rec_c]
```

---

## 3. Subroutines

Subroutines allow us to repeat a set of instructions using different arguments

**Open Subroutine** : Code is inserted (duplicated) wherever the subroutine is invoked.


**Closed Subroutines** : Machine code is not copied, the cpu jumps to the single place where the code is in the RAM and returns back to the calling place once the subroutine is over.


## 4. Open Subroutines

Open subroutines are usually implemented using a macros (M4). 

M4 macros are created using define and arguments are accessed within the macro using $1, $2 ...

> Note: Use `' instead of '' or "" to create multiline macros

Example:
```assembly
// Macro to increment a register by 1

define(increment, `
	add	$1, $1, 1
')


	...
	increment(x19)		// Calling macro
	
	// Expands to
	add	x19, x19, 1
	...
```

Example:
```assembly
// Macro to print array of integers

fmt_int32:	.string	"%d \n"

define(print_int32, `
	ldr	x0, =fmt_int32
	mov	w1, $1
	bl	printf
')

	...
	print_int32(w19)

	// Expands to
	ldr	x0, =fmt_int32
	mov	w1, w19
	bl	printf
	
	...

```
