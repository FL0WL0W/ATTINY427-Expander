#include <avr/io.h>
 
#define rxstate r25
#define rxcmd0 r2
#define rxcmd1 r3
#define rxcmd2 r4
#define rxcmd3 r5
#define rxcmd4 r6
#define fwdready0 r7
#define fwdready1 r8
#define fwdprocessing0 r9
#define fwdprocessing1 r10
#define nopfwdcnt r11
#define index r12

setupbuf:
.data
    .byte 0
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwd1buf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwd2buf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwd3buf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwd4buf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwd5buf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwd6buf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwd7buf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwd8buf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwd9buf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwdAbuf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwdBbuf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwdCbuf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwdDbuf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwdEbuf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte

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
    .int RXCMD          ; 0
    .int RXFWD2         ; 1
    .int RXSTORECMD4    ; 2
    .int RXSTORECMD3    ; 3
    .int RXSTORECMD2    ; 4
    .int DECSTATE       ; 5
    .int RXFWD4         ; 6
    .int RXSTORECMD4    ; 7
    .int RXSTORECMD3    ; 8
    .int DECSTATE       ; 9
    .int DECSTATE       ; 10
    .int RXFWD5         ; 11
    .int RXSTORECMD4    ; 12
    .int RXSTORECMD3    ; 13
    .int DECSTATE       ; 14
    .int DECSTATE       ; 15
    .int RXFWD6         ; 16
    .int RXSTORECMD4    ; 17
    .int RXSTORECMD3    ; 18
    .int DECSTATE       ; 19
    .int DECSTATE       ; 20
    .int RXFWD7         ; 21
    .int RXSTORECMD4    ; 22
    .int RXSTORECMD3    ; 23
    .int DECSTATE       ; 24
    .int DECSTATE       ; 25
    .int RXFWD8         ; 26
    .int RXSTORECMD4    ; 27
    .int RXSTORECMD3    ; 28
    .int RXSTORECMD2    ; 29
    .int DECSTATE       ; 30
    .int RXFWD9         ; 31
    .int RXSTORECMD4    ; 32
    .int RXSTORECMD3    ; 33
    .int DECSTATE       ; 34
    .int DECSTATE       ; 35
    .int RXFWDA         ; 36
    .int RXSTORECMD4    ; 37
    .int RXSTORECMD3    ; 38
    .int RXSTORECMD2    ; 39
    .int DECSTATE       ; 40
    .int RXFWDB         ; 41
    .int RXSTORECMD4    ; 42
    .int RXSTORECMD3    ; 43
    .int DECSTATE       ; 44
    .int DECSTATE       ; 45
    .int RXFWDC         ; 46
    .int RXSTORECMD4    ; 47
    .int RXSTORECMD3    ; 48
    .int RXSTORECMD2    ; 49
    .int DECSTATE       ; 50
    .int RXFWDD         ; 51
    .int RXSTORECMD4    ; 52
    .int RXSTORECMD3    ; 53
    .int RXSTORECMD2    ; 54
    .int RXSTORECMD1    ; 55
    .int RXFWDE         ; 56
    .int RXSTORECMD4    ; 57
    .int RXSTORECMD3    ; 58
    .int RXSTORECMD2    ; 59
    .int RXSTORECMD1    ; 60
    .int RXEXE          ; 61
    .int RXSTORECMD4    ; 62
    .int RXSTORECMD3    ; 63
    .int RXSTORECMD2    ; 64
    .int DECSTATE       ; 65
    .int RXFWD3         ; 66
    .int RXFWD3STORE1   ; 67
    .int RXFWD1         ; 68
    .int RXFWD1STORE1   ; 69

DECSTATE:
    DEC rxstate
    SBIW Z, 2
    IJMP

RXFWD1STORE1:
    ; store command in fwd buffer 1
    LDI ZL, lo8(rxfwd1buf)
    LDI ZH, hi8(rxfwd1buf)
    SBRC fwdprocessing0, 1
    RJMP NOTPROCESSINGFWD1
    INC rxcmd3
    ADIW Z, 16
NOTPROCESSINGFWD1:
    ST Z+, rxcmd0
    ST Z, r16
    LDI r16, 16
    MOV rxcmd1, r16
    DEC rxstate
    RETI

RXFWD3STORE1:
    ; store command in fwd buffer 3
    LDI ZL, lo8(rxfwd3buf)
    LDI ZH, hi8(rxfwd3buf)
    SBRC fwdprocessing0, 3
    RJMP NOTPROCESSINGFWD3
    INC rxcmd3
    ADIW Z, 33
NOTPROCESSINGFWD3:
    ST Z+, rxcmd0
    ST Z, r16
    INC r16
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

