del *.elf 
del *.o
arm-none-eabi-as -mthumb -mcpu=cortex-m0 -o cm0dsasm.o cm0dsasm.asm
arm-none-eabi-ld -Ttext 0x0000000 -Tdata 0x00000800 -Tbss 0x00000C00 cm0dsasm.o -o cm0dsasm.elf 
rem -shared -fno-delete-null-pointer-checks
arm-none-eabi-objcopy -S -O verilog cm0dsasm.elf cm0dsasm.v
arm-none-eabi-size cm0dsasm.elf
del *.elf 
del *.o
monta