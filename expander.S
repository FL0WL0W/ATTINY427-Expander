#include <avr/io.h>
 
#define analogenable0 GPIO_GPIOR0
; bits 0-7 -> AIN Enable 0-7

#define analogenable1 GPIO_GPIOR1
; bits 8-15 -> AIN Enable 8-15

#define analogaccumulate GPIO_GPIOR2
; bits 0-3 accumulate count
; bit 7 clear accumulate. should be written whenever changing accumulate count or changing analog enables


#define SENTenableTCB0Bit 4
#define SENTenableTCB1Bit 5
#define SENTenable GPIO_GPIOR2
; bit 4 enable on TCB0
; bit 5 enable on TCB1

#define zero r2
;register always containing zero

#define lvl1SREG r3
;register used to store SREG during lvl1 interrupt
#define lvl0SREG r4
;register used to store SREG during lvl0 interrupt

#define commrxstate r16
; bit 4 read address
; bit 5 set address high to 0
; bit 6 read address low
; bit 7 write
#define commtxstate r17
#define commgpr r5
;register used for general purpose in spi interrupt

#define adcstate r6
; bits 0-3 is the current ADC index. 
; bit 7 is to clear index at end of this read.
; bit 6 is to clear the accumulate
#define adcacc r7
; accumulate 0-15
#define adcvalreg0 r14
#define adcvalreg1 r15
#define adcgpr r18
;registers used for general purpose in adc interrupt

#define tcbvalreg0 r14
#define tcbvalreg1 r15
#define tcbgpr0 r18
#define tcbgpr1 r19

#define tcb0syncl r8
#define tcb0synch r9
#define tcb0state r12
#define tcb1syncl r10
#define tcb1synch r11
#define tcb1state r13

#define maingpr0 r20

.data
.comm tcb0cnt, 1
.comm tcb0val, 4
.comm tcb1cnt, 1
.comm tcb1val, 4
.comm gpioina, 1
.comm gpioinb, 1
.comm gpioinc, 1
.comm adccnt, 1
.comm adcval, 14 * 2
.comm tcb0buff, 4
.comm tcb1buff, 4
.comm adcbuff, 14 * 16 * 2
tcb0previouspulse:
.short 0
tcb1previouspulse:
.short 0

.text
#ifdef COMM_SPI
#define COMM_TXREG SPI0_DATA
#define COMM_RXREG SPI0_DATA
.global SPI0_INT_vect
SPI0_INT_vect:
#else
#ifdef COMM_USART1
#define COMM_TXREG USART1_TXDATAL
#define COMM_RXREG USART1_RXDATAL
.global USART1_RXC_vect
USART1_RXC_vect:
#else
#define COMM_TXREG USART0_TXDATAL
#define COMM_RXREG USART0_RXDATAL
.global USART0_RXC_vect
USART0_RXC_vect:
#endif
#endif
    IN lvl1SREG, CPU_SREG
    CPSE commrxstate, zero
    RJMP COMMRXPROCESS
COMMREADCMD:
    LDS commrxstate, COMM_RXREG
    SBRS commrxstate, 7
    RJMP COMMTXCMD
    CPSE commtxstate, zero
    RJMP COMMTXPROCESS
    STS COMM_TXREG, zero
    OUT CPU_SREG, lvl1SREG
    RETI

COMMTXCMD:
    SBRC commrxstate, 4
    RJMP COMMTXCMDCONTINUATION
    CPSE commtxstate, zero
    RJMP COMMTXPROCESS
    STS COMM_TXREG, commrxstate
    OUT CPU_SREG, lvl1SREG
    RETI

COMMTXCMDCONTINUATION:
    MOV commgpr, commrxstate
    MOV commtxstate, commrxstate
    ANDI commtxstate, 0b00001111
    CLR commrxstate
    CPSE commtxstate, zero
    RJMP COMMTXPROCESS
    STS COMM_TXREG, commgpr
    OUT CPU_SREG, lvl1SREG
    RETI

COMMTXPROCESS:
    LD commgpr, X+
    STS COMM_TXREG, commgpr
    DEC commtxstate
    OUT CPU_SREG, lvl1SREG
    RETI

COMMRXPROCESS:
    SBRS commrxstate, 4
    RJMP COMMREADADDR
    SBRC commrxstate, 7
    RJMP COMMWRITE
    MOVW X, Y
    MOV commtxstate, commrxstate
    ANDI commtxstate, 0b00001111
    RJMP COMMREADCMD

