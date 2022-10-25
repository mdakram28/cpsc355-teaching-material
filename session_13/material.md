# Session 13: Structures and Subroutines

## Date: October 25, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Data Structures



----

## 1. Data Structures



#### Multidimensional Arrays

Most languages use row major order when storing arrays in RAM.

**Row Major Order**: In row-major layout, the first row of the matrix is placed in contiguous memory, then the second, and so on:

![Row major 2D](https://eli.thegreenplace.net/images/2015/row-major-2D.png)

Offset of (r,c) = (r * NCOLS + c) * ITEM_SIZE

Where NCOLS is the number of columns per row in the matrix. It's easy to see this equation fits the linear layout in the diagram shown above.



`int arr[2][3]` (Multidimensional array with 2 rows and 3 columns)

![image-20221024180426609](/home/akram/ucalgary/teaching/cpsc355/session_13/images/img1.png)



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
		stp		x29, x30, [sp, alloc]!
		mov		x29, sp
		
		...
		add		arr_base_r, x29, arr_s					// Caculate arr base address
		mul		offset_r, i_r, cols						// offset = (i * NCOLS)
		add		offset_r, offset_r, j_r					// offset = (i * NCOLS) + j
		
		mov		w24, 13						
		str		w24, [arr_base_r, offset_r, SXTW 2]		// Store at (base + offset*4)
		...
		
		mov		x0, 0
		ldp		x29, x30, [sp], -alloc
		ret
		
		
```