RXFWD1:
    ; store command in fwd buffer 1
    LDI ZL, lo8(rxfwd1buf)
    LDI ZH, hi8(rxfwd1buf)
    SBRC rxcmd3, 0
    ADIW Z, 16
    ADD ZL, rxcmd2
    ADC ZH, r0
    ST Z, r16
    INC rxcmd2
    CPSE rxcmd1, rxcmd2
    RETI
    MOV r16, fwdready0
    ORI r16, 0b00000010
    MOV fwdready0, r16
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXFWD2:
    ; store command in fwd buffer 2
    LDI ZL, lo8(rxfwd2buf)
    LDI ZH, hi8(rxfwd2buf)
    SBRC fwdprocessing0, 2
    ADIW Z, 5
    ST Z+, rxcmd0
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, r16
    MOV r16, fwdready0
    ORI r16, 0b00000100
    MOV fwdready0, r16
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXFWD3:
    ; store command in fwd buffer 3
    LDI ZL, lo8(rxfwd3buf)
    LDI ZH, hi8(rxfwd3buf)
    SBRC rxcmd3, 0
    ADIW Z, 33
    ADD ZL, rxcmd2
    ADC ZH, r0
    ST Z, r16
    INC rxcmd2
    CPSE rxcmd1, rxcmd2
    RETI
    MOV r16, fwdready0
    ORI r16, 0b00001000
    MOV fwdready0, r16
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXFWD4:
    ; store command in fwd buffer 4
    LDI ZL, lo8(rxfwd4buf)
    LDI ZH, hi8(rxfwd4buf)
    SBRC fwdprocessing0, 4
    ADIW Z, 4
    ST Z+, rxcmd0
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, r16
    MOV r16, fwdready0
    ORI r16, 0b00010000
    MOV fwdready0, r16
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXFWD5:
    ; store command in fwd buffer 5
    LDI ZL, lo8(rxfwd5buf)
    LDI ZH, hi8(rxfwd5buf)
    SBRC fwdprocessing0, 5
    ADIW Z, 4
    ST Z+, rxcmd0
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, r16
    MOV r16, fwdready0
    ORI r16, 0b00100000
    MOV fwdready0, r16
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXFWD6:
    ; store command in fwd buffer 6
    LDI ZL, lo8(rxfwd6buf)
    LDI ZH, hi8(rxfwd6buf)
    SBRC fwdprocessing0, 6
    ADIW Z, 4
    ST Z+, rxcmd0
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, r16
    MOV r16, fwdready0
    ORI r16, 0b01000000
    MOV fwdready0, r16
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXFWD7:
    ; store command in fwd buffer 7
    LDI ZL, lo8(rxfwd7buf)
    LDI ZH, hi8(rxfwd7buf)
    SBRC fwdprocessing0, 7
    ADIW Z, 4
    ST Z+, rxcmd0
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, r16
    MOV r16, fwdready0
    ORI r16, 0b10000000
    MOV fwdready0, r16
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXFWD8:
    ; store command in fwd buffer 8
    LDI ZL, lo8(rxfwd8buf)
    LDI ZH, hi8(rxfwd8buf)
    SBRC fwdprocessing1, 0
    ADIW Z, 5
    ST Z+, rxcmd0
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, r16
    MOV r16, fwdready1
    ORI r16, 0b00000001
    MOV fwdready1, r16
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXFWD9:
    ; store command in fwd buffer 9
    LDI ZL, lo8(rxfwd9buf)
    LDI ZH, hi8(rxfwd9buf)
    SBRC fwdprocessing1, 1
    ADIW Z, 4
    ST Z+, rxcmd0
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, r16
    MOV r16, fwdready1
    ORI r16, 0b00000010
    MOV fwdready1, r16
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXFWDA:
    ; store command in fwd buffer A
    LDI ZL, lo8(rxfwdAbuf)
    LDI ZH, hi8(rxfwdAbuf)
    SBRC fwdprocessing1, 2
    ADIW Z, 5
    ST Z+, rxcmd0
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, r16
    MOV r16, fwdready1
    ORI r16, 0b00000100
    MOV fwdready1, r16
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXFWDB:
    ; store command in fwd buffer B
    LDI ZL, lo8(rxfwdBbuf)
    LDI ZH, hi8(rxfwdBbuf)
    SBRC fwdprocessing1, 3
    ADIW Z, 4
    ST Z+, rxcmd0
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, r16
    MOV r16, fwdready1
    ORI r16, 0b00001000
    MOV fwdready1, r16
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXFWDC:
    ; store command in fwd buffer C
    LDI ZL, lo8(rxfwdCbuf)
    LDI ZH, hi8(rxfwdCbuf)
    SBRC fwdprocessing1, 4
    ADIW Z, 5
    ST Z+, rxcmd0
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, r16
    MOV r16, fwdready1
    ORI r16, 0b00010000
    MOV fwdready1, r16
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXFWDD:
    ; store command in fwd buffer D
    LDI ZL, lo8(rxfwdDbuf)
    LDI ZH, hi8(rxfwdDbuf)
    SBRC fwdprocessing1, 5
    ADIW Z, 6
    ST Z+, rxcmd0
    ST Z+, rxcmd1
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, r16
    MOV r16, fwdready1
    ORI r16, 0b00100000
    MOV fwdready1, r16
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXFWDE:
    ; store command in fwd buffer E
    LDI ZL, lo8(rxfwdEbuf)
    LDI ZH, hi8(rxfwdEbuf)
    SBRC fwdprocessing1, 6
    ADIW Z, 6
    ST Z+, rxcmd0
    ST Z+, rxcmd1
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, r16
    MOV r16, fwdready1
    ORI r16, 0b01000000
    MOV fwdready1, r16
    ;reset state to 0
    LDI rxstate, 0
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
    .int RXEXENOP
    .int RXEXESETUP
    .int RXEXEGPIO
    .int RXEXENOP
    .int RXEXETCA0PW0
    .int RXEXETCA0PW1
    .int RXEXETCA0PW2
    .int RXEXETCA0Period
    .int RXEXENOP
    .int RXEXETCB0PWPeriod
    .int RXEXENOP
    .int RXEXETCB1PWPeriod
    .int RXEXENOP
    .int RXEXENOP
    .int RXEXENOP
    .int RXEXENOP

