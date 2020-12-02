#MCU = at90usb1286 # Teensy++ 2.0
MCU = atmega32u4  # Teensy 2.0/Pro Micro



PORT = /dev/ttyACM0

# 4ms is plenty often for all the updates we do
DEFINES += -DUSB_KEYBOARD_BINTERVAL=4

all:
	avr-gcc -mmcu=$(MCU) -DF_CPU=16000000 -DHAVE_CONFIG_H $(DEFINES) \
		-Os -o main.elf -I. *.c
	avr-objcopy -R .eeprom -R .fuse -R .lock -R .signature -O ihex main.elf main.hex

flash: all
#teensy_loader_cli -mmcu=$(MCU) -w main.hex # Teensy
# Setting speed is supposedly meant to reset the pro micro to bootloader mode but this is not working.
	stty -F $(PORT) speed 1200
	stty -F $(PORT) speed 57600
	avrdude -v -p atmega32u4 -c avr109 -P $(PORT) -b57600 -D -U main.hex
