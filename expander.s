#include <avr/io.h>
 
#define fwdready0 GPIO_GPIOR0
#define fwdready1 GPIO_GPIOR1
#define analogenable0 GPIO_GPIOR2
#define analogenable1 GPIO_GPIOR3
#define zero r0
#define rxcmd0 r1
#define rxcmd1 r2
#define rxcmd2 r3
#define rxcmd3 r4
#define rxcmd4 r5
#define rxcrc r6
#define txcmd1 r7
#define txcmd2 r8
#define txcmd3 r9
#define txcmd4 r10
#define txcmd5 r11
#define txcrc r12
#define nopfwdcnt r13
#define index r14
#define adcacc r15
#define intgpr r16
#define rxstate r25

.data
setupbuf:
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
rxfwdsetupbuf: 
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
rxfwd3buf: 
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwdanalogbuf: 
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
rxfwd5buf: 
    .byte
    .byte
    .byte
    .byte
rxfwd6buf: 
    .byte
    .byte
    .byte
    .byte
rxfwd7buf: 
    .byte
    .byte
    .byte
    .byte
rxfwd8buf: 
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
rxfwdAbuf: 
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
rxfwdCbuf: 
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
rxfwdEbuf: 
    .byte
    .byte
    .byte
    .byte
    .byte
    .byte
rxfwdFbuf: 
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
    MOV intgpr, rxstate
    LSL intgpr
    LDI ZL, lo8(RXStateSwitch)
    LDI ZH, hi8(RXStateSwitch)
    ADD ZL, intgpr
    ADC ZH, zero
    ; store char in intgpr before switch
    LDS intgpr, USART0_RXDATAL
    IJMP

RXStateSwitch:
    .int RXCMD             ; 0
    .int RXFWD2            ; 1
    .int RXSTORECMD4       ; 2
    .int RXSTORECMD3       ; 3
    .int RXSTORECMD2       ; 4
    .int DECSTATE          ; 5
    .int RXFWD3            ; 6
    .int RXSTORECMD4       ; 7
    .int RXSTORECMD3       ; 8
    .int RXSTORECMD2       ; 9
    .int DECSTATE          ; 10
    .int RXFWD5            ; 11
    .int RXSTORECMD4       ; 12
    .int RXSTORECMD3       ; 13
    .int DECSTATE          ; 14
    .int DECSTATE          ; 15
    .int RXFWD6            ; 16
    .int RXSTORECMD4       ; 17
    .int RXSTORECMD3       ; 18
    .int DECSTATE          ; 19
    .int DECSTATE          ; 20
    .int RXFWD7            ; 21
    .int RXSTORECMD4       ; 22
    .int RXSTORECMD3       ; 23
    .int DECSTATE          ; 24
    .int DECSTATE          ; 25
    .int RXFWD8            ; 26
    .int RXSTORECMD4       ; 27
    .int RXSTORECMD3       ; 28
    .int DECSTATE          ; 29
    .int DECSTATE          ; 30
    .int RXFWD9            ; 31
    .int RXSTORECMD4       ; 32
    .int RXSTORECMD3       ; 33
    .int RXSTORECMD2       ; 34
    .int DECSTATE          ; 35
    .int RXFWDA            ; 36
    .int RXSTORECMD4       ; 37
    .int RXSTORECMD3       ; 38
    .int DECSTATE          ; 39
    .int DECSTATE          ; 40
    .int RXFWDB            ; 41
    .int RXSTORECMD4       ; 42
    .int RXSTORECMD3       ; 43
    .int RXSTORECMD2       ; 44
    .int DECSTATE          ; 45
    .int RXFWDC            ; 46
    .int RXSTORECMD4       ; 47
    .int RXSTORECMD3       ; 48
    .int RXSTORECMD2       ; 49
    .int DECSTATE          ; 50
    .int RXFWDD            ; 51
    .int RXSTORECMD4       ; 52
    .int RXSTORECMD3       ; 53
    .int RXSTORECMD2       ; 54
    .int DECSTATE          ; 55
    .int RXFWDE            ; 56
    .int RXSTORECMD4       ; 57
    .int RXSTORECMD3       ; 58
    .int RXSTORECMD2       ; 59
    .int RXSTORECMD1       ; 60
    .int RXFWDF            ; 61
    .int RXSTORECMD4       ; 62
    .int RXSTORECMD3       ; 63
    .int RXSTORECMD2       ; 64
    .int RXSTORECMD1       ; 65
    .int RXEXE             ; 66
    .int RXSTOREEXECMD4    ; 67
    .int RXSTOREEXECMD3    ; 68
    .int RXSTOREEXECMD2    ; 69
    .int RXSTOREEXECMD1    ; 70
    .int RXFWDANALOG       ; 71
    .int RXFWDANALOGLENGTH ; 72
    .int RXFWDSETUP        ; 73
    .int RXFWDSETUPSTORE1  ; 74
    .int RXSTORESETUP      ; 75
    .int RXSTOREEXECMD4    ; 76
    .int RXSTOREEXECMD3    ; 77
    .int RXSTOREEXECMD2    ; 78
    .int RXSTOREEXECMD1    ; 79

