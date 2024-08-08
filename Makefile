# MCU name
MCU = attiny427

# Target file name (without extension).
TARGET = expander

# List Assembler source files here.
SRC = expander.S

# Place -D or -U options here for ASM sources
DEFS = 

#---------------- Linker Options ----------------
#  -Wl,...:     tell GCC to pass this to linker.
#    -Map:      create map file
#    --cref:    add cross reference to  map file
LDFLAGS = -Wl,-Map=$(TARGET).map,--cref
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

# Define all listing files.
LST = $(SRC:%.S=./%.lst) 

# Default target.
all: begin build size end

# build
build: elf bin 

elf: $(TARGET).elf
bin: $(TARGET).bin
LIBNAME=lib$(TARGET).a
lib: $(LIBNAME)

begin:
	@echo $(MSG_BEGIN)

end:
	@echo $(MSG_END)


# Display size of file
ELFSIZE = $(SIZE) --mcu=$(MCU) --format=avr $(TARGET).elf

size:
	@if test -f $(TARGET).elf; then echo; echo $(MSG_SIZE); $(ELFSIZE); \
	fi

flash: $(TARGET).bin
	@curl --data-binary @$(TARGET).bin http://192.168.4.1/upload/attiny/1


# Create final output files (.bin) from ELF output file.
%.bin: %.elf
	@echo
	@echo $(MSG_FLASH) $@
	$(OBJCOPY) -O binary -R .eeprom -R .fuse -R .lock -R .signature $< $@

# Link: create ELF output file from object files.
.SECONDARY : $(TARGET).elf
.PRECIOUS : $(OBJ)
%.elf: $(OBJ)
	@echo
	@echo $(MSG_LINKING) $@
	$(CC) -mmcu=$(MCU) $^ --output $@ $(LDFLAGS)


# Assemble: create object files from assembler source files.
./%.o : %.S
	@echo
	@echo $(MSG_ASSEMBLING) $<
	$(CC) -c -mmcu=$(MCU) -I. -x assembler-with-cpp $(DEFS) $< -o $@

# Target: clean project.
clean: begin clean_list end

clean_list :
	@echo
	@echo $(MSG_CLEANING)
	$(REMOVE) $(TARGET).elf
	$(REMOVE) $(TARGET).map
	$(REMOVE) $(SRC:%.S=./%.o)
	$(REMOVE) $(SRC:%.S=./%.lst)
	$(REMOVEDIR) .dep
	@echo

# Listing of phony targets.
.PHONY : all begin finish end sizebefore sizeafter \
build elf bin \
clean clean_list program gdb-config