RXEXENOP:
    RETI

RXEXESETUP:
    ; TODO
    RETI

RXEXEGPIO:
    ; TODO CRC
	out VPORTA_OUT, rxcmd2
	out VPORTB_OUT, rxcmd3
	out VPORTC_OUT, rxcmd4
    RETI

RXEXETCA0PW0:
    ; TODO CRC
    sts TCA0_SINGLE_CMP0BUFL, rxcmd4
    sts TCA0_SINGLE_CMP0BUFH, rxcmd3
    RETI

RXEXETCA0PW1:
    ; TODO CRC
    sts TCA0_SINGLE_CMP1BUFL, rxcmd4
    sts TCA0_SINGLE_CMP1BUFH, rxcmd3
    RETI

RXEXETCA0PW2:
    ; TODO CRC
    sts TCA0_SINGLE_CMP2BUFL, rxcmd4
    sts TCA0_SINGLE_CMP2BUFH, rxcmd3
    RETI

RXEXETCA0Period:
    ; TODO CRC
    sts TCA0_SINGLE_PERBUFL, rxcmd4
    sts TCA0_SINGLE_PERBUFH, rxcmd3
    RETI

RXEXETCB0PWPeriod:
    ; TODO CRC
    sts TCB0_CCMPL, rxcmd4 ; Period
    sts TCB0_CCMPH, rxcmd3 ; PW
    RETI

RXEXETCB1PWPeriod:
    ; TODO CRC
    sts TCB1_CCMPL, rxcmd4 ; Period
    sts TCB1_CCMPH, rxcmd3 ; PW
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
    .int RXNOPFwd
    .int RXCMDSetup
    .int RXCMDCheck2
    .int RXCMDAnalogFwd
    .int RXCMDCheck4
    .int RXCMDCheck5
    .int RXCMDCheck6
    .int RXCMDCheck7
    .int RXCMDFwd8
    .int RXCMDCheck9
    .int RXCMDFwdA
    .int RXCMDCheckB
    .int RXCMDFwdC
    .int RXCMDFwdD
    .int RXCMDFwdE
    .int RXNOPFwd

RXNOPFwd:
    INC nopfwdcnt
    MOV r16, fwdready1
    ORI r16, 0b10000000
    MOV fwdready1, r16
    RETI

RXCMDCHECKINDEX:
    MOV r16, rxcmd0
    SWAP r16
    ANDI r16, 0b00001111
    CPSE index, r16
    RETI
    LDI rxstate, 63
    RETI

RXCMDSetup:
    LDI rxstate, 69
    RJMP RXCMDCHECKINDEX

RXCMDAnalogFwd:
    LDI rxstate, 67
    LDI r16, 2
    MOV rxcmd2, r0
    MOV rxcmd3, r0
    RETI

RXCMDCheck2:
    LDI rxstate, 4
    RJMP RXCMDCHECKINDEX

RXCMDCheck4:
    LDI rxstate, 8
    RJMP RXCMDCHECKINDEX

RXCMDCheck5:
    LDI rxstate, 13
    RJMP RXCMDCHECKINDEX

RXCMDCheck6:
    LDI rxstate, 18
    RJMP RXCMDCHECKINDEX

RXCMDCheck7:
    LDI rxstate, 23
    RJMP RXCMDCHECKINDEX

RXCMDFwd8:
    LDI rxstate, 29
    RETI

RXCMDCheck9:
    LDI rxstate, 33
    RJMP RXCMDCHECKINDEX

RXCMDFwdA:
    LDI rxstate, 39
    RETI

RXCMDCheckB:
    LDI rxstate, 43
    RJMP RXCMDCHECKINDEX

RXCMDFwdC:
    LDI rxstate, 49
    RETI

RXCMDFwdD:
    LDI rxstate, 55
    RETI

RXCMDFwdE:
    LDI rxstate, 60
    RETI


.global main
main:
    ;initialize
    LDI r16, 0
    MOV r0, r16
    MOV rxstate, r0
    MOV index, r0
    MOV fwdready0, r0
    MOV fwdready1, r0
    MOV fwdprocessing0, r0
    MOV fwdprocessing1, r0
    MOV nopfwdcnt, r0
	RJMP main
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