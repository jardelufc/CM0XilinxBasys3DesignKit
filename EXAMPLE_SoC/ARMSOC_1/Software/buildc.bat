del *.elf 
del *.o
arm-none-eabi-gcc -fno-builtin-free -fno-builtin-memset -mcpu=cortex-m0 -mthumb -c -o2 -Wall morse.c -o demo.o
arm-none-eabi-as -mcpu=cortex-m0 -o m0s.o m0s.asm
arm-none-eabi-ld -Ttext 0x0000000 -Tdata 0x00000800 -Tbss 0x00000C00 m0s.o demo.o -o m0s.elf
arm-none-eabi-objcopy -S -O verilog m0s.elf cm0dsasm.v
arm-none-eabi-size m0s.elf
arm-none-eabi-objdump -d -S m0s.elf
rem del *.elf 
rem del *.o
monta