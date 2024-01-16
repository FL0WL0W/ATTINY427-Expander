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
#define maingpr r17
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
    ADD ZL, intgpr
    ; store char in intgpr before switch
    LDS intgpr, USART0_RXDATAL
    LDI ZH, hi8(RXStateSwitch)
    ADC ZH, zero
    IJMP ; 9 clock cycles to here

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
    IJMP ; 18 clock cycles to here

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
    LDI intgpr, 2
    MOV rxcmd2, intgpr
    MOV rxcmd3, zero
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
    LDI intgpr, 10
    CPSE rxcmd0, intgpr
    RETI
    LDI intgpr, 1
    MOV rxcmd0, intgpr
    LDI rxstate, 70
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
    SBI fwdready0, 1
    DEC rxstate
    RETI

RXFWDSETUP:
    ; store command in fwd buffer setup
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
    SBI fwdready0, 2
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
    SBI fwdready0, 3
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
    ; store command in fwd analog buffer
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
    SBI fwdready0, 4
    DEC rxstate
    RETI

RXFWDANALOG:
    ; store command in fwd analog buffer
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
    SBI fwdready0, 5
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
    SBI fwdready0, 6
    ;reset state to 0
    LDI rxstate, 0
    RETI

RXCMDCheck7:
    LDI rxstate, 18
    LDI intgpr, 68
    RJMP RXCMDCHECKINDEX

RXFWD7:
    ; store command in fwd buffer 7
    LDI ZL, lo8(rxfwd7buf)
    LDI ZH, hi8(rxfwd7buf)
    ST Z+, rxcmd0
    ST Z+, rxcmd3
    ST Z+, rxcmd4
    ST Z, intgpr
    SBI fwdready0, 7
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
    SBI fwdready1, 0
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
    SBI fwdready1, 1
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
    SBI fwdready1, 2
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
    SBI fwdready1, 3
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
    SBI fwdready1, 4
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
    SBI fwdready1, 5
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
    SBI fwdready1, 6
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
    SBI fwdready1, 7
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
    IJMP ; 26 clock cycles to here

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
    ; stop ADC
    STS ADC0_COMMAND, zero
    ; turn off RTC
    STS RTC_INTCTRL, zero
    LDI ZL, lo8(setupbuf)
    LDI ZH, hi8(setupbuf)
    ; setup TCA0
    STS TCA0_SINGLE_CTRLA, zero
    MOV intgpr, rxcmd1
    ANDI intgpr, 0b00111000
    CPSE intgpr, zero
    RJMP RXEXESETUPTCA0
RXEXESETUPTCA0END:
    LD rxcmd0, Z+
    ; enable passthrough 0
    SBRS rxcmd0, 0
    RJMP RXEXESETUPNOPASS0
    LDI intgpr, 0x1
    STS EVSYS_USEREVSYSEVOUTB, intgpr
RXEXESETUPNOPASS0:
    ; enable passthrough 1
    LDI intgpr, 0b01000001
    SBRS rxcmd0, 1
    LDI intgpr, 0b00000000
    STS CCL_LUT3CTRLA, intgpr
    ; enable passthrough 2
    LDI intgpr, 0b01000001
    SBRS rxcmd0, 2
    LDI intgpr, 0b00000000
    STS CCL_LUT0CTRLA, intgpr
    ; enable passthrough 3
    LDI intgpr, 0b01000001
    SBRS rxcmd0, 3
    LDI intgpr, 0b00000000
    STS AC0_CTRLA, intgpr
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
    ; store analog enable
    LD rxcmd3, Z+
    LD intgpr, Z+
    MOV rxcmd1, intgpr
    ANDI intgpr, 0b11111110
    OUT analogenable0, intgpr
    OUT analogenable1, rxcmd3
    MOV rxcmd4, intgpr
    ; set digital period
    MOV intgpr, rxcmd1
    ANDI intgpr, 0b00000001
    STS RTC_PERH, intgpr
    LD intgpr, Z+
    STS RTC_PERL, intgpr
    ; setup TCB0
    LD rxcmd1, Z+
    LD rxcmd2, Z+
    STS TCB0_CTRLA, zero
    MOV intgpr, rxcmd1
    ANDI intgpr, 0b00111000
    CPSE intgpr, zero
    RJMP RXEXESETUPTCB0
RXEXESETUPTCB0END:
    ; setup TCB1
    LD rxcmd1, Z+
    LD rxcmd2, Z+
    STS TCB1_CTRLA, zero
    MOV intgpr, rxcmd1
    ANDI intgpr, 0b00111000
    CPSE intgpr, zero
    RJMP RXEXESETUPTCB1
RXEXESETUPTCB1END:
    ; turn on RTC
    LDI intgpr, 0b00010001
    STS RTC_INTCTRL, zero
    ; Start ADC if any ADC pin is enabled, temporarily stored in rxcmd3/4
    CPSE rxcmd3, zero
    STS ADC0_COMMAND, intgpr
    CPSE rxcmd4, zero
    STS ADC0_COMMAND, intgpr
    RETI

