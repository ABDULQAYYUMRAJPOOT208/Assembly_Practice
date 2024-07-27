
.include "m328pdef.inc"
.include "delay_Macro.inc"
.include "UART.inc"
.include "1602_LCD_Macros.inc"
.def C=R20
.DEF CH=R21
.DEF FLAME_ADMUX_SAVE=R27
.def HELPER = R24

.cseg 

.org 0x00



	

/*.def C=R20
.DEF CH=R21
; ADC Configuration for fLAME Sensor
LDI C, 0b11000111 ; [ADEN ADSC ADATE ADIF ADIE ADIE ADPS2 ADPS1 ADPS0]
STS ADCSRA, C

LDI C, 0b01100010; [REFS1 REFS0 ADLAR – MUX3 MUX2 MUX1 MUX0]
STS ADMUX, C ; Select ADC1 (PC1 pin) as the analog input for the FLAME  sensor
SBI PORTC, PC2 ; Enable Pull-up Resistor for FLAME sensor
; Start Analog to Digital Conversion for FLAME sensor
    LDS C, ADCSRA
    ORI C, (1 << ADSC)
    STS ADCSRA, C

    ; Wait for fLAME sensor conversion to complete
    flame_waIt:
    LDS c, ADCSRA
    sbrc c, ADSC
    rjmp flame_waIt
    ; Read flame sensor value
    LDS c, ADCL
    LDS ch, ADCH
	cpi CH,128
	BRSH FLAME_NOT_EXSIST
	CBI PORTD,PD4
;    rjmp PASS3
	FLAME_NOT_EXSIST:
	SBI PORTD,PD4
rjmp loop
	CBI DDRB, PB2		; PB3 set as INPUT pin
	SBI PORTB, PB2	
	ldi r21,9	; Enable internal pull-up resistor
	LCD_send_a_command 0x01
	LCD_backlight_ON
		LDI             ZL, LOW (2 * name)
		LDI             ZH, HIGH (2 * name)
		LDI             R20, name_len

	LCD_send_a_string name
	pushButtonWait:
		SBIS PINB, PB2
		rjmp end
	jmp pushButtonWait

	end:
		LCD_backlight_ON
	countDown:
		LCD_send_a_command 0x01
		LDI             ZL, LOW (2 * name)
		LDI             ZH, HIGH (2 * name)
		LDI             R20, name_len

		LCD_send_a_string name

		LCD_send_a_register r21
		delay 500
		cpi r21,0
		breq loop
		dec r21
	rjmp countDown
		
	loop:

	jmp loop
	*/
name :	.db	" COUNTDOWN : ",0
len1 : .equ	name_len = (2 * (len1 - name))-1*