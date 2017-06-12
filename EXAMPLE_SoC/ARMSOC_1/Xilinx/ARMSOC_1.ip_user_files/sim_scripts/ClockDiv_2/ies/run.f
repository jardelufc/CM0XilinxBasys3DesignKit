-makelib ies/xil_defaultlib -sv \
  "/opt/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies/xpm \
  "/opt/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies/xil_defaultlib \
  "../../../../ARMSOC_1.srcs/sources_1/ip/ClockDiv_2/ClockDiv_clk_wiz.v" \
  "../../../../ARMSOC_1.srcs/sources_1/ip/ClockDiv_2/ClockDiv.v" \
-endlib
-makelib ies/xil_defaultlib \
  glbl.v
-endlib