COMMWRITE:
    LDS commgpr, COMM_RXREG
    ST Y+, commgpr
    DEC commrxstate
    ANDI commrxstate, 0b00001111
    CPSE commrxstate, zero
    ORI commrxstate, 0b10010000
    CPSE commtxstate, zero
    RJMP COMMTXPROCESS
    STS COMM_TXREG, zero
    OUT CPU_SREG, lvl1SREG
    RETI

COMMREADADDR:
    SBRS commrxstate, 6
    RJMP COMMREADADDRH
    SBRC commrxstate, 5
    CLR XH
    LDS XL, COMM_RXREG
    ORI commrxstate, 0b00010000
    CPSE commtxstate, zero
    RJMP COMMTXPROCESS
    SBRS commrxstate, 7
    STS COMM_TXREG, XL
    SBRC commrxstate, 7
    STS COMM_TXREG, zero
    OUT CPU_SREG, lvl1SREG
    RETI

COMMREADADDRH:
    LDS XH, COMM_RXREG
    ORI commrxstate, 0b01000000
    CPSE commtxstate, zero
    RJMP COMMTXPROCESS
    SBRS commrxstate, 7
    STS COMM_TXREG, XH
    SBRC commrxstate, 7
    STS COMM_TXREG, zero
    OUT CPU_SREG, lvl1SREG
    RETI

.global ADC0_RESRDY_vect
ADC0_RESRDY_vect:
    IN lvl0SREG, CPU_SREG
    LDS adcgpr, ADC0_MUXPOS
    ; * (2+2)
    LSL adcgpr
    LDI ZH, hi8(gs(ADC0SETSAMPLE))
    LDI ZL, lo8(gs(ADC0SETSAMPLE))
    ADD ZL, adcgpr
    ADC ZH, zero
    IJMP
ADC0SETSAMPLE:
#ifdef COMM_SPI
#ifdef COMM_ALT
ADC0SETSAMPLEBEGIN:
    SBIC analogenable0, 1
    RJMP ADC0SETSAMPLE1
    SBIC analogenable0, 2
    RJMP ADC0SETSAMPLE2
    SBIC analogenable0, 3
    RJMP ADC0SETSAMPLE3
    SBIC analogenable0, 4
    RJMP ADC0SETSAMPLE4
#else
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
ADC0SETSAMPLEBEGIN:
#endif
#else
#if (defined(COMM_USART1) && !defined(COMM_ALT)) || (!defined(COMM_USART1) && defined(COMM_ALT))
    NOP
    NOP
    NOP
    NOP
ADC0SETSAMPLEBEGIN:
    SBIC analogenable0, 3
    RJMP ADC0SETSAMPLE3
    SBIC analogenable0, 4
    RJMP ADC0SETSAMPLE4
#else
ADC0SETSAMPLEBEGIN:
    SBIC analogenable0, 1
    RJMP ADC0SETSAMPLE1
    SBIC analogenable0, 2
    RJMP ADC0SETSAMPLE2
    SBIC analogenable0, 3
    RJMP ADC0SETSAMPLE3
    SBIC analogenable0, 4
    RJMP ADC0SETSAMPLE4
#endif
#endif
    SBIC analogenable0, 5
    RJMP ADC0SETSAMPLE5
    SBIC analogenable0, 6
    RJMP ADC0SETSAMPLE6
    SBIC analogenable0, 7
    RJMP ADC0SETSAMPLE7
    SBIC analogenable1, 0
    RJMP ADC0SETSAMPLE8
    SBIC analogenable1, 1
    RJMP ADC0SETSAMPLE9
    SBIC analogenable1, 2
    RJMP ADC0SETSAMPLE10
    SBIC analogenable1, 3
    RJMP ADC0SETSAMPLE11
#ifdef COMM_SPI
#ifdef COMM_ALT
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
#else
    SBIC analogenable1, 4
    RJMP ADC0SETSAMPLE12
    SBIC analogenable1, 5
    RJMP ADC0SETSAMPLE13
    SBIC analogenable1, 6
    RJMP ADC0SETSAMPLE14
    SBIC analogenable1, 7
    RJMP ADC0SETSAMPLE15
#endif
#else
#if defined(COMM_USART1) && defined(COMM_ALT)
    SBIC analogenable1, 4
    RJMP ADC0SETSAMPLE12
    NOP
    NOP
    NOP
    NOP
    SBIC analogenable1, 7
    RJMP ADC0SETSAMPLE15
