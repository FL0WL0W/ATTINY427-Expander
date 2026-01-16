# ATTiny427 Expander
This project is to create a GPIO expander that takes read and write commands over SPI or UART.</br>
The maximum SPI frequency is 2.5mhz.
Default UART BAUDRATE is 2mhz.

## Command Byte
* 1: Write bit 1 = write | 0 = read
* 1: Continue previous operation for {length} more bytes (read/write length can use the next 6 bits)
* 1: Address size bit 1 = 8 bit address | 0 = 16 bit address
* 1: Address high bit set zero 1 = set address high to zero | 0 = reuse previous address high
* 4: read/write length

## Write Command
The bytes returned will always be unrelated to a write command
```
           |        Write 3 bytes with 16 bit address        |        Write 2 bytes with 8 bit address         |
           |  0x83   |  0x--   |  0x--   |  0x--   |  0x--   |  0x--   |  0xA2   |  0x--   |  0x--   |  0x--   |
MASTER:    | Command | Address | Address |  Write  |  Write  |  Write  | Command | Address |  Write  |  Write  |
ATTINY:    |   N/A   |   N/A   |   N/A   |   N/A   |   N/A   |   N/A   |   N/A   |   N/A   |   N/A   |   N/A   |
```

## Read Command
If a current read command is not being read out, the command/address will be echoed out
A read command can be sent at any time. the new read command will interrupt the previous command after the last command/address byte.
A write command can also be sent while reading and will not interrupt the read.
```
           |     Read 3 bytes with 16 bit address       |  Read 2 bytes with 8 bit address |
           |  0x03   |  0x--   |  0x--   |  0x00   |  0x32   |  0x--   |  0x00   |  0x00   |  0x00   |  0x00   |
MASTER:    | Command | Address | Address |  0x00   | Command | Address |  0x00   |  0x00   |  0x00   |  0x00   |
MISO:      |   N/A   |   N/A   | Command | Address | Address |  Read0  |  Read1  |  Read2  |  Read0  |  Read1  |
ATTINYUART:| Command | Address | Address |  Read0  |  Read1  |  Read2  |  Read0  |  Read1  |  0x00   |  0x00   |
```
## Analog Reader
To setup anlog pin reader. send this command
```
0xB3 //write 3 bytes to 8 bit address with high byte = 0
0x1C //address low
0xE0 //enable analog pins 5-7
0x01 //analog enable pins 8, 10-15
0x8F //analog accumulate to 16 bits and reset accumulator
```
Setup and start the ADC (See ATTiny427 datasheet for more information)
```
0x85 //write 5 bytes to 16 bit address
0x06 //address high
0x00 //address low
0b00100001; // enable ADC with low latency
0x01 // prescaler DIV4 to get ADCCLK 5MHZ
0xA0 // set timebase and VDD as reference
0x00 // no window source mode
0x01 //enable RESRDY intterupt
0xA3 //write 3 bytes to 8 bit address using existing high byte
0x08 //address low
0x05 //SAMPDUR = 5. this give a sample duration of 4us
0x00 //no accumulation, accumulation done in software so the readings are evenly spaced
0x11 //single 12 bit mode and start
```
Read the result at address 0x340E. There is also a rolling sample counter at 0x340D
## PWM Reader
Results for Timer B capture interrupts are stored here
```
0x3400 TCB0_Count
0x3401 TCB0_CNT
0x3403 TCB0_CCMP
0x3405 TCB1_Count
0x3406 TCB1_CNT
0x3408 TCB1_CCMP
```
Refer to datasheet for how to setup Timer B
## SENT Reader
Timer B can be setup to parse incoming SENT data from a sensor
To setup SENT pin reader. send this command
```
0xB1 //write 1 bytes to 8 bit address with high byte = 0
0x1E //address low
0x60 //This is shared with AnalogAccumulate register. bit 5 and 6 are the SENT decoder enabled for Timer B 0 and 1 respectively
     //Care should be taken to not overwrite any of the analog enable bits.
```
Results are stored here 
```
0x3400 TCB0_Count
0x3401 TCB0_SENT
0x3405 TCB1_Count
0x3406 TCB1_SENT
```
## Troubleshooting
### No response
If writing to the PORT_DIR register. make sure the MISO line is set as output. MISO is PA2 or PC1 if using alternate SPI
