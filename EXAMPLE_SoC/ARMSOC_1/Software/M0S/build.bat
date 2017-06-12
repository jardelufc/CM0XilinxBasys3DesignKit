del *.elf 
del *.o
arm-none-eabi-gcc -fno-builtin-free -fno-builtin-memset -mcpu=cortex-m0 -mthumb -c -o2 -Wall demo.c -o demo.o
arm-none-eabi-as -mcpu=cortex-m0 -o m0s.o m0s.asm
arm-none-eabi-ld -Ttext 0x0000000 m0s.o demo.o -o m0s.elf
arm-none-eabi-objcopy -S -O verilog m0s.elf m0s.v
arm-none-eabi-size m0s.elf
rem pause
rem arm-none-eabi-objdump -d -S m0s.elf
del *.elf 
del *.o
monta
