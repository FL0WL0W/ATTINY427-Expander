# ATTiny427 Expander
This project is to create a GPIO expander that takes and sends commands over UART connection. 
Up to 16 of these expanders can be daisy chained, only limited by the bandwidth of the maximum 2.5Mhz UART. 
This also adds 4 passthrough connection paths so that the ATTiny output buffers can be used.

# Commands
### Header
* 4: Command
* 4: Index
### 0x0 Setup
* 4: Index Assignment
* 1: PC5 -> PB7 passthrough
* 1: PC2 -> PC4 passthrough
* 1: PA0 -> PB4 passthrough
* 1: PB6 -> PA5 passthrough
* 1: PC4 -> PC2 passthrough
* 1: PA5 -> PB6 passthrough
* 4: ADC Decimation
* 15: Analog In x Enable
* 9: Digital Input Stream Period (1/32768s, 0=disabled)
* 6: PORTC Digital Input Enable
* 8: PORTB Digital Input Enable
* 8: PORTA Digital Input Enable
* 3: TCA0 CLK
* 3: TCA0 (Off,PW,RESERVED,RESERVED,OUTPUT,SENT_First,SENT_Second,SENT_First&Second)
* 2: TCA0 Input Port (PORTA, PORTB, PORTC, RESERVED)
* 8: TCA0 PinMask
* 3: TCB0 CLK
* 3: TCB0 (Off,PW,Frequency,PW&Frequency,OUTPUT,SENT_First,SENT_Second,SENT_First&Second)
* 2: TCB0 Input Port (PORTA, PORTB, PORTC, RESERVED)
* 8: TCB0 PinMask
* 3: TCB1 (Off,PW,Frequency,PW&Frequency,OUTPUT,SENT_First,SENT_Second,SENT_First&Second)
* 2: TCB1 Input Port (PORTA, PORTB, PORTC, RESERVED)
* 8: TCB1 PinMask
* 8: CRC
### 0x1 GPIO In Stream
* 8: INA
* 8: INB
* 8: INC
* 8: CRC
### 0x1 GPIO Out
* 8: OUTA
* 8: OUTB
* 8: OUTC
* 8: CRC
### 0x2 Analog In Stream
* 4: Length
* [12 + Log2(decimation+1)]: Analog Value x
* 8: CRC
### 0x3 TCA0 PulseWidth Out 0 <br/> 0x4 TCA0 PulseWidth Out 1 <br/> 0x5 TCA0 PulseWidth Out 2 <br/> 0x6 TCA0 PulseWidth In Stream <br/> 0x8 TCB0 PulseWidth In Stream <br/> 0xA TCB1 PulseWidth In Stream
* 16: Pulsewidth
* 8: CRC
### 0x6 TCA0 Frequency Out <br/> 0x8 TCB0 Frequency In Stream <br/> 0xA TCB1 Frequency In Stream
* 16: Frequency
* 8: CRC
### 0x6 TCA0 SENT In Stream (1 value) <br/> 0x8 TCB0 SENT In Stream (1 value) <br/> 0xA TCB1 SENT In Stream (1 value)
* 12: Value
* 4: Reserved
* 8: CRC
### 0x7 TCA0 SENT In Stream (2 values) <br/> 0x9 TCB0 SENT In Stream (2 values) <br/> 0xB TCB1 SENT In Stream (2 values)
* 12: Value1
* 12: Value2
* 8: CRC
### 0xC TCB0 Pulsewidth and Frequency In Stream <br/> 0xD TCB0 Pulsewidth and Frequency In Stream
* 16: Pulsewidth
* 16: Frequency
* 8: CRC
### 0x8 TCB0 Pulsewidth and Frequency OUT <br/> 0xA TCB1 Pulsewidth and Frequency OUT
* 8: Pulsewidth
* 8: Frequency
* 8: CRC

