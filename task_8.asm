; Created: 06.12.2023 09:05:24
; Author : Ignacy Berent
;

.cseg
.org 0x00

.equ m1 = 0b11110000
.equ m2 = 0b00001111
.equ m12 = 0b10000001
.equ m0 = 0b01111110

rjmp start

.org 0x46
buttons_1: .db 0x01, 0x02, 0x10, 0x20, 0xFF
buttons_2: .db 0x04, 0x08, 0x40, 0x80, 0xFF
start:
		ldi r16, 0xFF
		out ddrc, r16
		ldi r16, 0x00
		out ddrb, r16

main_loop:
		in r16, pinb
		com r16
group_0:	
		cpi r16, 0
		brne group_1
is_0:
		ldi r17, m0
		out portc, r17
		jmp main_loop
group_1:
		ldi zl, low(buttons_1*2)
		ldi zh, high(buttons_1*2)
loop_1:
		lpm r18, z+
		cpi r18, 0xFF
		breq group_2
		cp r18, r16
		breq is_1
		jmp loop_1
is_1:
		ldi r17, m1
		out portc, r17
		jmp main_loop
group_2:
		ldi zl, low(buttons_2*2)
		ldi zh, high(buttons_2*2)
loop_2:
		lpm r18, z+
		cpi r18, 0xFF
		breq group_12
		cp r18, r16
		breq is_2
		jmp loop_2
is_2:
		ldi r17, m2
		out portc, r17
		jmp main_loop
group_12:
		ldi xl, low(buttons_1*2)
		ldi xh, high(buttons_1*2)
loop_12:
		movw z, x
		mov r21, r16
		lpm r18, z+
		st x+, r16
		cpi r18, 0xFF
		breq main_loop
		cp r18, r21
		brlo smaller
bigger:
		sub r18, r21
		jmp check
smaller:
		sub r21, r18
		mov r18, r21
check:			
		ldi yl, low(buttons_2*2)
		ldi yh, high(buttons_2*2)
loop_arr:
		movw z, y
		lpm r19, z+
		st y+, r16
		cpi r19, 0xFF
		breq loop_12
		cp r19, r18
		breq is_12
		jmp loop_arr
is_12: 
		ldi r17, m12
		out portc, r17
		jmp main_loop

		;movw x, z!!!
