# ATTiny427 Expander
This project is to create a GPIO expander that takes read and write commands over SPI.

### Command Byte
* 1: Write bit 1 = write | 0 = read
* 1: Address size bit 1 = 8 bit address | 0 = 16 bit address
* 1: Address high bit set zero 1 = set address high to zero | 0 = reuse previous address high
* 5: read/write length

### Write Command
The address is also read out before it is written
        |        Write 3 bytes with 16 bit address        |             Write 2 bytes with 8 bit address              |
        |  0x83   |  0x--   |  0x--   |  0x--   |  0x--   |  0x--   |  0xC2   |  0x--   |  0x--   |  0x--   |  0x--   |
Write:  | Command | Address | Address |  Write  |  Write  |  Write  | Command | Address |  Write  |  Write  |   N/A   |
Read:   |   N/A   |   N/A   |   N/A   |   N/A   |  Read   |  Read   |  Read   |   N/A   |   N/A   |  Read   |  Read   |

### Read Command
A command can be sent during the last pad byte of the read command
        |        Read 3 bytes with 16 bit address         |         Read 2 bytes with 8 bit address         |
        |  0x03   |  0x--   |  0x--   |  0x--   |  0x--   |  0x62   |  0x--   |  0x--   |  0x--   |  0x--   |
Write:  | Command | Address | Address |   N/A   |   N/A   | Command | Address |   N/A   |   N/A   |   N/A   |
Read:   |   N/A   |   N/A   |   N/A   |   N/A   |  Read   |  Read   |  Read   |   N/A   |  Read   |  Read   |