RXEXESETUPTCA0:
    MOV rxcmd0, intgpr
    LDI intgpr, 0b00100000
    ; for now only supporting OUTPUT on TCA. return if set as input
    CPSE rxcmd0, intgpr
    RJMP RXEXESETUPTCA0END
    ; set portmux
    STS PORTMUX_TCAROUTEA, rxcmd2
    ; set outputs
    MOV intgpr, rxcmd2
    ANDI intgpr, 0b11110000
    ORI intgpr, 0x3
    STS TCA0_SINGLE_CTRLB, intgpr
    ; TODO
    ; set clksel and enable
    MOV intgpr, rxcmd1
    SEC
    ROL intgpr
    ANDI intgpr, 0b00001111
    STS TCA0_SINGLE_CTRLA, intgpr
    RJMP RXEXESETUPTCA0END

RXEXESETUPTCB0:
    MOV rxcmd0, intgpr
    LDI intgpr, 0b00100000
    CPSE rxcmd0, intgpr
    RJMP RXEXESETUPTCB0INPUT
    ; set portmux
    lsl rxcmd2
    STS PORTMUX_TCBROUTEA, rxcmd2
    ; TODO
    ; set clksel and enable
    MOV intgpr, rxcmd1
    SEC
    ROL intgpr
    ANDI intgpr, 0b00001111
    STS TCB0_CTRLA, intgpr
    RJMP RXEXESETUPTCB0END

RXEXESETUPTCB0INPUT:
    ; TODO
    ; set clksel and enable
    MOV intgpr, rxcmd1
    SEC
    ROL intgpr
    ANDI intgpr, 0b00001111
    STS TCB0_CTRLA, intgpr
    RJMP RXEXESETUPTCB0END

RXEXESETUPTCB1:
    MOV rxcmd0, intgpr
    LDI intgpr, 0b00100000
    CPSE rxcmd0, intgpr
    RJMP RXEXESETUPTCB1INPUT
    ; set portmux
    MOV intgpr, rxcmd2
    ANDI intgpr, 0b00000001
    LDS rxcmd2, PORTMUX_TCBROUTEA
    OR rxcmd2, intgpr
    STS PORTMUX_TCBROUTEA, rxcmd2
    ; TODO
    ; set clksel and enable
    MOV intgpr, rxcmd1
    SEC
    ROL intgpr
    ANDI intgpr, 0b00001111
    STS TCB1_CTRLA, rxcmd1
    RJMP RXEXESETUPTCB1END

RXEXESETUPTCB1INPUT:
    ; TODO
    ; set clksel and enable
    MOV intgpr, rxcmd1
    SEC
    ROL intgpr
    ANDI intgpr, 0b00001111
    STS TCB1_CTRLA, rxcmd1
    RJMP RXEXESETUPTCB1END

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
    ; initialize
    LDI maingpr, 0
    MOV zero, maingpr
    MOV rxstate, zero
    MOV index, zero
    OUT fwdready0, zero
    OUT fwdready1, zero
    MOV nopfwdcnt, zero
    ; initialize RTC
    LDI maingpr, 0b00000001
    STS RTC_CTRLA, maingpr
    ; initialize ADC
    LDI maingpr, 0b00100001
    STS ADC0_CTRLA, maingpr
    STS ADC0_CTRLB, maingpr
    LDI maingpr, 0b10101001
    STS ADC0_CTRLC, maingpr
    LDI maingpr, 0b00000010
    STS ADC0_INTCTRL, maingpr
    ; initialize TCA0
    LDI maingpr, 0b00000011
    STS TCA0_SINGLE_CTRLESET, maingpr
    ; initialize passthrough
    ; passthrough 0

    ; passthrough 1
    LDI maingpr, 0b00000001
    STS CCL_CTRLA, maingpr
    LDI maingpr, 0x5
    STS CCL_LUT3CTRLC, maingpr
    LDI maingpr, 0b00001111
    STS CCL_TRUTH3, maingpr
    ; passthrough 2
    LDI maingpr, 0x5
    STS CCL_LUT0CTRLB, maingpr
    LDI maingpr, 0b01010101
    STS CCL_TRUTH0, maingpr
    LDI maingpr, 0b00000001
    STS PORTMUX_CCLROUTEA, maingpr
    ; passthrough 3
    LDI maingpr, 0b10011011
    STS AC0_MUXCTRLA, maingpr
    LDI maingpr, 84
    STS AC0_DACREF, maingpr
    LDI maingpr, 0x7
    STS VREF_CTRLA, maingpr
    ; passthrough 4
    ; passthrough 5
    LDI maingpr, 0x3
    STS CCL_LUT2CTRLB, maingpr
    LDI maingpr, 0b01010101
    STS CCL_TRUTH0, maingpr


mainloop:
	RJMP mainloop
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