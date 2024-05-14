#include <avr/io.h>
 
#define analogenable0 GPIO_GPIOR0
#define analogenable1 GPIO_GPIOR1
#define analogaccumulate GPIO_GPIOR2
#define zero r2
#define spiSREG r3
#define spistate r16
#define spilen r17
#define spigpr r18
#define adcSREG r4
#define adcacc r5
#define adcstate r19
#define adcgpr0 r20
#define adcgpr1 r21
#define adcgpr2 r23
#define maingpr r24

.data
tcb1val:
    .short 0
    .short 0
tcb0val:
    .short 0
    .short 0
gpioina:
    .byte 0
gpioinb:
    .byte 0
gpioinc:
    .byte 0
adccnt:
    .byte 0
adcval:
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
adcbuff:
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0
    .short 0

.text
.global SPI0_INT_vect
SPI0_INT_vect:
    IN spiSREG, CPU_SREG
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
    OUT CPU_SREG, spiSREG
    RETI

SPIWRITE:
    LD spigpr, X
    STS SPI0_DATA, spigpr
    LDS spigpr, SPI0_DATA
    ST X+, spigpr
    DEC spilen
    OUT CPU_SREG, spiSREG
    RETI

SPIREADLEN:
    LDS spilen, SPI0_DATA
    MOV spistate, spilen
    ANDI spilen, 0b00011111
    ANDI spistate, 0b11100000
    OUT CPU_SREG, spiSREG
    RETI

SPIREADLENECHO:
    LDS spilen, SPI0_DATA
    STS SPI0_DATA, spilen
    MOV spistate, spilen
    ANDI spilen, 0b00011111
    ANDI spistate, 0b11100000
    OUT CPU_SREG, spiSREG
    RETI

SPIREADADDR:
    SBRS spistate, 6
    RJMP SPIREADADDRH
    SBRC spistate, 5
    MOV XH, zero
    LDS XL, SPI0_DATA
    STS SPI0_DATA, XL
    ORI spistate, 0b00010000
    OUT CPU_SREG, spiSREG
    RETI

SPIREADADDRH:
    LDS XH, SPI0_DATA
    STS SPI0_DATA, XH
    ORI spistate, 0b01000000
    OUT CPU_SREG, spiSREG
    RETI

.global ADC0_RESRDY_vect
ADC0_RESRDY_vect:
    IN adcSREG, CPU_SREG
    LDS adcgpr0, ADC0_MUXPOS
    ; * (2+2)
    LSL adcgpr0
    LDI ZH, hi8(gs(ADC0SETSAMPLE))
    LDI ZL, lo8(gs(ADC0SETSAMPLE))
    ADD ZL, adcgpr0
    ADC ZH, zero
    IJMP
ADC0SETSAMPLE:
#if !defined(SPI_ALT)
ADC0SETSAMPLEBEGIN:
#endif
    SBIC analogenable0, 1
    RJMP ADC0SETSAMPLE1
    SBIC analogenable0, 2
    RJMP ADC0SETSAMPLE2
    SBIC analogenable0, 3
    RJMP ADC0SETSAMPLE3
    SBIC analogenable0, 4
    RJMP ADC0SETSAMPLE4
#if defined(SPI_ALT)
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
#endif
    ORI adcstate, 0b10000000
    IN adcgpr1, analogaccumulate
    MOV adcgpr2, adcacc
    INC adcacc
    CPSE adcgpr1, adcgpr2
    RJMP ADC0SETSAMPLEBEGIN
    MOV adcacc, zero
    RJMP ADC0SETSAMPLEBEGIN
ADC0SETSAMPLE1:
    LDI adcgpr0, 1
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE2:
    LDI adcgpr0, 2
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE3:
    LDI adcgpr0, 3
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE4:
    LDI adcgpr0, 4
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE5:
    LDI adcgpr0, 5
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE6:
    LDI adcgpr0, 6
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE7:
    LDI adcgpr0, 7
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE8:
    LDI adcgpr0, 8
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE9:
    LDI adcgpr0, 9
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE10:
    LDI adcgpr0, 10
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE11:
    LDI adcgpr0, 11
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE12:
    LDI adcgpr0, 12
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE13:
    LDI adcgpr0, 13
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE14:
    LDI adcgpr0, 14
    RJMP ADC0STARTSAMPLE
ADC0SETSAMPLE15:
    LDI adcgpr0, 15

ADC0STARTSAMPLE:
    ; r0/r1 = (adcstate & 0x0F) * 17
    MOV adcgpr1, adcstate
    ANDI adcgpr1, 0x0F
    LDI adcgpr2, 17
    MUL adcgpr2, adcgpr1

    STS ADC0_MUXPOS, adcgpr0
    LDS adcgpr0, ADC0_RESULT0
    LDS adcgpr1, ADC0_RESULT1
    LDI adcgpr2, 0b00010001
    STS ADC0_COMMAND, adcgpr2

    ; Z = adcbuff
    LDI ZH, hi8(adcbuff)
    LDI ZL, lo8(adcbuff)
    ; Z + r0/r1
    ADD ZL, r0
    ADC ZH, r1
    ; Z + adcacc * 2
    MOV adcgpr2, adcacc
    ANDI adcgpr2, 0b0001111
    LSL adcgpr2
    ADD ZL, adcgpr2
    ADC ZH, zero

    ; load, store and subtract
    LD adcgpr2, Z
    ST Z, adcgpr0
    SUB adcgpr0, adcgpr2
    LDD adcgpr2, Z+1
    STD Z+1, adcgpr1
    SBC adcgpr1, adcgpr2

    ; Z = adcval
    LDI ZH, hi8(adcval)
    LDI ZL, lo8(adcval)
    ADD ZL, adcstate
    ADC ZH, zero

    ; load and add
    LD adcgpr2, Z
    ADD adcgpr0, adcgpr2
    LDD adcgpr2, Z+1
    ADC adcgpr1, adcgpr2

    ; ensure spi is not transferring this section of memory
ADC0LOWCHECK:
    SEI
    CLI
    CP ZL, XL
    CPC ZH, XH
    CPSE spilen, zero
    BREQ ADC0LOWCHECK
    ST Z+, adcgpr0
    SEI
ADC0HIGHCHECK:
    SEI
    CLI
    CP ZL, XL
    CPC ZH, XH
    CPSE spilen, zero
    BREQ ADC0HIGHCHECK
    ST Z, adcgpr1
    SEI

    LDS adcgpr0, adccnt
    INC adcgpr0
    STS adccnt, adcgpr0

    INC adcstate
    INC adcstate

    SBRC adcstate, 7
    MOV adcstate, zero

    OUT CPU_SREG, adcSREG
    RETI

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
    LDI maingpr, 0b00000010
    STS PORTC_DIRSET, maingpr
#else
    LDI maingpr, 0b00000100
    STS PORTA_DIRSET, maingpr
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