DECSTATE:
    DEC rxstate
    SBIW Z, 2
    IJMP

RXCMD:
    ; store rxcmd0
    MOV rxcmd0, intgpr
    ;switch command
    ANDI intgpr, 0b00001111
    LSL intgpr
    LDI ZL, lo8(RXCMDSwitch)
    LDI ZH, hi8(RXCMDSwitch)
    ADD ZL, intgpr
    ADC ZH, zero
    IJMP

RXCMDSwitch:
    .int RXNOPFwd
    .int RXCMDSetup
    .int RXCMDCheck2
    .int RXCMDCheck3
    .int RXCMDAnalogFwd
    .int RXCMDCheck5
    .int RXCMDCheck6
    .int RXCMDCheck7
    .int RXCMDCheck8
    .int RXCMDFwd9
    .int RXCMDCheckA
    .int RXCMDFwdB
    .int RXCMDCheckC
    .int RXCMDFwdD
    .int RXCMDFwdE
    .int RXCMDFwdF

RXNOPFwd:
    INC nopfwdcnt
    RETI

RXCMDSetup:
    MOV intgpr, rxcmd0
    ANDI intgpr, 0b11110000
    CPSE zero, intgpr
    RJMP RXCMDSETUPSTORE
    LDI rxstate, 74
    SWAP rxcmd0
    DEC rxcmd0
    SWAP rxcmd0
    RETI
RXCMDSETUPSTORE:
    LDI rxstate, 79
    MOV rxcmd0, zero
    ; store initial crc value
    LDI intgpr, 0xE1
    MOV rxcrc, intgpr
    RETI

RXSTORESETUP:
    LDI ZL, lo8(setupbuf)
    LDI ZH, hi8(setupbuf)
    ADD ZL, rxcmd0
    ADC ZH, zero
    ST Z+, rxcmd1
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    ; calc crc
    EOR rxcrc, intgpr
    LSL rxcrc
    BRCC RXSTORESETUPCRCCC
    LDI intgpr, 0x1D
    EOR rxcrc, intgpr
RXSTORESETUPCRCCC:
    LDI rxstate, 79
    LDI intgpr, 5
    ADD rxcmd0, intgpr
    LDI intgpr, 15
    CPSE rxcmd0, intgpr
    LDI rxstate, 66
    RETI

RXFWDSETUPSTORE1:
    MOV rxcmd4, intgpr
    ; store command in fwd buffer 1
    LDI ZL, lo8(rxfwdsetupbuf)
    LDI ZH, hi8(rxfwdsetupbuf)
    SBIS fwdready0, 1
    RJMP NOTPROCESSINGFWDSETUP
    LD intgpr, Z
    CP intgpr, zero
    BRNE NOTPROCESSINGFWDSETUP
    INC rxcmd3
    ADIW Z, 16
NOTPROCESSINGFWDSETUP:
    ST Z+, rxcmd0
    ST Z, rxcmd4
    LDI intgpr, 16
    MOV rxcmd1, intgpr
    IN intgpr, fwdready0
    ORI intgpr, 0b00000010
    OUT fwdready0, intgpr
    DEC rxstate
    RETI

RXFWDSETUP:
    ; store command in fwd buffer 1
    LDI ZL, lo8(rxfwdsetupbuf)
    LDI ZH, hi8(rxfwdsetupbuf)
    SBRC rxcmd3, 0
    ADIW Z, 16
    ADD ZL, rxcmd2
    ADC ZH, zero
    ST Z, intgpr
    INC rxcmd2
    CPSE rxcmd1, rxcmd2
    RETI
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDCheck2:
    LDI rxstate, 4
    LDI intgpr, 69
    RJMP RXCMDCHECKINDEX