#else
    SBIC analogenable1, 4
    RJMP ADC0SETSAMPLE12
    SBIC analogenable1, 5
    RJMP ADC0SETSAMPLE13
    SBIC analogenable1, 6
    RJMP ADC0SETSAMPLE14
    SBIC analogenable1, 7
    RJMP ADC0SETSAMPLE15
#endif
#endif
    LDI ZL, 0b10000000
    OR adcstate, ZL
    IN ZH, analogaccumulate
    LDI ZL, 0b00001111
    AND ZH, ZL
    AND adcacc, ZL
    MOV ZL, adcacc
    INC adcacc
    CPSE ZH, ZL
    RJMP ADC0SETSAMPLEBEGIN
    CLR adcacc
    RJMP ADC0SETSAMPLEBEGIN
ADC0SETSAMPLE1:
    LDI ZL, 1
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE2:
    LDI ZL, 2
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE3:
    LDI ZL, 3
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE4:
    LDI ZL, 4
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE5:
    LDI ZL, 5
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE6:
    LDI ZL, 6
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE7:
    LDI ZL, 7
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE8:
    LDI ZL, 8
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE9:
    LDI ZL, 9
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE10:
    LDI ZL, 10
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE11:
    LDI ZL, 11
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE12:
    LDI ZL, 12
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE13:
    LDI ZL, 13
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE14:
    LDI ZL, 14
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE15:
    LDI ZL, 15

ADC0STARTSAMPLE:
    STS ADC0_MUXPOS, ZL
    LDS adcvalreg0, ADC0_RESULT0
    LDS adcvalreg1, ADC0_RESULT1
    LDI ZL, 0b00010001
    STS ADC0_COMMAND, ZL

    ; check and make sure current reading is enabled
    LDI ZL, 0b00000001
    SBRC adcgpr, 2
    LDI ZL, 0b00000100
    SBRC adcgpr, 3
    SWAP ZL
    SBRC adcgpr, 1
    LSL ZL
    BST adcgpr, 4
    IN adcgpr, analogenable0
    BRTC ADC0CHECKENABLE
    IN adcgpr, analogenable1
ADC0CHECKENABLE:
    AND adcgpr, ZL
    BRNE ADC0PASSCHECKENABLED
    OUT CPU_SREG, lvl0SREG
    RETI

ADC0PASSCHECKENABLED:
    ; ZH = hi8(adcbuff)
    LDI ZH, hi8(adcbuff)
    ; ZL = (adcstate & 0x0F) * 32
    MOV ZL, adcstate
    ANDI ZL, 0x0F
    SWAP ZL ; * 16
    LSL ZL ; * 2
    ADC ZH, zero
    ; Z += lo8(adcbuff)
    ADIW ZL, 0x3C; lo8(adcbuff) for some reason compiler complains using lo8
    ; check if we need to clear accumulate
    SBRC adcstate, 6
    RJMP ADC0CLEARACCUMULATE
    ; Z + adcacc * 2
    MOV adcgpr, adcacc
    LSL adcgpr
    ADC ZH, zero
    ADD ZL, adcgpr
    ADC ZH, zero

    ; load, store and subtract
    LD adcgpr, Z
    ST Z, adcvalreg0
    SUB adcvalreg0, adcgpr
    LDD adcgpr, Z+1
    STD Z+1, adcvalreg1
    SBC adcvalreg1, adcgpr

    ; Z = adcval + (adcstate & 0x0F) * 2
    LDI ZH, hi8(adcval)
    MOV ZL, adcstate
    ANDI ZL, 0x0F
    LSL ZL ; * 2
    ADIW ZL, 0x0E; lo8(adcval) for some reason compiler complains using lo8

    ; load and add
    LD adcgpr, Z+
    ADD adcvalreg0, adcgpr
    LD adcgpr, Z
    ADC adcvalreg1, adcgpr

ADC0CLEARACCUMULATERETURN:
    ; ensure spi is not transferring this section of memory
