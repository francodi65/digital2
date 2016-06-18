List p= 16f877a
include "p16f877a.inc"

C_ADCON0	equ	b'11000001' ;Fosc/64 Channel=AN0 ADON=1 Go/Done=0
C_ADCON1	equ	b'11001110'	; ADFM=1 AN0=Analogic
C_INTCON	equ	b'10100000'	; GIE=1 TOIE=1
C_OPTIONREG	equ b'10000111'	; Interrupción=65mS
C_TRISA		equ	b'00000001'	; RA0=Input
C_TRISC		equ b'00000000'	; PORTC=Output
C_TRISD		equ b'00000000'	; PORTD=Output
aux1		equ 0x20
aux2		equ	0x21

		org 0x00
		goto	INICIO
		org	0x04
		goto	INTER

INICIO	call	I_CONF
		bsf		ADCON0,GO_DONE	; GO
		clrf	PORTD
		clrf	PORTC
		clrf	PORTA
bucle	NOP
		bsf		ADCON0,GO_DONE
		goto	bucle


I_CONF	bsf		STATUS,RP0
		bcf		STATUS,RP1
		movlw	C_OPTIONREG
		movwf	OPTION_REG
		movlw	C_INTCON
		movwf	INTCON
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
		return

INTER	btfsc	INTCON,T0IF
		call	tiempo
		retfie

tiempo	bcf		INTCON,T0IF
		banksel	ADRESL
		movf	ADRESL,w
		banksel	PORTD
		movwf	PORTD
		banksel	ADRESH
		movf	ADRESH,w
		banksel	PORTC
		movwf	PORTC
		btfsc	PORTA,1
		goto	apagar
		goto	prender

prender	bsf		PORTA,1
		return
apagar	bcf		PORTA,1
		return


end
		