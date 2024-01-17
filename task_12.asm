; Created: 1/17/2024 9:20:07 AM
; Author : Ignacy Berent

.equ ADR_C =0x0300
.equ counter =8
.equ stack_bottom = 0x500

.cseg
.org 0
jmp start

.org 0x46
array: .db 0xFE, 0x08, 0x11, 0x01, 0x33, 0x99, 0x20, 0x76, 0xFF
sorted_array: .db 0x01, 0x08, 0x11, 0x20, 0x33, 0x76, 0x99, 0xfe, 0XFF
start:	

	ldi r16, low(stack_bottom)
	out SPL, r16
	ldi r16, high(stack_bottom)
	out SPH, r16

	ldi xl, byte1(ADR_C)
	ldi xh, byte2(ADR_C)
					
	ldi zl, low(array*2)	;load the beginning byte number of the table
	ldi zh, high(array*2)

	ldi r20, 1
	ldi r22, 0

load_array:
	lpm r16, z+		;loads following numbers from array to register 16
	cpi r16, 0xFF		; compares r16 with 0xFF
	st x+, r16
	brne load_array		;Branch if r16<>0xFF

reset:
	cpi r20, 0
	ldi r20, 0
	breq end_sort
	ldi r20, 0
	ldi xl, byte1(ADR_C)	; resets registers x to point to beginning of the array in data location	
	ldi xh, byte2(ADR_C)
search:
	ld r17, x+		;loads to register 17 data from location at x
	ld r18, x
	cpi r18, 0xFF
	breq reset
	call sort
	jmp search
end_sort:
	call test_function
	brbc 0, failure
succes:
	jmp pc
failure:
	jmp pc


.org 0x100
sort:
		cp r17, r18
		brlo end_s
		ldi r20, 1
		st -x, r18
		add xl, r20
		adc xh, r22
		st x, r17
	end_s:
		ret

test_function:
		ldi zl, low(sorted_array*2)
		ldi zh, high(sorted_array*2)
		ldi xl, byte1(ADR_C)
		ldi xh, byte2(ADR_C)
	check_values:
		ld r17, x+
		lpm r18, z+
		cp r17, r18
		brne test_f
		cpi r17, 0xFF
		brne check_values
	test_s:
		sec
		ret
	test_f:
		clc
		ret
