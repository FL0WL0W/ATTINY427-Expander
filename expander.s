#include <avr/io.h>
 
#define rxstate r25
#define rxcmd0 r2
#define rxcmd1 r3
#define rxcmd2 r4
#define rxcmd3 r5
#define rxcmd4 r6
#define index r8

.data
rxbuf: .byte 80

.text
; USART0_RCX
.global __vector_17
__vector_17:
    ; switch rxstate
    MOV r16, rxstate
    LSL r16
    LDI ZL, lo8(RXStateSwitch)
    LDI ZH, hi8(RXStateSwitch)
    ADD ZL, r16
    ADC ZH, r0
    ; store char in r16 before switch
    LDS r16, USART0_RXDATAL
    IJMP

RXStateSwitch:
    .int RXCMD
    .int RXFWD3
    .int RXSTORECMD2
    .int RXSTORECMD1
    .int RXFWD4
    .int RXSTORECMD3
    .int RXSTORECMD2
    .int RXSTORECMD1
    .int RXFWD5
    .int RXSTORECMD4
    .int RXSTORECMD3
    .int RXSTORECMD2
    .int RXSTORECMD1
    .int RXEXE
    .int RXSTORECMD3
    .int RXSTORECMD2
    .int RXSTORECMD1

RXSTORECMD1:
    ; store rxcmd1
    MOV rxcmd1, r16
    DEC rxstate
    RETI

RXSTORECMD2:
    ; store rxcmd2
    MOV rxcmd2, r16
    DEC rxstate
    RETI

RXSTORECMD3:
    ; store rxcmd3
    MOV rxcmd3, r16
    DEC rxstate
    RETI

RXSTORECMD4:
    ; store rxcmd4
    MOV rxcmd4, r16
    DEC rxstate
    RETI

RXFWD3:
    ;reset state to 0
    LDI rxstate, 0
    ; TODO Forward
    RETI

RXFWD4:
    ;reset state to 0
    LDI rxstate, 0
    ; TODO Forward
    RETI

RXFWD5:
    ;reset state to 0
    LDI rxstate, 0
    ; TODO Forward
    RETI

RXEXE:
    ; store rxcmd4
    MOV rxcmd4, r16
    ;reset state to 0
    LDI rxstate, 0
    ; read rxcmd0 into r16
    MOV r16, rxcmd0
    ;switch execute
    ANDI r16, 0b00001111
    LSL r16
    LDI ZL, lo8(RXEXESwitch)
    LDI ZH, hi8(RXEXESwitch)
    ADD ZL, r16
    ADC ZH, r0
    IJMP

RXEXESwitch:
    .int RXNOP
    .int RXNOP
    .int RXEXEGPIO
    .int RXNOP
    .int RXEXETCA0PW0
    .int RXEXETCA0PW1
    .int RXEXETCA0PW2
    .int RXEXETCA0Frequency
    .int RXNOP
    .int RXEXETCB0PWFrequency
    .int RXNOP
    .int RXEXETCB1PWFrequency
    .int RXNOP
    .int RXNOP
    .int RXNOP
    .int RXNOP

RXEXEGPIO:
    ; TODO
    RETI

RXEXETCA0PW0:
    ; TODO
    RETI

RXEXETCA0PW1:
    ; TODO
    RETI

RXEXETCA0PW2:
    ; TODO
    RETI

RXEXETCA0Frequency:
    ; TODO
    RETI

RXEXETCB0PWFrequency:
    ; TODO
    RETI

RXEXETCB1PWFrequency:
    ; TODO
    RETI

RXCMD:
    ; store rxcmd0
    MOV rxcmd0, r16
    ;switch command
    ANDI r16, 0b00001111
    LSL r16
    LDI ZL, lo8(RXCMDSwitch)
    LDI ZH, hi8(RXCMDSwitch)
    ADD ZL, r16
    ADC ZH, r0
    IJMP ; 21 clocks to here

RXCMDSwitch:
    .int RXNOP
    .int RXCMDSetup
    .int RXCMDCheck4
    .int RXCMDAnalogFwd
    .int RXCMDCheck3
    .int RXCMDCheck3
    .int RXCMDCheck3
    .int RXCMDCheck3
    .int RXCMDFwd4
    .int RXCMDCheck3
    .int RXCMDFwd4
    .int RXCMDCheck3
    .int RXCMDFwd4
    .int RXCMDFwd5
    .int RXCMDFwd5
    .int RXNOP

RXNOP:
    RETI

RXCMDSetup:
    ; TODO
    RETI

RXCMDAnalogFwd:
    ; TODO
    RETI

RXCMDCheck3:
    MOV r16, rxcmd0
    SWAP r16
    ANDI r16, 0b00001111
    CPSE index, r16
    LDI rxstate, 3
    LDI rxstate, 15
    RETI

RXCMDCheck4:
    MOV r16, rxcmd0
    SWAP r16
    ANDI r16, 0b00001111
    CPSE index, r16
    LDI rxstate, 7
    LDI rxstate, 16
    RETI

RXCMDFwd4:
    LDI rxstate, 7
    RETI

RXCMDFwd5:
    LDI rxstate, 12
    RETI


.global main
main:
	ldi r16,0b00100000
	out VPORTB_DIR,r16
	out VPORTB_OUT,r16
    LDI r16, 0
    MOV r0, r16
    MOV rxstate, r0
	rjmp main
.end

; interrupt vectors
;RESET
;NMI
;BOD_VLM
;RTC_CNT
;RTC_PIT
;CCL_CCL
;PORTA_PORT
;PORT_PORTB
;TCA0_OVF/TCA0_LUNF
;TCA0_HUNF
;TCA0_CMP0/TCAO_LCMP0
;TCA0_CMP1/TCAO_LCMP1
;TCA0_CMP2/TCAO_LCMP2
;TCB0_INT
;TWI0_TWIS
;TWI0_TWIM
;SPI0_INT
;USART0_RCX
;USART0_DRE
;USART0_TXC
;AC0_AC
;ADC0_ERROR
;ADC0_RESRDY
;ADC0_SAMPRDY
;PORTC_PORT
;TCB1_INT
;USART1_RCX
;USART1_DRE
;USART1_TXC
;NVMCTRL_EE