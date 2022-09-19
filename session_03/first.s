# AARCH64 assembly tutorial example 01

.global _start
.section .text

_start:
	
write:
	mov x8, #0x40
	mov x0, #1
	ldr x1, =message
	mov x2, #13
	svc 0

exit:
	mov x8, #0x5d
	mov x0, #0x12
	svc 0

.section .data
	message:
	.ascii "Hello World!\n"