RXFWD2:
    ; store command in fwd buffer 2
    LDI ZL, lo8(rxfwd2buf)
    LDI ZH, hi8(rxfwd2buf)
    ST Z+, rxcmd0
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    IN intgpr, fwdready0
    ORI intgpr, 0b00000100
    OUT fwdready0, intgpr
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDCheck3:
    LDI rxstate, 4
    LDI intgpr, 69
    RJMP RXCMDCHECKINDEX
    
RXFWD3:
    ; store command in fwd buffer 3
    LDI ZL, lo8(rxfwd3buf)
    LDI ZH, hi8(rxfwd3buf)
    ST Z+, rxcmd0
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    IN intgpr, fwdready0
    ORI intgpr, 0b00001000
    OUT fwdready0, intgpr
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDAnalogFwd:
    LDI rxstate, 72
    LDI intgpr, 2
    MOV rxcmd2, intgpr
    MOV rxcmd3, zero
    RETI

RXFWDANALOGLENGTH:
    MOV rxcmd1, intgpr
    ; store command in fwd buffer 3
    LDI ZL, lo8(rxfwdanalogbuf)
    LDI ZH, hi8(rxfwdanalogbuf)
    SBIS fwdready0, 4
    RJMP NOTPROCESSINGFWDANALOG
    LD intgpr, Z
    CP intgpr, zero
    BRNE NOTPROCESSINGFWDANALOG
    INC rxcmd3
    ADIW Z, 33
NOTPROCESSINGFWDANALOG:
    ST Z+, rxcmd0
    ST Z, rxcmd1
    INC rxcmd1
    INC rxcmd1
    IN intgpr, fwdready0
    ORI intgpr, 0b00010000
    OUT fwdready0, intgpr
    DEC rxstate
    RETI

RXFWDANALOG:
    ; store command in fwd buffer 3
    LDI ZL, lo8(rxfwdanalogbuf)
    LDI ZH, hi8(rxfwdanalogbuf)
    SBRC rxcmd3, 0
    ADIW Z, 33
    ADD ZL, rxcmd2
    ADC ZH, zero
    ST Z, intgpr
    INC rxcmd2
    CPSE rxcmd1, rxcmd2
    RETI
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDCheck5:
    LDI rxstate, 8
    LDI intgpr, 68
    RJMP RXCMDCHECKINDEX

RXFWD5:
    ; store command in fwd buffer 5
    LDI ZL, lo8(rxfwd5buf)
    LDI ZH, hi8(rxfwd5buf)
    ST Z+, rxcmd0
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    IN intgpr, fwdready0
    ORI intgpr, 0b00100000
    OUT fwdready0, intgpr
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDCheck6:
    LDI rxstate, 13
    LDI intgpr, 68
    RJMP RXCMDCHECKINDEX

RXFWD6:
    ; store command in fwd buffer 6
    LDI ZL, lo8(rxfwd6buf)
    LDI ZH, hi8(rxfwd6buf)
    ST Z+, rxcmd0
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    IN intgpr, fwdready0
    ORI intgpr, 0b01000000
    OUT fwdready0, intgpr
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDCheck7:
    LDI rxstate, 18
    LDI intgpr, 68
    RJMP RXCMDCHECKINDEX

RXFWD7:
    ; store command in fwd buffer 6
    LDI ZL, lo8(rxfwd7buf)
    LDI ZH, hi8(rxfwd7buf)
    ST Z+, rxcmd0
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    IN intgpr, fwdready0
    ORI intgpr, 0b10000000
    OUT fwdready0, intgpr
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDCheck8:
    LDI rxstate, 23
    LDI intgpr, 68
    RJMP RXCMDCHECKINDEX

RXFWD8:
    ; store command in fwd buffer 8
    LDI ZL, lo8(rxfwd8buf)
    LDI ZH, hi8(rxfwd8buf)
    ST Z+, rxcmd0
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    IN intgpr, fwdready1
    ORI intgpr, 0b00000001
    OUT fwdready1, intgpr
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDFwd9:
    LDI rxstate, 29
    RETI

RXFWD9:
    ; store command in fwd buffer 9
    LDI ZL, lo8(rxfwd9buf)
    LDI ZH, hi8(rxfwd9buf)
    ST Z+, rxcmd0
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    IN intgpr, fwdready1
    ORI intgpr, 0b00000010
    OUT fwdready1, intgpr
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDCheckA:
    LDI rxstate, 33
    LDI intgpr, 68
    RJMP RXCMDCHECKINDEX

