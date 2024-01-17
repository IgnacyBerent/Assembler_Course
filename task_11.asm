; Created: 1/10/2024 10:36:42 AM
; Author : Ignacy Berent

.cseg
.org 0x0

.equ stack_bottom = 0x500
.equ measurment = 100

.def counter=r24
.def message=r21

rjmp start
.org 0x46
pressure_high_band: .db 96, 105, 115, 125, 135, 145, 165, 185, 254 , 0xFF
messeges: .db 0b011111111, 0b00111111, 0b10011111, 0b110011111, 0b11101111, 0b11110011, 0b11111001, 0b11111100, 0b11111110, 0xFF
buttons: .db 0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0xFF
values: .db 0, 15, 108, 120, 130, 140, 155, 170, 200, 0xFF

start:
	ldi r20, 0
	ldi r16, low(stack_bottom)
	out SPL, r16
	ldi r16, high(stack_bottom)
	out SPH, r16

	ldi r16, 0xFF
	out ddrc, r16
	ldi r16, 0x00
	out ddrb, r16


main_loop:
	in r16, pinb
	call set_value
	ldi counter, 0
	ldi message, 0
pressure_check:
	call check_pressure
	cpi message, 0x00
	brne send_message
	inc counter
	cpi counter, 9
	breq main_loop
	jmp pressure_check
send_message:
	com message
	out portc, message
	jmp main_loop


.org 0x200

check_pressure:
		ldi zl, low(pressure_high_band*2)
		ldi zh, high(pressure_high_band*2)

		add zl, counter
		adc zh, r20		; r20=0 so it adds only C flag to higer register - case of overflow
		lpm r17, z
		cp r16, r17
		brlo set_message
		ret
	set_message:
		ldi zl, low(messeges)
		ldi zh, high(messeges)
		ldi zl, low(pressure_high_band*2)
		ldi zh, high(pressure_high_band*2)

		add zl, counter
		adc zh, r20		; r20=0 so it adds only C flag to higer register - case of overflow
		lpm message, z
		ret


set_value:
		com r16
		ldi r22, 0
		ldi zl, low(buttons*2)
		ldi zh, high(buttons*2)
	val_loop:
		lpm r23, z+
		cp r16, r23
		breq return_val
		inc r22
		cpi r22, 10
		brne val_loop
		ldi r16, 0
		ret

	return_val:
		ldi zl, low(values*2)
		ldi zh, high(values*2)
		add zl, r22
		adc zh, r20
		lpm r16, z
		ret
