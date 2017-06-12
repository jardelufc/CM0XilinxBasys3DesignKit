# CM0XilinxBasys3DesignKit

Jesus Cristo é O Senhor !

Jesus Christ is The Lord !

Join us at http://www.lesc.ufc.br 

Wow ... this porting has just beend finished. It probably has bugs yet, but it works ! 

It is a porting of Cortex M0 Real Time Operating System (M0S) of Dumitru Stama, winner of hack a day 1kb 2017 contest (http://hackaday.com/2017/01/13/1-kb-challenge-and-the-winners-are/). Original version is for NUCLEO-F072RB and is available at https://github.com/dumitru-stama/M0S .

This port is for Arm Cortex M0 Design Kit running under Basys 3.

Synthesis takes a lot of time because of the logic syntehsided 4kb rom/ram .


This porting has been tested and used under RWindoW$

1. Download this repository and
2. Put this file (https://github.com/CarlosDomingues/TEAM-SUCCESS-NANO/blob/master/cortexm0ds_logic.v) in your \CM0XilinxBasys3DesignKit-master\EXAMPLE_SoC\ARMSOC_1\Xilinx\ARMSOC_1.srcs\sources_1\imports\CM0DS-DesignKit\AHB_Peripherals\CM0DS_AHBL folder.

2. Install arm-non-eabi (https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads) and put it in path

3. Xilinx Install Vivado

4. Enter in Software\M0s folder and run build

5. Open Vivado Project Under Xilinx folder, run Generate bitstream and download it to you Basys 3 board.




          -0x00001000 (Heap mem)
0x00000C01-           (128x4 task stacks)
0x00000801-0x00000C00 (os mem (512), os stack (256), idle task stack(256) )
0x00000000-0x00000800 (Text of M0S and Tasks)



