# Session 06: Bitwise and Shift Instructions

## Date: February 2, 2022

## Email: mohdakram.ansari@ucalgary.ca

## Agenda

1. Bitwise Instructions
2. Shift Instructions

---

## 1.  Bitwise Instructions

In computer programming, a bitwise operation operates on a binary number at the level of its individual bits. (A bit-by-bit operation)

- Binary OR, | shorthand
	```
	   0101 (decimal 5)
	OR 0011 (decimal 3)
	 = 0111 (decimal 7)
	```
	
- Binary AND, & shorthand
  ```
      0110 (decimal 6)
  AND 1011 (decimal 11)
    = 0010 (decimal 2)
  ```

- Binary NOT, ~ shorthand
  ```
  NOT 0111  (decimal 7)
    = 1000  (decimal 8)
  ```

- Binary XOR, ^ shorthand
  ```
      0101 (decimal 5)
  XOR 0011 (decimal 3)
    = 0110 (decimal 6)
  ```

### ARMv8 bitwise commands

- Or: ORR
- And: AND
- Xor: EOR
- Not: MVN (move and not)


**Example**

```assembly
// Load Registers
mov		x19, 0b0101
mov		x20, 0b0011

// Perform bitwise Operations
orr		x0, x19, x20
and		x0, x19, x20
eor		x0, x19, x20
mvn		x0, x19
```






---
## 2.  Shift Instructions

- Left Shift
	```
	    0101 << 1
	  = 1010
	```
- Right Shift
	```
	    0101 >> 1
	  = 0010
	```



**Arithmetic Shift** Preserves the sign bit (Leftmost bit). i.e. it does not move the leftmost bit

### ARMv8 Shift instruction

- Logical Shift Left: LSL
- Logical Shift Right: LSR
- Arithmetic Shift Right: ASR

**Example**

```assembly
// Load Registers
mov		x19, 0b0101
mov		x20, 0b0011

// Perform bitwise Operations
lsl		x0, x19, 1
lsr		x0, x19, 1
asr		x0, x19, 1
```

