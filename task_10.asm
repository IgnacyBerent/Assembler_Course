; Created: 12/13/2023 9:19:35 AM
; Author : Ignacy Berent
;

.equ hundred = 0b01100100
.equ ten = 0b00001010
.equ ADR = 0x400
.equ stack_bottom = 0x500

.equ number = 1

.equ hundres = 0
.equ tens = 0
.equ unities = 1

.cseg
.org 0
jmp start


.org 0x46
start:
	ldi r16, low(stack_bottom)
	out SPL, r16
	ldi r16, high(stack_bottom)
	out SPH, r16

	ldi xl, low(ADR)
	ldi xh, high(ADR)
	
	call bcd_converter
	call check_function
	brne failure

succes:
	jmp pc
failure:
	jmp pc



.org 0x200

bcd_converter:
	ldi r17, number
	ldi r20, 0
	ldi r21, 0
	ldi r22, 0
check_100:
	cpi r17, 100
	brlo check_10
	sbci r17, 100
	inc r20
	jmp check_100
check_10:
	cpi r17, 10
	brlo check_1
	sbci r17, 10
	inc r21
	jmp check_10
check_1:
	cpi r17, 0
	breq end_bcd
	dec r17
	inc r22
	jmp check_1
end_bcd:
	ret

check_function:
	ldi r16, 0
	cpi r20, hundres
	brne f
	cpi r21, tens
	brne f
	cpi r22, unities
	brne f
	jmp s
f:
	cpi r16, 1
	jmp end_check
s:
	cpi r16,0
end_check:
	ret
	