ADC0CHECK:
    SEI
    CLI
    CP ZL, XL
    CPC ZH, XH
    CPSE commtxstate, zero
    BREQ ADC0CHECK
    ST -Z, adcvalreg0
    ST Z+, adcvalreg0
    ST Z, adcvalreg1
    SEI

    LDS ZL, adccnt
    INC ZL
    STS adccnt, ZL

    INC adcstate

    ; if adcstate needs to be reset
    SBRS adcstate, 7
    RJMP ADC0RETURN
    ; clear analogaccumulate clear bit if its been cleared
    SBRC adcstate, 6
    CBI analogaccumulate, 7
    ; reset adcstate
    CLR adcstate
    ; set adcstate to clear accumulate
    SBIS analogaccumulate, 7
    RJMP ADC0RETURN
    LDI ZL, 0b01000000
    OR adcstate, ZL
    CLR adcacc

ADC0RETURN:
    OUT CPU_SREG, lvl0SREG
    RETI

ADC0CLEARACCUMULATE:
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ST Z+, adcvalreg0
    ST Z+, adcvalreg1
    ; adcvalreg0/7 *= analogaccumulate + 1
    ; PUSH r0
    ; PUSH r1
    IN ZH, analogaccumulate
    ANDI ZH, 0b00001111
    INC ZH
    MUL adcvalreg1, ZH
    MOV ZL, r0
    MUL adcvalreg0, ZH
    ADD r1, ZL
    MOVW adcvalreg0, r0
    ; POP r1
    ; POP r0
    ; Z = adcval + (adcstate & 0x0F) * 2
    LDI ZH, hi8(adcval)
    MOV ZL, adcstate
    ANDI ZL, 0x0F
    LSL ZL ; * 2
    ADIW ZL, 0x0F; lo8(adcval) + 1 for some reason compiler complains using lo8
    RJMP ADC0CLEARACCUMULATERETURN

.global TCB0_INT_vect
TCB0_INT_vect:
    IN lvl0SREG, CPU_SREG
    SBIC SENTenable, SENTenableTCB0Bit
    RJMP SENTTCB0
    LDS ZL, tcb0cnt
    INC ZL
    STS tcb0cnt, ZL
    ; Z = &tcb0val
    LDI ZH, hi8(tcb0val)
    LDI ZL, lo8(tcb0val)
    ; tcb0val = TCB0_CCMP << 16 | TCB0_CNT
    LDS tcbgpr0, TCB0_CNTL
    RCALL TCBVALWRITE
    LDS tcbgpr0, TCB0_CNTH
    RCALL TCBVALWRITE
    LDS tcbgpr0, TCB0_CCMPL
    RCALL TCBVALWRITE
    LDS tcbgpr0, TCB0_CCMPH
    RCALL TCBVALWRITE    
    ; clear flags
    LDI ZL, 0b00000011
    STS TCB0_INTFLAGS, ZL
    OUT CPU_SREG, lvl0SREG
    RETI

SENTTCB0:
    LDS tcbvalreg0, TCB0_CCMPL
    LDS tcbvalreg1, TCB0_CCMPH
    ; check if state = 8. If so, this is pause/sync pulse, copy buffer to value
    SBRC tcb0state, 3
    RJMP SENTTCB0COPYBUFF
    ; check if there was an overflow. if so, disregard this pulse, it's probably a pause pulse not caught by state
    LDS ZL, TCB0_INTFLAGS
    SBRC ZL, 1
    RJMP SENTTCB0RETURN
    ; check if sync pulse is 0
    CP tcb0synch, zero
    CPC tcb0syncl, zero
    BRNE SENTTCB0SYNCED
    RJMP SENTTCB0SYNCTOOSMALL
SENTTCB0SYNCED:
    MOV ZL, tcbvalreg0
    MOV ZH, tcbvalreg1
    ; subtract 11.5 Ticks
    MOV tcbgpr1, tcb0syncl
    LSL tcbgpr1
    ROL tcb0synch
    LSL tcbgpr1
    ROL tcb0synch
    LSL tcbgpr1
    ROL tcb0synch
    SUB ZL, tcbgpr1
    SBC ZH, tcb0synch
    LSR tcb0synch
    ROR tcbgpr1
    SUB ZL, tcbgpr1
    SBC ZH, tcb0synch
    LSR tcb0synch
    LSR tcb0synch
    MOV tcbgpr1, tcb0syncl
    LSR tcb0synch
    ROR tcbgpr1
    ADD ZL, tcbgpr1
    ADC ZH, tcb0synch
    LSL tcbgpr1
    ROL tcb0synch
    ; if negative, tcb0sync is too big
    BRCS SENTTCB0SYNCTOOBIG
    CLR tcbgpr1
    SUB ZL, tcb0syncl
    SBC ZH, tcb0synch
