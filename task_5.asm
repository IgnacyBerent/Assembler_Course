; Created: 12/11/2023 10:00:18 PM
; Author : Ignacy Berent
;

.equ	ADR_D =0x0400
.equ	counter =8

.def	curr_el = r16

.cseg
.org 0x00

jmp start

.org 0x46
array: .db 0x12, 0x34, 0x11, 0x33, 0x05, 0x08, 0x11, 0x12, 0xFF
start:
		ldi xl, low(ADR_D)
		ldi xh, high(ADR_D)

    	ldi zl, low(array*2)	;load the beginning byte number of the table
		ldi zh, high(array*2)
		jmp load_array

loop:
		st x+, curr_el
		jmp load_array
load_array:
		lpm curr_el, z+
		cpi curr_el, 0xFF
		breq loopend			;end loading if equal to 0xFF
		mov r17, curr_el
		andi r17, 0b00000011
case_1:
		cpi r17, 0b01
		brne case_2
save_1:
		jmp loop
case_2:
		cpi r17, 0b10
		brne case_3
save_2:
		ldi r19, 0b11110000		;exclusive or can be only done using register
		eor curr_el, r19
		jmp loop
case_3:
		cpi r17, 0b11
		brne case_4
save_3:
		ori curr_el, 0b11110000
		jmp loop
case_4: ;cpi r17, 0b00
save_4:
		andi curr_el, 0b00001111
		jmp loop

loopend: st x, curr_el
theend: jmp theend
		
