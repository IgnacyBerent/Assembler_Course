; Created: 25.10.2023 08:40:24
; Author : Ignacy Berent

.equ	beginning_add =0x0300
.equ	pattern =0b10101011
.equ	comparer =0b10000000


.cseg
.org 0
		jmp start

.org 0x46
start:	ldi r16, pattern
		ldi r17, comparer
		ldi r19, 8

		ldi xl, byte1(beginning_add)
		ldi xh, byte2(beginning_add)

		st x+, r16

write:	
		mov r18, r16
		andi r18, comparer
		lsl r18
		rol r18
		st x+, r18
		lsl	r16
		dec r19
		brbc 1, write	; if Z = 1, jmp to write

theend: jmp	theend