RXFWDA:
    ; store command in fwd buffer A
    LDI ZL, lo8(rxfwdAbuf)
    LDI ZH, hi8(rxfwdAbuf)
    ST Z+, rxcmd0
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    IN intgpr, fwdready1
    ORI intgpr, 0b00000100
    OUT fwdready1, intgpr
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDFwdB:
    LDI rxstate, 39
    RETI

RXFWDB:
    ; store command in fwd buffer B
    LDI ZL, lo8(rxfwdBbuf)
    LDI ZH, hi8(rxfwdBbuf)
    ST Z+, rxcmd0
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    IN intgpr, fwdready1
    ORI intgpr, 0b00001000
    OUT fwdready1, intgpr
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDCheckC:
    LDI rxstate, 43
    LDI intgpr, 68
    RJMP RXCMDCHECKINDEX

RXFWDC:
    ; store command in fwd buffer C
    LDI ZL, lo8(rxfwdCbuf)
    LDI ZH, hi8(rxfwdCbuf)
    ST Z+, rxcmd0
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    IN intgpr, fwdready1
    ORI intgpr, 0b00010000
    OUT fwdready1, intgpr
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDFwdD:
    LDI rxstate, 49
    RETI

RXFWDD:
    ; store command in fwd buffer D
    LDI ZL, lo8(rxfwdDbuf)
    LDI ZH, hi8(rxfwdDbuf)
    ST Z+, rxcmd0
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    IN intgpr, fwdready1
    ORI intgpr, 0b00100000
    OUT fwdready1, intgpr
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDFwdE:
    LDI rxstate, 55
    RETI

RXFWDE:
    ; store command in fwd buffer E
    LDI ZL, lo8(rxfwdEbuf)
    LDI ZH, hi8(rxfwdEbuf)
    ST Z+, rxcmd0
    ST Z+, rxcmd1
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    IN intgpr, fwdready1
    ORI intgpr, 0b01000000
    OUT fwdready1, intgpr
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDFwdF:
    LDI rxstate, 60
    RETI

RXFWDF:
    ; store command in fwd buffer F
    LDI ZL, lo8(rxfwdFbuf)
    LDI ZH, hi8(rxfwdFbuf)
    ST Z+, rxcmd0
    ST Z+, rxcmd1
    ST Z+, rxcmd2
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    IN intgpr, fwdready1
    ORI intgpr, 0b10000000
    OUT fwdready1, intgpr
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXSTORECMD1:
    ; store rxcmd1
    MOV rxcmd1, intgpr
    DEC rxstate
    RETI

RXSTORECMD2:
    ; store rxcmd2
    MOV rxcmd2, intgpr
    DEC rxstate
    RETI

RXSTORECMD3:
    ; store rxcmd3
    MOV rxcmd3, intgpr
    DEC rxstate
    RETI

RXSTORECMD4:
    ; store rxcmd4
    MOV rxcmd4, intgpr
    DEC rxstate
    RETI

RXCMDCHECKINDEX:
    MOV rxcmd1, intgpr
    MOV intgpr, rxcmd0
    SWAP intgpr
    ANDI intgpr, 0b00001111
    CPSE index, intgpr
    RETI
    MOV rxstate, rxcmd1
    ; Calculate CRC
    LDI intgpr, 0xFF
    MOV rxcrc, intgpr
    EOR rxcrc, rxcmd0
    LSL rxcrc
    BRCC RXCMDCHECKINDEXCRCCC
    LDI intgpr, 0x1D
    EOR rxcrc, intgpr
RXCMDCHECKINDEXCRCCC:
    RETI

RXEXE:
    ;reset state to 0
    LDI rxstate, 0
    ; verify crc
    EOR rxcrc, intgpr
    LSL rxcrc
    BRCC RXEXECRCCC
    LDI intgpr, 0x1D
    EOR rxcrc, intgpr
RXEXECRCCC:
    CPSE rxcrc, zero
    RETI
    ; read rxcmd0 into intgpr
    MOV intgpr, rxcmd0
    ;switch execute
    ANDI intgpr, 0b00001111
    LSL intgpr
    LDI ZL, lo8(RXEXESwitch)
    LDI ZH, hi8(RXEXESwitch)
    ADD ZL, intgpr
    ADC ZH, zero
    IJMP

RXEXESwitch:
    .int RXEXENOP
    .int RXEXESETUP
    .int RXEXEGPIODIRECTION
    .int RXEXEGPIOOUT
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

RXEXENOP:
    RETI

