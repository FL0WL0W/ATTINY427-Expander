# ATTiny427 Expander
This project is to create a GPIO expander that takes read and write commands over SPI.</br>
The maximum SPI frequency is 2.5mhz.

## Command Byte
* 1: Write bit 1 = write | 0 = read
* 1: Address size bit 1 = 8 bit address | 0 = 16 bit address
* 1: Address high bit set zero 1 = set address high to zero | 0 = reuse previous address high
* 5: read/write length

## Write Command
The address is also read out before it is written
```
        |        Write 3 bytes with 16 bit address        |             Write 2 bytes with 8 bit address              |
        |  0x83   |  0x--   |  0x--   |  0x--   |  0x--   |  0x--   |  0xC2   |  0x--   |  0x--   |  0x--   |  0x--   |
MOSI:   | Command | Address | Address |  Write  |  Write  |  Write  | Command | Address |  Write  |  Write  |   N/A   |   N/A   |
MISO:   |   N/A   |   N/A   |   N/A   |   N/A   |   N/A   |  Read   |  Read   |  Read   |   N/A   |   N/A   |  Read   |  Read   |
```

## Read Command
A command can be sent during the last pad byte of the read command
```
        |        Read 3 bytes with 16 bit address         |         Read 2 bytes with 8 bit address         |
        |  0x03   |  0x--   |  0x--   |  0x--   |  0x--   |  0x62   |  0x--   |  0x--   |  0x--   |  0x--   |
MOSI:   | Command | Address | Address |   N/A   |   N/A   | Command | Address |   N/A   |   N/A   |   N/A   |   N/A   |
MISO:   |   N/A   |   N/A   |   N/A   |   N/A   |   N/A   |  Read   |  Read   |  Read   |   N/A   |  Read   |  Read   |
```
## Analog Reader
To setup anlog pin reader. send this command
```
0xE3 //write 3 bytes to 8 bit address with high byte = 0
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
0xC3 //write 3 bytes to 8 bit address using existing high byte
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
0x81 //write 1 bytes to 8 bit address with high byte = 0
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
