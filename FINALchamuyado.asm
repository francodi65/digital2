List p= 16f877a
include "p16f877a.inc"

C_ADCON0	equ	b'11000001' ;Fosc/64 Channel=AN0 ADON=1 Go/Done=0
C_ADCON1	equ	b'11001110'	; ADFM=1 AN0=Analogic
C_INTCON	equ	b'11100000'	; PEIE=1 GIE=1 TOIE=1
C_OPTIONREG	equ b'10000111'	; Interrupción=65mS
C_PIE1		equ	b'01000000'	; ADIE=1
C_PIR1		equ b'00000000'	; ADIF=0
C_TRISA		equ	b'00000001'	; RA0=Input
C_TRISC		equ b'00000000'	; PORTC=Output
C_TRISD		equ b'00000000'	; PORTD=Output

		org 0x00
		goto	INICIO
		org	0x04
		goto	INTER

INICIO	call	I_CONF
		bsf		ADCON0,1	; GO
		clrf	PORTD
		clrf	PORTC
		clrf	PORTA
bucle	NOP
		goto	bucle


I_CONF	bsf		STATUS,RP0
		bcf		STATUS,RP1
		movlw	C_OPTIONREG
		movwf	OPTION_REG
		movlw	C_INTCON
		movwf	INTCON
		movlw	C_PIE1
		movwf	PIE1
		movlw	C_ADCON1
		movwf	ADCON1
		movlw	C_TRISA
		movwf	TRISA
		movlw	C_TRISD
		movwf	TRISD
		movlw	C_TRISC
		movwf	TRISC
		bcf		STATUS,RP0
		movlw	C_ADCON0
		movwf	ADCON0
		movlw	C_PIR1
		movwf	PIR1
		return

INTER	btfsc	INTCON,T0IF
		call	tiempo
		btfsc	INTCON,PEIE
		call	adc
		retfie

tiempo	bcf		INTCON,T0IF
		banksel	ADRESL
		movf	ADRESL,w
		banksel	PORTD
		movwf	PORTD
		movf	ADRESH,w
		movwf	PORTC
		btfsc	PORTA,1
		goto	apagar
		goto	prender

prender	bsf		PORTA,1
		return
apagar	bcf		PORTA,1
		return

adc		bcf		PIR1,ADIF
		bsf		ADCON0,0
		bsf		ADCON0,1
		return
end
		
		