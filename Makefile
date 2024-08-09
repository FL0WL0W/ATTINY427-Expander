TARGET = expander
# MCU name
MCU = attiny427

# List Assembler source files here.
SRC = expander.S

# Place -D or -U options here for ASM sources
DEFS =

#---------------- Linker Options ----------------
#  -Wl,...:     tell GCC to pass this to linker.
#    -Map:      create map file
#    --cref:    add cross reference to  map file
LDFLAGS = 
LDFLAGS += -Wl,-Tdata=0x803FA0
LDFLAGS += -Wl,--defsym=tcb0cnt=0x803e00
LDFLAGS += -Wl,--defsym=tcb0val=0x803e01
LDFLAGS += -Wl,--defsym=tcb1cnt=0x803e05
LDFLAGS += -Wl,--defsym=tcb1val=0x803e06
LDFLAGS += -Wl,--defsym=gpioina=0x803e0A
LDFLAGS += -Wl,--defsym=gpioinb=0x803e0B
LDFLAGS += -Wl,--defsym=gpioinc=0x803e0C
LDFLAGS += -Wl,--defsym=adccnt=0x803e0D
LDFLAGS += -Wl,--defsym=adcval=0x803e0E
LDFLAGS += -Wl,--defsym=tcb0buff=0x803e30
LDFLAGS += -Wl,--defsym=tcb1buff=0x803e34
LDFLAGS += -Wl,--defsym=adcbuff=0x803e3C

# Define programs and commands.
CC = avr-gcc
OBJCOPY = avr-objcopy
SIZE = avr-size
REMOVE = rm -f
REMOVEDIR = rm -rf

# Define Messages
# English
MSG_BEGIN = -------- begin --------
MSG_END = --------  end  --------
MSG_SIZE = Size:
MSG_FLASH = Creating load file for Flash:
MSG_LINKING = Linking:
MSG_ASSEMBLING = Assembling:
MSG_CLEANING = Cleaning project:

# Define all object files.
OBJ = $(SRC:%.S=./%.o) 

# Default target.
# all: uart0 uart0alt uart1 uart1alt spi spialt
all: begin build size end

# spi: $(eval TARGET = expander_spi)
# spialt:  $(eval TARGET = expander_spi_alt)
# uart0:  $(eval TARGET = expander_uart0)
# uart0alt:  $(eval TARGET = expander_uart0_alt)
# uart1: $(eval TARGET = expander_uart1)
# uart1alt: $(eval TARGET = expander_uart1alt)
# build
build: elf bin 

elf: $(TARGET).elf
bin: $(TARGET).bin

begin:
	@echo $(MSG_BEGIN)

end:
	@echo $(MSG_END)


# Display size of file
UART0SIZE = $(SIZE) --mcu=$(MCU) --format=avr uart0_$(TARGET).elf
UART0ALTSIZE = $(SIZE) --mcu=$(MCU) --format=avr uart0_alt_$(TARGET).elf
UART1SIZE = $(SIZE) --mcu=$(MCU) --format=avr uart1_$(TARGET).elf
UART1ALTSIZE = $(SIZE) --mcu=$(MCU) --format=avr uart1_alt_$(TARGET).elf
SPISIZE = $(SIZE) --mcu=$(MCU) --format=avr spi_$(TARGET).elf
SPIALTSIZE = $(SIZE) --mcu=$(MCU) --format=avr spi_alt_$(TARGET).elf

size:
	@if test -f uart0_$(TARGET).elf; then echo $(MSG_SIZE) uart0; $(UART0SIZE); fi
	@if test -f uart0_alt_$(TARGET).elf; then echo $(MSG_SIZE) uart0_alt; $(UART0ALTSIZE); fi
	@if test -f uart1_$(TARGET).elf; then echo $(MSG_SIZE) uart1; $(UART1SIZE); fi
	@if test -f uart1_alt_$(TARGET).elf; then echo $(MSG_SIZE) uart1_alt; $(UART1ALTSIZE); fi
	@if test -f spi_$(TARGET).elf; then echo $(MSG_SIZE) spi; $(SPISIZE); fi
	@if test -f spi_alt_$(TARGET).elf; then echo $(MSG_SIZE) spi_alt; $(SPIALTSIZE); fi

flash: $(TARGET).bin
	@curl --data-binary @$(TARGET).bin http://192.168.4.1/upload/attiny/1