SENTTCB0CNT:
    BRCS SENTTCB0CNTCMPLT
    SUB ZL, tcb0syncl
    SBC ZH, tcb0synch
    INC tcbgpr1
    ; if tcbgpr1 < 16, continue
    SBRS tcbgpr1, 4
    RJMP SENTTCB0CNT
    RJMP SENTTCB0SYNCTOOSMALL
SENTTCB0CNTCMPLT:
    MOV ZL, tcb0state
    LSR ZL
    LDI ZH, hi8(tcb0buff)
    ADIW Z, 0x30; lo8(tcb0buff)
    SBRS tcb0state, 0
    RJMP SENTTCB0LOW
    LD tcbgpr0, Z
    ANDI tcbgpr0, 0x0F
    SWAP tcbgpr1
    OR tcbgpr1, tcbgpr0
SENTTCB0LOW:
    ST Z, tcbgpr1
    INC tcb0state
    STS tcb0previouspulse, tcbvalreg0
    STS tcb0previouspulse+1, tcbvalreg1
SENTTCB0RETURN:
    LDI ZL, 0b00000011
    STS TCB0_INTFLAGS, ZL
    OUT CPU_SREG, lvl0SREG
    RETI

SENTTCB0COPYBUFF:
    LDS ZL, tcb0cnt
    INC ZL
    STS tcb0cnt, ZL
    LDI ZH, hi8(tcb0val)
    LDI ZL, lo8(tcb0val)
    ; tcb0val = tcb0buff
    LDS tcbgpr0, tcb0buff
    RCALL TCBVALWRITE
    LDS tcbgpr0, tcb0buff+1
    RCALL TCBVALWRITE
    LDS tcbgpr0, tcb0buff+2
    RCALL TCBVALWRITE
    LDS tcbgpr0, tcb0buff+3
    RCALL TCBVALWRITE
    CLR tcb0state
    RJMP SENTTCB0SYNCTOOSMALL

SENTTCB0SYNCTOOBIG:
    ; getting here means we need to use previous pulse as sync pulse
    LDS ZL, tcb0previouspulse
    LDS ZH, tcb0previouspulse+1
    ; PUSH r0
    ; PUSH r1
    RCALL DIVIDEZBY56
    MOVW tcb0syncl, r0
    ; POP r1
    ; POP r0
    CLR tcb0state
    RJMP SENTTCB0SYNCED
SENTTCB0SYNCTOOSMALL:
    ; getting here means we need to use this pulse as sync pulse
    MOV ZL, tcbvalreg0
    MOV ZH, tcbvalreg1
    STS tcb0previouspulse, ZL
    STS tcb0previouspulse+1, ZH
    ; PUSH r0
    ; PUSH r1
    RCALL DIVIDEZBY56
    MOVW tcb0syncl, r0
    ; POP r1
    ; POP r0
    CLR tcb0state
    LDI ZL, 0b00000011
    STS TCB0_INTFLAGS, ZL
    OUT CPU_SREG, lvl0SREG
    RETI

DIVIDEZBY56:
    ;/16 rounded
    ADIW Z, 8
    SWAP ZH
    SWAP ZL
    ANDI ZL, 0xF
    MOV tcbgpr0, ZH
    ANDI tcbgpr0, 0xF0
    OR ZL, tcbgpr0
    ANDI ZH, 0xF
    ;*73/256 rounded
    LDI tcbgpr0, 73
    MUL ZL, tcbgpr0
    LDI ZL, 0x80
    ADD r0, ZL
    ADC r1, zero
    MOV ZL, r1
    LDI tcbgpr0, 73
    MUL ZH, tcbgpr0
    ADD r0, ZL
    ADC r1, zero
    RET

TCBVALWRITE:
    SEI
    CLI
    CP ZL, XL
    CPC ZH, XH
    CPSE commtxstate, zero
    BREQ TCBVALWRITE
    ST Z+, tcbgpr0
    SEI
    RET

SENTTCB1:
    LDS tcbvalreg0, TCB1_CCMPL
    LDS tcbvalreg1, TCB1_CCMPH
    ; check if state = 8. If so, this is pause/sync pulse, copy buffer to value
    SBRC tcb1state, 3
    RJMP SENTTCB1COPYBUFF
    ; check if there was an overflow. if so, disregard this pulse, it's probably a pause pulse not caught by state
    LDS ZL, TCB1_INTFLAGS
    SBRC ZL, 1
    RJMP SENTTCB1RETURN
    ; check if sync pulse is 0
    CP tcb1synch, zero
    CPC tcb1syncl, zero
    BRNE SENTTCB1SYNCED
    RJMP SENTTCB1SYNCTOOSMALL
