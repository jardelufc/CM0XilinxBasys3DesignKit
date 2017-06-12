type ..\cabeca.v > ahb2mem_v2.v
echo @08000000 >> m0s.v
..\v2sv m0s.v miolo 4095
type miolo.sv >> ahb2mem_v2.v
type ..\rabo.v >> ahb2mem_v2.v
type ahb2mem_v2.v > ..\..\..\..\AHB_Peripherals\AHBL_MEM\ahb2mem_v2.v