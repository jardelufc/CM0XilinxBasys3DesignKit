# CM0XilinxBasys3DesignKit


It is a porting of Cortex M0 Real Time Operating System (M0S) of Dumitru Stama, winner of hack a day 1kb 2017 contest (http://hackaday.com/2017/01/13/1-kb-challenge-and-the-winners-are/). Original version is for NUCLEO-F072RB and is available at https://github.com/dumitru-stama/M0S .

This port is for Arm Cortex M0 Design Kit running under Basys 3.

Synthesis takes a lot of time because of the logic syntehsided 4kb rom/ram .


This porting has been tested and used under RWindoW$

1. Download this repository and put cortexm0ds_logic.v in \CM0XilinxBasys3DesignKit-master\EXAMPLE_SoC\ARMSOC_1\Xilinx\ARMSOC_1.srcs\sources_1\imports\CM0DS-DesignKit\AHB_Peripherals\CM0DS_AHBL

2. Install arm-non-eabi and put it in path

3. Xilinx Install Vivado

4. Enter in Software\M0s and run build



