# Session 11: Stack Memory - Arrays

## Date: October 18, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Allocating arrays in the stack

1. Loading & Storign Array Items




----

## 1. Allocating arrays in the stack



### What are Arrays?

Arrays are ordered collections of data elements of the same type that are contiguously stored in memory.

![Each integer in the array requires four bytes.](https://diveintosystems.org/book/C8-IA32/_images/arrayFig.png)



### Accessing Array Items

To get the address of item in an array from index i. Add the **offset** of the item to the **base address**.

Base Address : Address of the first byte of the array.

Offset: (index * item_size) The distance in bytes of the item from the base address.

**Address of arr[i] = Base + (i * item_size)**

Example:

1. Address of Element 0 = Base + (0 * 4) = Base + 0
2. Address of Element 1 = Base + (1 * 4) = Base + 4
3. Address of Element 2 = Base + (2 * 4) = Base + 8
4. Address of Element 3 = Base + (3 * 4) = Base + 12
5. Address of Element 4 = Base + (4 * 4) = Base + 16



### Storing Array in the stack

Arrays are stored like local variables on the stack with a large size.

**Size of the array = Number of items * item_size**



Example C:

```c
#define ARR_ITEMS 10

int main() {
    int var;
	int arr[ARR_ITEMS];
    
	var = 3456;
	arr[0] = 1234;
}
```



Example Assembly:

```assembly
arr_items = 10
var_size = 4
alloc = -(16 + var_size + arr_items*4) & -16

		.global main
		.balign 4
main:	stp		x29, x30, [sp, alloc]!
		mov		x29, sp
		
        mov		w19, 3456
        str		w19, [x29, 16]
        
		mov		w19, 1234
		str		w19, [x29, 20]
		
exit:	mov		x0, 0
		ldp		x29, x30, [sp], -alloc
		ret
```





## 2. Loading & Storing Array Items



Array items can be loaded and stored in the RAM just like any other variable using the **ldr** and **str** instructions.

For getting the address of item we can use the offset = (index * item_size):

```assembly
define(base_r, x19)
define(index_r, x20)
define(offset_r, x21)

# Calculate Base Address
add		base_r, x29, arr_s

# Caclculate offset using mul
mul		offset_r, index_r, 4
# Or Calculate offset using LSL (efficient)
lsl		offset_r, index_r, 2

# Store w21 to arr[i]
str		w21, [base_r, offset_r]
```

*Note: Shift left by 2 is equivalent to multiplying by 4.*



Offset can also be calculated using the "**Register with scaled register offset**" addressing mode

`ldr val_r, [base_r, index_r, LSL 2]   ; val_r = *(base_r + (index_r << 2))`

For preserving sign in the index_r when shifting left, use the **SXTW** instead of **LSL**

`ldr val_r, [base_r, index_r, SXTW 2]   ; val_r = *(base_r + (index_r << 2))`



Optimised Array Addressing:

```assembly
define(base_r, x19)
define(index_r, x20)

# Calculate Base Address
add		base_r, x29, arr_s

# Storing w21 -> arr[index]
str		w21, [base_r, index_r, SXTW 2]
# Loading w21 <- arr[index]
ldr		w21, [base_r, index_r, SXTW 2]
```



### Exercise

Write a program in arm assembly to find the maximum item of an array. The array is initialised using the rand function.

C Code:

```c
#include <stdio.h>
#include <stdlib.h>

#define ARR_ITEMS 10

int main() {
    int arr[ARR_ITEMS];
    int i;
    int max;
    
    for (i=0; i<ARR_ITEMS; i++) {
        arr[i] = rand() & 0xFF;
    }
    
    max = arr[0];
    for (i=0; i<ARR_ITEMS; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }
    
    printf("Maximum item is %d\n", max);
    
    return 0;
}
```



