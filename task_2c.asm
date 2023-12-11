; Created: 25.10.2023 08:40:24
; Author : Ignacy Berent

.equ	beginning_add =0x02fd
.equ	filler =0x06
.equ	final =0x0c

.cseg
.org 0
		jmp start

.org 0x46
start:		ldi r16, filler

		ldi xl, byte1(beginning_add)
		ldi xh, byte2(beginning_add)


next:
		cp final, filler
		brbs 0,theend

write:	st	x+,r16
		add	filler, 2
		jmp	next

theend: jmp	theend
