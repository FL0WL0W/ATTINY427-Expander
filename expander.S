#include <avr/io.h>
 
#define analogenable0 GPIO_GPIOR0
#define analogenable1 GPIO_GPIOR1
#define zero r0
#define spiSREG r1
#define spistate r16
#define spilen r17
#define spigpr r18
#define adcSREG r2
#define adcacc r3
#define adcstate r5
#define adcgpr0 r19
#define adcgpr1 r20
#define adcgpr2 r21
#define maingpr r22

.data
tcb1val:
    .short 0
    .short 0
tcb0val:
    .short 0
    .short 0
gpioina:
    .byte
gpioinb:
    .byte
gpioinc:
    .byte
adccnt:
    .byte
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

.text
.global SPI0_INT_vect
SPI0_INT_vect:
    IN spiSREG, CPU_SREG
    CP spilen, zero
    BREQ SPIREADLEN
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

SPIREADADDR:
    SBRS spistate, 5
    RJMP SPIREADADDRH
    SBRC spistate, 6
    MOV XH, zero
    LDS XL, SPI0_DATA
    ORI spistate, 0b00010000
    OUT CPU_SREG, spiSREG
    RETI

SPIREADADDRH:
    LDS XH, SPI0_DATA
    ORI spistate, 0b00100000
    OUT CPU_SREG, spiSREG
    RETI

.global ADC0_SAMPRDY_vect
ADC0_SAMPRDY_vect:
    IN adcSREG, CPU_SREG
    LDS adcgpr0, ADC0_MUXPOS
    ; * (2+2)
    LSL adcgpr0
    LSL adcgpr0
    LDI ZL, lo8(ADC0SETSAMPLE)
    LDI ZH, hi8(ADC0SETSAMPLE)
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
#if defined(SPI_ALT)
ADC0SETSAMPLEBEGIN:
#endif
    RJMP ADC0SETSAMPLE4
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
    MOV adcstate, zero
    INC adcacc
    MOV adcgpr1, adcacc
    MOV adcgpr2, adcacc
    SWAP adcgpr2
    ANDI adcgpr1, 0b11110000
    ANDI adcgpr2, 0b11110000
    CPSE adcgpr1, adcgpr2
    RJMP ADC0SETSAMPLEBEGIN
    MOV adcacc, adcgpr1
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
    STS ADC0_MUXPOS, adcgpr0
    LDS adcgpr0, ADC0_RESULT0
    LDS adcgpr1, ADC0_RESULT1
    LDI adcgpr2, 0b00010001
    STS ADC0_COMMAND, adcgpr2

    ; Z = adcbuff
    LDI ZL, lo8(adcbuff)
    LDI ZH, hi8(adcbuff)
    ADD ZL, adcgpr2
    ADC ZH, zero
    ; Z + adcstate * 16
    LDI adcgpr2, 16
    MUL adcgpr2, adcstate
    ADC ZH, zero
    ADD ZL, adcgpr2
    ADC ZH, zero
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
    LDI ZL, lo8(adcval)
    LDI ZH, hi8(adcval)
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
    RETI

.global main
main:
    ; initialize zero and states
    LDI maingpr, 0
    MOV zero, maingpr
    MOV adcstate, zero
    MOV spilen, zero
    MOV spistate, zero
    ; initialize SPI
#if defined(SPI_ALT)
    LDI maingpr, 0b00000001
    STS PORTMUX_SPIROUTEA, maingpr
#endif
    LDI maingpr, 0b00000001
    STS SPI0_CTRLA, maingpr
    LDI maingpr, 0b00000000
    STS SPI0_CTRLB, maingpr
    LDI maingpr, 0b10000001
    STS SPI0_INTCTRL, maingpr
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