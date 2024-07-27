.include "m328pdef.inc"
.include "delay_Macro.inc"
.include "UART.inc"
.include "1602_LCD_Macros.inc"
.equ LCD_DATA_PORT = PORTD
.equ LCD_CTRL_PORT = PORTB
.equ LCD_RS = 0
.equ LCD_EN = 1
.equ BUTTON_PIN = PIND2

 cbi ddrd,pd0 ; set pd0 as input RX
 sbi ddrd,pd1 ; set pd1 as output TX

 Serial_begin

ldi r16, 0xFF      ; Set PORTD as output for LCD data
out DDRD, r16

ldi r16, 0x03      ; Set PORTB0 and PORTB1 as outputs for LCD control
out DDRB, r16

ldi r16, (1<<LCD_RS) | (1<<LCD_EN)
out LCD_CTRL_PORT, r16

ldi r16, 0xFF      ; Initialize LCD
rcall lcd_int

ldi r16, (1<<BUTTON_PIN)   ; Set BUTTON_PIN as input with pull-up resistor
out PORTC, r16

main:
    ldi r16, (1<<BUTTON_PIN)   ; Read button state
    in r17, PINC
    andi r17, (1<<BUTTON_PIN)
    cpi r17, 0
    breq countdown

    rjmp main

countdown:
    ldi r16, 9
    rcall lcd_clr

count_loop:
    rcall lcd_set_cursor
    rcall lcd_print_number

    dec r16
    brne count_loop

    rjmp main
	delay 2500
	delay 2500
	LCD_send_a_character 0x52
	delay 2500
	delay 2500
	Serial_readStr
	LCD_send_a_command 0x01  ; clear the LCD
	LCD_send_a_string ZH:ZL
	

lcd_int:
    ;_delay_ms(50)
    ldi r16, 0x38
    rcall lcd_command

    ldi r16, 0x0C
    rcall lcd_command

    ldi r16, 0x06
    rcall lcd_command

    ret

lcd_command:
    cbi LCD_CTRL_PORT, LCD_RS
    sbi LCD_CTRL_PORT, LCD_EN
    out LCD_DATA_PORT, r16
    cbi LCD_CTRL_PORT, LCD_EN
    ret

lcd_clr:
    ldi r16, 0x01
    rcall lcd_command
    ;_delay_ms(2)
    ret

lcd_set_cursor:
    ldi r16, 0x80   ; Set cursor to the beginning of the first line
    rcall lcd_command
    ret

lcd_print_number:
    ;addi r16, '0'
    rcall lcd_data
    ret

lcd_data:
    sbi LCD_CTRL_PORT, LCD_RS
    sbi LCD_CTRL_PORT, LCD_EN
    out LCD_DATA_PORT, r16
    cbi LCD_CTRL_PORT, LCD_EN
    ret
