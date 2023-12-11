; Created: 22.11.2023 08:40:24
; Author : Ignacy Berent

.equ	ADR_C =0x0300
.equ	ADR_D =0x0404
.equ	counter =8


.cseg
.org 0
		jmp start

.org 0x46
array: .db 0x12, 0x34, 0x11, 0x33, 0x05, 0x08, 0x11, 0x12, 0xFF
start:	
		ldi xl, byte1(ADR_C)
		ldi xh, byte2(ADR_C)

		ldi yl, byte1(ADR_D)
		ldi yh, byte2(ADR_D)
					
		ldi zl, low(array*2)	;load the beginning byte number of the table
		ldi zh, high(array*2)

load_array:
		lpm r16, z+		;loads following numbers from array to register 16
		cpi r16, 0xFF		; compares r16 with 0xFF
		st x+, r16
		brne load_array		;Branch if r16<>0xFF

reset:
		ldi xl, byte1(ADR_C)	; resets registers x to point to beginning of the array in data location
		ldi xh, byte2(ADR_C)
search:
		ld r17, x+		;loads to register 17 data from location at x
		cpi r17, 0xFF
		brne load		;Branch if r17<>0xFF

		ldi r17, 0xFF		;loads 0xFF pattern at the end of the array in program memory
		st y+, r17
		jmp theend

load:
		sbrc r17, 0		;checks last byte if is equal 0 - its even number so next instruction is skipped
		st y+, r17		;saves number if odd
		jmp search

theend: jmp	theend
