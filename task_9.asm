; Created: 12/13/2023 9:19:35 AM
; Author : Ignacy Berent
;

.def m=r22

.cseg
.org 0
jmp start

.org 0x46
buttons: .db 0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0xFF
start:
		ldi r16, 0xFF
		out ddrc, r16
		ldi r16, 0x00
		out ddrb, r16

reset_loop:
		in r16, pinb
		com r16
		ldi zl, low(buttons*2)
		ldi zh, high(buttons*2)
		ldi m, 0
main_loop:
		lpm r18, z+
		cpi r18, 0xFF
		breq error_m
		cp r16, r18
		breq send_mess
		inc m
		jmp main_loop
send_mess:
		com m
		out portc, m
		jmp reset_loop
error_m:
		ldi m, 0x00
		out portc, m
		jmp reset_loop
		