SENTTCB1SYNCED:
    MOV ZL, tcbvalreg0
    MOV ZH, tcbvalreg1
    ; subtract 11.5 Ticks
    MOV tcbgpr1, tcb1syncl
    LSL tcbgpr1
    ROL tcb1synch
    LSL tcbgpr1
    ROL tcb1synch
    LSL tcbgpr1
    ROL tcb1synch
    SUB ZL, tcbgpr1
    SBC ZH, tcb1synch
    LSR tcb1synch
    ROR tcbgpr1
    SUB ZL, tcbgpr1
    SBC ZH, tcb1synch
    LSR tcb1synch
    LSR tcb1synch
    MOV tcbgpr1, tcb1syncl
    LSR tcb1synch
    ROR tcbgpr1
    ADD ZL, tcbgpr1
    ADC ZH, tcb1synch
    LSL tcbgpr1
    ROL tcb1synch
    ; if negative, tcb1sync is too big
    BRCS SENTTCB1SYNCTOOBIG
    CLR tcbgpr1
    SUB ZL, tcb1syncl
    SBC ZH, tcb1synch
SENTTCB1CNT:
    BRCS SENTTCB1CNTCMPLT
    SUB ZL, tcb1syncl
    SBC ZH, tcb1synch
    INC tcbgpr1
    ; if tcbgpr1 < 16, continue
    SBRS tcbgpr1, 4
    RJMP SENTTCB1CNT
    RJMP SENTTCB1SYNCTOOSMALL
SENTTCB1CNTCMPLT:
    MOV ZL, tcb1state
    LSR ZL
    LDI ZH, hi8(tcb1buff)
    ADIW Z, 0x34; lo8(tcb1buff)
    SBRS tcb1state, 0
    RJMP SENTTCB1LOW
    LD tcbgpr0, Z
    ANDI tcbgpr0, 0x0F
    SWAP tcbgpr1
    OR tcbgpr1, tcbgpr0
SENTTCB1LOW:
    ST Z, tcbgpr1
    INC tcb1state
    STS tcb1previouspulse, tcbvalreg0
    STS tcb1previouspulse+1, tcbvalreg1
SENTTCB1RETURN:
    LDI ZL, 0b00000011
    STS TCB1_INTFLAGS, ZL
    OUT CPU_SREG, lvl0SREG
    RETI

SENTTCB1COPYBUFF:
    LDS ZL, tcb1cnt
    INC ZL
    STS tcb1cnt, ZL
    LDI ZH, hi8(tcb1val)
    LDI ZL, lo8(tcb1val)
    ; tcb1val = tcb1buff
    LDS tcbgpr0, tcb1buff
    RCALL TCBVALWRITE
    LDS tcbgpr0, tcb1buff+1
    RCALL TCBVALWRITE
    LDS tcbgpr0, tcb1buff+2
    RCALL TCBVALWRITE
    LDS tcbgpr0, tcb1buff+3
    RCALL TCBVALWRITE
    CLR tcb1state
    RJMP SENTTCB1SYNCTOOSMALL

SENTTCB1SYNCTOOBIG:
    ; getting here means we need to use previous pulse as sync pulse
    LDS ZL, tcb1previouspulse
    LDS ZH, tcb1previouspulse+1
    ; PUSH r0
    ; PUSH r1
    RCALL DIVIDEZBY56
    MOVW tcb1syncl, r0
    ; POP r1
    ; POP r0
    CLR tcb1state
    RJMP SENTTCB1SYNCED
SENTTCB1SYNCTOOSMALL:
    ; getting here means we need to use this pulse as sync pulse
    MOV ZL, tcbvalreg0
    MOV ZH, tcbvalreg1
    STS tcb1previouspulse, ZL
    STS tcb1previouspulse+1, ZH
    ; PUSH r0
    ; PUSH r1
    RCALL DIVIDEZBY56
    MOVW tcb1syncl, r0
    ; POP r1
    ; POP r0
    CLR tcb1state
    LDI ZL, 0b00000011
    STS TCB1_INTFLAGS, ZL
    OUT CPU_SREG, lvl0SREG
    RETI