# Create final output files (.bin) from ELF output file.
%.bin: %.elf
	@echo
	@echo $(MSG_FLASH) $@
	$(OBJCOPY) -O binary -R .eeprom -R .fuse -R .lock -R .signature uart0_$< uart0_$@
	$(OBJCOPY) -O binary -R .eeprom -R .fuse -R .lock -R .signature uart0_alt_$< uart0_alt_$@
	$(OBJCOPY) -O binary -R .eeprom -R .fuse -R .lock -R .signature uart1_$< uart1_$@
	$(OBJCOPY) -O binary -R .eeprom -R .fuse -R .lock -R .signature uart1_alt_$< uart1_alt_$@
	$(OBJCOPY) -O binary -R .eeprom -R .fuse -R .lock -R .signature spi_$< spi_$@
	$(OBJCOPY) -O binary -R .eeprom -R .fuse -R .lock -R .signature spi_alt_$< spi_alt_$@

# Link: create ELF output file from object files.
.SECONDARY : $(TARGET).elf
.PRECIOUS : $(OBJ)
%.elf: $(OBJ)
	@echo
	@echo $(MSG_LINKING) $@
	$(CC) -mmcu=$(MCU) uart0_$^ --output uart0_$@ -Wl,-Map=uart0_$(TARGET).map,--cref $(LDFLAGS)
	$(CC) -mmcu=$(MCU) uart0_alt_$^ --output uart0_alt_$@ -Wl,-Map=uart0_alt_$(TARGET).map,--cref $(LDFLAGS)
	$(CC) -mmcu=$(MCU) uart1_$^ --output uart1_$@ -Wl,-Map=uart1_$(TARGET).map,--cref $(LDFLAGS)
	$(CC) -mmcu=$(MCU) uart1_alt_$^ --output uart1_alt_$@ -Wl,-Map=uart1_alt_$(TARGET).map,--cref $(LDFLAGS)
	$(CC) -mmcu=$(MCU) spi_$^ --output spi_$@ -Wl,-Map=spi_$(TARGET).map,--cref $(LDFLAGS)
	$(CC) -mmcu=$(MCU) spi_alt_$^ --output spi_alt_$@ -Wl,-Map=spi_alt_$(TARGET).map,--cref $(LDFLAGS)


# Assemble: create object files from assembler source files.
./%.o : %.S
	@echo
	@echo $(MSG_ASSEMBLING) $<
	$(CC) -c -mmcu=$(MCU) -I. -x assembler-with-cpp $(DEFS) $< -o uart0_$@
	$(CC) -c -mmcu=$(MCU) -I. -x assembler-with-cpp $(DEFS) -DCOMM_ALT $< -o uart0_alt_$@
	$(CC) -c -mmcu=$(MCU) -I. -x assembler-with-cpp $(DEFS) -DCOMM_USART1 $< -o uart1_$@
	$(CC) -c -mmcu=$(MCU) -I. -x assembler-with-cpp $(DEFS) -DCOMM_USART1 -DCOMM_ALT $< -o uart1_alt_$@
	$(CC) -c -mmcu=$(MCU) -I. -x assembler-with-cpp $(DEFS) -DCOMM_SPI $< -o spi_$@
	$(CC) -c -mmcu=$(MCU) -I. -x assembler-with-cpp $(DEFS) -DCOMM_SPI -DCOMM_ALT $< -o spi_alt_$@

# Target: clean project.
clean: begin clean_list end

clean_list :
	@echo
	@echo $(MSG_CLEANING)
	$(REMOVE) uart0_$(TARGET).elf
	$(REMOVE) uart0_$(TARGET).map
	$(REMOVE) $(SRC:%.S=./uart0_%.o)
	$(REMOVE) uart0_alt_$(TARGET).elf
	$(REMOVE) uart0_alt_$(TARGET).map
	$(REMOVE) $(SRC:%.S=./uart0_alt_%.o)
	$(REMOVE) uart1_$(TARGET).elf
	$(REMOVE) uart1_$(TARGET).map
	$(REMOVE) $(SRC:%.S=./uart1_%.o)
	$(REMOVE) uart1_alt_$(TARGET).elf
	$(REMOVE) uart1_alt_$(TARGET).map
	$(REMOVE) $(SRC:%.S=./uart1_alt_%.o)
	$(REMOVE) spi_$(TARGET).elf
	$(REMOVE) spi_$(TARGET).map
	$(REMOVE) $(SRC:%.S=./spi_%.o)
	$(REMOVE) spi_alt_$(TARGET).elf
	$(REMOVE) spi_alt_$(TARGET).map
	$(REMOVE) $(SRC:%.S=./spi_alt_%.o)
	$(REMOVEDIR) .dep
	@echo

# Listing of phony targets.
.PHONY : all begin finish end sizebefore sizeafter \
build elf bin \
clean clean_list program gdb-config chain
