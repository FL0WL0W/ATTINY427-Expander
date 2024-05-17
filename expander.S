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
#define lvl1gpr r20
;register used for general purpose in lvl1 interrupt

#define lvl0SREG r4
;register used to store SREG during lvl0 interrupt
#define lvl0gpr0 r16
#define lvl0gpr1 r17
#define lvl0gpr2 r18
#define lvl0gpr3 r19
;registers used for general purpose in lvl0 interrupt

#define spistate r21
; bit 4 read address
; bit 5 set address high to 0
; bit 6 read address low
; bit 7 write
#define spilen r22
; length left to be read for reading/writing. 0-31

#define adcstate r23
; bits 0-3 is the current ADC index. 
; bit 7 is to clear index at end of this read.
; bit 6 is to clear the accumulate
#define adcacc r5
; accumulate 0-15

#define maingpr r24

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
    LD lvl1gpr, X+
    STS SPI0_DATA, lvl1gpr
    DEC spilen
    CP spilen, zero
    BREQ SPIREADLEN
    LDS lvl1gpr, SPI0_DATA
    OUT CPU_SREG, lvl1SREG
    RETI

SPIWRITE:
    LD lvl1gpr, X
    STS SPI0_DATA, lvl1gpr
    LDS lvl1gpr, SPI0_DATA
    ST X+, lvl1gpr
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
    LDS lvl0gpr3, ADC0_MUXPOS
    ; * (2+2)
    LSL lvl0gpr3
    LDI ZH, hi8(gs(ADC0SETSAMPLE))
    LDI ZL, lo8(gs(ADC0SETSAMPLE))
    ADD ZL, lvl0gpr3
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
    ORI adcstate, 0b10000000
    IN lvl0gpr0, analogaccumulate
    ANDI lvl0gpr0, 0b00001111
    MOV ZL, adcacc
    INC adcacc
    CPSE lvl0gpr0, ZL
    RJMP ADC0SETSAMPLEBEGIN
    MOV adcacc, zero
    RJMP ADC0SETSAMPLEBEGIN
ADC0SETSAMPLE1:
    LDI lvl0gpr0, 1
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE2:
    LDI lvl0gpr0, 2
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE3:
    LDI lvl0gpr0, 3
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE4:
    LDI lvl0gpr0, 4
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE5:
    LDI lvl0gpr0, 5
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE6:
    LDI lvl0gpr0, 6
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE7:
    LDI lvl0gpr0, 7
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE8:
    LDI lvl0gpr0, 8
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE9:
    LDI lvl0gpr0, 9
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE10:
    LDI lvl0gpr0, 10
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE11:
    LDI lvl0gpr0, 11
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE12:
    LDI lvl0gpr0, 12
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE13:
    LDI lvl0gpr0, 13
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE14:
    LDI lvl0gpr0, 14
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE15:
    LDI lvl0gpr0, 15

ADC0STARTSAMPLE:
    STS ADC0_MUXPOS, lvl0gpr0
    LDS lvl0gpr0, ADC0_RESULT0
    LDS lvl0gpr1, ADC0_RESULT1
    LDI lvl0gpr2, 0b00010001
    STS ADC0_COMMAND, lvl0gpr2

    ; check and make sure current reading is enabled
    LDI lvl0gpr2, 0b00000001
    SBRC lvl0gpr3, 2
    LDI lvl0gpr2, 0b00000100
    SBRC lvl0gpr3, 3
    SWAP lvl0gpr2
    SBRC lvl0gpr3, 1
    LSL lvl0gpr2
    BST lvl0gpr3, 4
    IN lvl0gpr3, analogenable0
    BRTC ADC0CHECKENABLE
    IN lvl0gpr3, analogenable1
ADC0CHECKENABLE:
    AND lvl0gpr3, lvl0gpr2
    BRNE ADC0PASSCHECKENABLED
    OUT CPU_SREG, lvl0SREG
    RETI

ADC0PASSCHECKENABLED:
    ; Z = adcbuff
    LDI ZH, hi8(adcbuff)
    LDI ZL, lo8(adcbuff)
    ; Z += (adcstate & 0x0F) * 32
    MOV lvl0gpr2, adcstate
    ANDI lvl0gpr2, 0x0F
    SWAP lvl0gpr2 ; * 16
    LSL lvl0gpr2 ; * 2
    ADD ZL, lvl0gpr2
    ADC ZH, zero
    ; check if we need to clear accumulate
    SBRC adcstate, 6
    RJMP ADC0CLEARACCUMULATE
    ; Z + adcacc * 2
    MOV lvl0gpr2, adcacc
    ANDI lvl0gpr2, 0b00001111
    LSL lvl0gpr2
    ADC ZH, zero
    ADD ZL, lvl0gpr2
    ADC ZH, zero

    ; load, store and subtract
    LD lvl0gpr2, Z
    LDD lvl0gpr3, Z+1
    ST Z, lvl0gpr0
    STD Z+1, lvl0gpr1
    SUB lvl0gpr0, lvl0gpr2
    SBC lvl0gpr1, lvl0gpr3

    ; Z = adcval + (adcstate & 0x0F) * 2
    LDI ZH, hi8(adcval)
    LDI ZL, lo8(adcval)
    MOV lvl0gpr2, adcstate
    ANDI lvl0gpr2, 0x0F
    LSL lvl0gpr2 ; * 2
    ADD ZL, lvl0gpr2
    ADC ZH, zero

    ; load and add
    LD lvl0gpr2, Z
    LDD lvl0gpr3, Z+1
    ADD lvl0gpr0, lvl0gpr2
    ADC lvl0gpr1, lvl0gpr3

ADC0CLEARACCUMULATERETURN:
    ; ensure spi is not transferring this section of memory
ADC0LOWCHECK:
    SEI
    CLI
    CP ZL, XL
    CPC ZH, XH
    CPSE spilen, zero
    BREQ ADC0LOWCHECK
    ST Z+, lvl0gpr0
    SEI
ADC0HIGHCHECK:
    SEI
    CLI
    CP ZL, XL
    CPC ZH, XH
    CPSE spilen, zero
    BREQ ADC0HIGHCHECK
    ST Z, lvl0gpr1
    SEI

    LDS lvl0gpr0, adccnt
    INC lvl0gpr0
    STS adccnt, lvl0gpr0

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
    ORI adcstate, 0b01000000
    MOV adcacc, zero

ADC0RETURN:
    OUT CPU_SREG, lvl0SREG
    RETI

ADC0CLEARACCUMULATE:
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ST Z+, lvl0gpr0
    ST Z+, lvl0gpr1
    ; lvl0gpr0/1 *= analogaccumulate + 1
    IN lvl0gpr2, analogaccumulate
    ANDI lvl0gpr2, 0b00001111
    INC lvl0gpr2
    MUL lvl0gpr1, lvl0gpr2
    MOV lvl0gpr3, r0
    MUL lvl0gpr0, lvl0gpr2
    ADD r1, lvl0gpr3
    MOVW lvl0gpr0, r0
    ; Z = adcval + (adcstate & 0x0F) * 2
    LDI ZH, hi8(adcval)
    LDI ZL, lo8(adcval)
    MOV lvl0gpr2, adcstate
    ANDI lvl0gpr2, 0x0F
    LSL lvl0gpr2 ; * 2
    ADD ZL, lvl0gpr2
    ADC ZH, zero
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