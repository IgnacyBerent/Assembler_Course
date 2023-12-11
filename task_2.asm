; Created: 11.10.2023 10:13:27
; Author : Ignacy Berent
;
	.equ beginning_add = 0x0305
	.equ end_add = 0x0307
	.equ filler = 0x3e

.cseg
.org 0
	    jmp	start

.org 0x46
start:  ldi r16, filler

        ldi xl, byte1(end_add)
	    ldi xh, byte2(end_add)
	    ldi yl, byte1(beginning_add +1)
		ldi yh, byte2(beginning_add +1)

next:   st  x+, r16

		cp xl, yl
	    brbc 1, next
		cp xh, yh
		brbc 1, next

theend: jmp theend
at happens when we swao end_add and beggin_add