RXEXESETUP:
    LDI ZL, lo8(setupbuf)
    LDI ZH, hi8(setupbuf)
    ; enable passthrough 0-3
    LD rxcmd0, Z+
    ; TODO
    ; store index
    MOV intgpr, rxcmd0
    ANDI intgpr, 0b11110000
    SWAP intgpr
    MOV index, intgpr
    ; enable passthrough 4-5
    LD rxcmd0, Z+
    ; TODO
    ; store ADC Accumulate
    MOV intgpr, rxcmd0
    ANDI intgpr, 0b00001111
    MOV adcacc, intgpr
    ; set ADC Sample Duration
    LD intgpr, Z+
    STS ADC0_CTRLE, intgpr
    ; store analog enable1
    LD intgpr, Z+
    OUT analogenable1, intgpr
    ; set digital period
    LD rxcmd0, Z+
    MOV intgpr, rxcmd0
    ANDI intgpr, 0b00000001
    STS RTC_PERH, intgpr
    LD intgpr, Z+
    STS RTC_PERL, intgpr
    ; set analog enable0
    MOV intgpr, rxcmd0
    ANDI intgpr, 0b11111110
    OUT analogenable0, intgpr
    ; set PORTA Direction
    LD intgpr, Z+
    OUT VPORTA_DIR, intgpr
    ; set PORTB Direction
    LD intgpr, Z+
    OUT VPORTB_DIR, intgpr
    ; set PORTC Direction
    LD intgpr, Z+
    OUT VPORTC_DIR, intgpr
    ; setup TCA0
    LD rxcmd0, Z+
    LD rxcmd1, Z+
    ; TODO
    ; setup TCB0
    LD rxcmd0, Z+
    LD rxcmd1, Z+
    ; TODO
    ; setup TCB1
    LD rxcmd0, Z+
    LD rxcmd1, Z+
    ; TODO
    RETI

RXEXEGPIODIRECTION:
	out VPORTA_DIR, rxcmd2
	out VPORTB_DIR, rxcmd3
	out VPORTC_DIR, rxcmd4
    RETI

RXEXEGPIOOUT:
	out VPORTA_OUT, rxcmd2
	out VPORTB_OUT, rxcmd3
	out VPORTC_OUT, rxcmd4
    RETI

RXEXETCA0PW0:
    sts TCA0_SINGLE_CMP0BUFL, rxcmd4
    sts TCA0_SINGLE_CMP0BUFH, rxcmd3
    RETI

RXEXETCA0PW1:
    sts TCA0_SINGLE_CMP1BUFL, rxcmd4
    sts TCA0_SINGLE_CMP1BUFH, rxcmd3
    RETI

RXEXETCA0PW2:
    sts TCA0_SINGLE_CMP2BUFL, rxcmd4
    sts TCA0_SINGLE_CMP2BUFH, rxcmd3
    RETI

RXEXETCA0Period:
    sts TCA0_SINGLE_PERBUFL, rxcmd4
    sts TCA0_SINGLE_PERBUFH, rxcmd3
    RETI

RXEXETCB0PWPeriod:
    sts TCB0_CCMPL, rxcmd4 ; Period
    sts TCB0_CCMPH, rxcmd3 ; PW
    RETI

RXEXETCB1PWPeriod:
    sts TCB1_CCMPL, rxcmd4 ; Period
    sts TCB1_CCMPH, rxcmd3 ; PW
    RETI

RXSTOREEXECMD1:
    ; store rxcmd1
    MOV rxcmd1, intgpr
    DEC rxstate
    RJMP RXCALCCRC

RXSTOREEXECMD2:
    ; store rxcmd2
    MOV rxcmd2, intgpr
    DEC rxstate
    RJMP RXCALCCRC

RXSTOREEXECMD3:
    ; store rxcmd3
    MOV rxcmd3, intgpr
    DEC rxstate
    RJMP RXCALCCRC

RXSTOREEXECMD4:
    ; store rxcmd4
    MOV rxcmd4, intgpr
    DEC rxstate
    RJMP RXCALCCRC

RXCALCCRC:
    EOR rxcrc, intgpr
    LSL rxcrc
    BRCC RXCALCCRCCC
    LDI intgpr, 0x1D
    EOR rxcrc, intgpr
RXCALCCRCCC:
    RETI

.global main
main:
    ;initialize
    LDI intgpr, 0
    MOV zero, intgpr
    MOV rxstate, zero
    MOV index, zero
    OUT fwdready0, zero
    OUT fwdready1, zero
    MOV nopfwdcnt, zero
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