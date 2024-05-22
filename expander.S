#include <avr/io.h>
 
#define analogenable0 GPIO_GPIOR0
; bits 0-7 -> AIN Enable 0-7

#define analogenable1 GPIO_GPIOR1
; bits 8-15 -> AIN Enable 8-15

#define analogaccumulate GPIO_GPIOR2
; bits 0-3 accumulate count
; bit 7 clear accumulate. should be written whenever changing accumulate count or changing analog enables

#define zero r2
;register always containing zero

#define lvl1SREG r3
;register used to store SREG during lvl1 interrupt
#define lvl0SREG r4
;register used to store SREG during lvl0 interrupt

#define spigpr r5
;register used for general purpose in spi interrupt
#define spistate r16
; bit 4 read address
; bit 5 set address high to 0
; bit 6 read address low
; bit 7 write
#define spilen r17
; length left to be read for reading/writing. 0-31

;registers used for general purpose in adc interrupt
#define adcacc r6
; accumulate 0-15
#define adcstate r7
; bits 0-3 is the current ADC index. 
; bit 7 is to clear index at end of this read.
; bit 6 is to clear the accumulate
#define adcvalreg0 r8
#define adcvalreg1 r9
#define adcgpr r10

#define maingpr r18

.data
.comm tcb0val, 4
.comm tcb1val, 4
.comm gpioina, 1
.comm gpioinb, 1
.comm gpioinc, 1
.comm adccnt, 1
.comm adcval, 11 * 2
.comm adcbuff, 11 * 16 * 2

.text
.global SPI0_INT_vect
SPI0_INT_vect:
    IN lvl1SREG, CPU_SREG
    CP spilen, zero
    BREQ SPIREADLENECHO
    SBRS spistate, 4
    RJMP SPIREADADDR
    SBRC spistate, 7
    RJMP SPIWRITE
SPIREAD:
    LD spigpr, X+
    STS SPI0_DATA, spigpr
    DEC spilen
    CP spilen, zero
    BREQ SPIREADLEN
    LDS spigpr, SPI0_DATA
    OUT CPU_SREG, lvl1SREG
    RETI

SPIWRITE:
    LD spigpr, X
    STS SPI0_DATA, spigpr
    LDS spigpr, SPI0_DATA
    ST X+, spigpr
    DEC spilen
    OUT CPU_SREG, lvl1SREG
    RETI

SPIREADLEN:
    LDS spilen, SPI0_DATA
    MOV spistate, spilen
    ANDI spilen, 0b00011111
    ANDI spistate, 0b11100000
    OUT CPU_SREG, lvl1SREG
    RETI

SPIREADLENECHO:
    LDS spilen, SPI0_DATA
    STS SPI0_DATA, spilen
    MOV spistate, spilen
    ANDI spilen, 0b00011111
    ANDI spistate, 0b11100000
    OUT CPU_SREG, lvl1SREG
    RETI

SPIREADADDR:
    SBRS spistate, 6
    RJMP SPIREADADDRH
    SBRC spistate, 5
    MOV XH, zero
    LDS XL, SPI0_DATA
    STS SPI0_DATA, XL
    ORI spistate, 0b00010000
    OUT CPU_SREG, lvl1SREG
    RETI

SPIREADADDRH:
    LDS XH, SPI0_DATA
    STS SPI0_DATA, XH
    ORI spistate, 0b01000000
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
#if !defined(SPI_ALT)
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
#if !defined(SPI_ALT)
    SBIC analogenable1, 4
    RJMP ADC0SETSAMPLE12
    SBIC analogenable1, 5
    RJMP ADC0SETSAMPLE13
    SBIC analogenable1, 6
    RJMP ADC0SETSAMPLE14
    SBIC analogenable1, 7
    RJMP ADC0SETSAMPLE15
#else
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
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
    MOV adcacc, zero
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
    ADIW ZL, 0x30; lo8(adcbuff) for some reason compiler complains using lo8
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
    ADIW ZL, 0x0C; lo8(adcval) for some reason compiler complains using lo8

    ; load and add
    LD adcgpr, Z
    ADD adcvalreg0, adcgpr
    LDD adcgpr, Z+1
    ADC adcvalreg1, adcgpr

ADC0CLEARACCUMULATERETURN:
    ; ensure spi is not transferring this section of memory
ADC0LOWCHECK:
    SEI
    CLI
    CP ZL, XL
    CPC ZH, XH
    CPSE spilen, zero
    BREQ ADC0LOWCHECK
    ST Z+, adcvalreg0
    SEI
ADC0HIGHCHECK:
    SEI
    CLI
    CP ZL, XL
    CPC ZH, XH
    CPSE spilen, zero
    BREQ ADC0HIGHCHECK
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
    MOV adcstate, zero
    ; set adcstate to clear accumulate
    SBIS analogaccumulate, 7
    RJMP ADC0RETURN
    LDI ZL, 0b01000000
    OR adcstate, ZL
    MOV adcacc, zero

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
    PUSH r0
    PUSH r1
    IN ZH, analogaccumulate
    ANDI ZH, 0b00001111
    INC ZH
    MUL adcvalreg1, ZH
    MOV ZL, r0
    MUL adcvalreg0, ZH
    ADD r1, ZL
    MOVW adcvalreg0, r0
    POP r1
    POP r0
    ; Z = adcval + (adcstate & 0x0F) * 2
    LDI ZH, hi8(adcval)
    MOV ZL, adcstate
    ANDI ZL, 0x0F
    LSL ZL ; * 2
    ADIW ZL, 0x0C; lo8(adcval) for some reason compiler complains using lo8
    RJMP ADC0CLEARACCUMULATERETURN

.global main
main:
    ; initialize zero and states
    LDI maingpr, 0
    MOV zero, maingpr
    MOV adcstate, zero
    MOV spilen, zero
    MOV spistate, zero
    ; initialize clock
    LDI maingpr, 0xD8
    OUT CCP, maingpr
    STS CLKCTRL_MCLKCTRLB, zero
    ; initialize SPI
#if defined(SPI_ALT)
    LDI maingpr, 0b00000001
    STS PORTMUX_SPIROUTEA, maingpr
    SBI VPORTC_DIR, 1
#else
    SBI VPORTA_DIR, 2
#endif
    LDI maingpr, 0b00000001
    STS SPI0_CTRLA, maingpr
    LDI maingpr, 0b10000000
    STS SPI0_CTRLB, maingpr
    STS SPI0_INTCTRL, maingpr
    LDI maingpr, SPI0_INT_vect_num
    STS CPUINT_LVL1VEC, maingpr
    SEI
mainloop:
    IN maingpr, VPORTA_IN
    STS gpioina, maingpr
    IN maingpr, VPORTB_IN
    STS gpioinb, maingpr
    IN maingpr, VPORTC_IN
    STS gpioinc, maingpr
	RJMP mainloop
.end