.global TCB1_INT_vect
TCB1_INT_vect:
    IN lvl0SREG, CPU_SREG
    SBIC SENTenable, SENTenableTCB1Bit
    RJMP SENTTCB1
    LDS ZL, tcb1cnt
    INC ZL
    STS tcb1cnt, ZL
    ; Z = &tcb1val
    LDI ZH, hi8(tcb1val)
    LDI ZL, lo8(tcb1val)
    ; tcb1val = TCB1_CCMP << 16 | TCB1_CNT
    LDS tcbgpr0, TCB1_CNTL
    RCALL TCBVALWRITE
    LDS tcbgpr0, TCB1_CNTH
    RCALL TCBVALWRITE
    LDS tcbgpr0, TCB1_CCMPL
    RCALL TCBVALWRITE
    LDS tcbgpr0, TCB1_CCMPH
    RCALL TCBVALWRITE    
    ; clear flags
    LDI ZL, 0b00000011
    STS TCB1_INTFLAGS, ZL
    OUT CPU_SREG, lvl0SREG
    RETI


.global main
main:
    CLR maingpr0
    ; initialize clock
    LDI maingpr0, 0xD8
    OUT CCP, maingpr0
    STS CLKCTRL_MCLKCTRLB, maingpr0
    ; initialize zero and states
    CLR zero
    CLR adcstate
    CLR adcacc
    CLR commrxstate
    CLR commtxstate
    CLR tcb0syncl
    CLR tcb0synch
    CLR tcb0state
    CLR tcb1syncl
    CLR tcb1synch
    CLR tcb1state
    ; make ADC lower priority then TCB1
    LDI maingpr0, ADC0_RESRDY_vect_num
    STS CPUINT_LVL0PRI, maingpr0
    ; initialize SPI
#ifdef COMM_SPI
#ifdef COMM_ALT
    LDI maingpr0, 0b00000001
    STS PORTMUX_SPIROUTEA, maingpr0
    SBI VPORTC_DIR, 1
#else
    SBI VPORTA_DIR, 2
#endif
    LDI maingpr0, 0b00000001
    STS SPI0_CTRLA, maingpr0
    LDI maingpr0, 0b10000000
    STS SPI0_CTRLB, maingpr0
    STS SPI0_INTCTRL, maingpr0
    LDI maingpr0, SPI0_INT_vect_num
    STS CPUINT_LVL1VEC, maingpr0
#else
#ifdef COMM_USART1
#ifdef COMM_ALT
    LDI maingpr0, 0b00000100
    STS PORTMUX_USARTROUTEA, maingpr0
    SBI VPORTC_DIR, 2
#else
    SBI VPORTA_DIR, 1
#endif
    LDI maingpr0, 0x00
    STS USART1_BAUDH, maingpr0
    LDI maingpr0, 0x50
    STS USART1_BAUDL, maingpr0
    LDI maingpr0, 0b10000000
    STS USART1_CTRLA, maingpr0
    LDI maingpr0, 0b11000010
    STS USART1_CTRLB, maingpr0
    LDI maingpr0, 0x03
    STS USART1_CTRLC, maingpr0
    LDI maingpr0, USART1_RXC_vect_num
    STS CPUINT_LVL1VEC, maingpr0
#else
#ifdef COMM_ALT
    LDI maingpr0, 0b00000001
    STS PORTMUX_USARTROUTEA, maingpr0
    SBI VPORTB_DIR, 2
#else
    SBI VPORTA_DIR, 1
#endif
    LDI maingpr0, 0x00
    STS USART0_BAUDH, maingpr0
    LDI maingpr0, 0x50
    STS USART0_BAUDL, maingpr0
    LDI maingpr0, 0b10000000
    STS USART0_CTRLA, maingpr0
    LDI maingpr0, 0b11000010
    STS USART0_CTRLB, maingpr0
    LDI maingpr0, 0x03
    STS USART0_CTRLC, maingpr0
    LDI maingpr0, USART0_RXC_vect_num
    STS CPUINT_LVL1VEC, maingpr0
#endif
#endif
    SEI
mainloop:
    IN maingpr0, VPORTA_IN
    STS gpioina, maingpr0
    IN maingpr0, VPORTB_IN
    STS gpioinb, maingpr0
    IN maingpr0, VPORTC_IN
    STS gpioinc, maingpr0
	RJMP mainloop
.end