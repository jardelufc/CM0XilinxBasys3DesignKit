//////////////////////////////////////////////////////////////////////////////////
//END USER LICENCE AGREEMENT                                                    //
//                                                                              //
//Copyright (c) 2012, ARM All rights reserved.                                  //
//                                                                              //
//THIS END USER LICENCE AGREEMENT (�LICENCE�) IS A LEGAL AGREEMENT BETWEEN      //
//YOU AND ARM LIMITED ("ARM") FOR THE USE OF THE SOFTWARE EXAMPLE ACCOMPANYING  //
//THIS LICENCE. ARM IS ONLY WILLING TO LICENSE THE SOFTWARE EXAMPLE TO YOU ON   //
//CONDITION THAT YOU ACCEPT ALL OF THE TERMS IN THIS LICENCE. BY INSTALLING OR  //
//OTHERWISE USING OR COPYING THE SOFTWARE EXAMPLE YOU INDICATE THAT YOU AGREE   //
//TO BE BOUND BY ALL OF THE TERMS OF THIS LICENCE. IF YOU DO NOT AGREE TO THE   //
//TERMS OF THIS LICENCE, ARM IS UNWILLING TO LICENSE THE SOFTWARE EXAMPLE TO    //
//YOU AND YOU MAY NOT INSTALL, USE OR COPY THE SOFTWARE EXAMPLE.                //
//                                                                              //
//ARM hereby grants to you, subject to the terms and conditions of this Licence,//
//a non-exclusive, worldwide, non-transferable, copyright licence only to       //
//redistribute and use in source and binary forms, with or without modification,//
//for academic purposes provided the following conditions are met:              //
//a) Redistributions of source code must retain the above copyright notice, this//
//list of conditions and the following disclaimer.                              //
//b) Redistributions in binary form must reproduce the above copyright notice,  //
//this list of conditions and the following disclaimer in the documentation     //
//and/or other materials provided with the distribution.                        //
//                                                                              //
//THIS SOFTWARE EXAMPLE IS PROVIDED BY THE COPYRIGHT HOLDER "AS IS" AND ARM     //
//EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING     //
//WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR //
//PURPOSE, WITH RESPECT TO THIS SOFTWARE EXAMPLE. IN NO EVENT SHALL ARM BE LIABLE/
//FOR ANY DIRECT, INDIRECT, INCIDENTAL, PUNITIVE, OR CONSEQUENTIAL DAMAGES OF ANY/
//KIND WHATSOEVER WITH RESPECT TO THE SOFTWARE EXAMPLE. ARM SHALL NOT BE LIABLE //
//FOR ANY CLAIMS, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, //
//TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE    //
//EXAMPLE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE EXAMPLE. FOR THE AVOIDANCE/
// OF DOUBT, NO PATENT LICENSES ARE BEING LICENSED UNDER THIS LICENSE AGREEMENT.//
//////////////////////////////////////////////////////////////////////////////////


module AHBLITE_SYS(
	//CLOCKS & RESET
	input		wire				CLK,
	input		wire				RESETn, 
	
	//TO BOARD LEDs
	output 	wire	[7:0] 	LED,
	output 	wire	[7:0] 	deLED	

);

//AHB-LITE SIGNALS 
//Gloal Signals
wire 				HCLK;
reg 				HRESETn;
//Address, Control & Write Data Signals
wire [31:0]		HADDR;
wire [31:0]		HWDATA;
wire 				HWRITE;
wire [1:0] 		HTRANS;
wire [2:0] 		HBURST;
wire 				HMASTLOCK;
wire [3:0] 		HPROT;
wire [2:0] 		HSIZE;
//Transfer Response & Read Data Signals
wire [31:0] 	HRDATA;
wire 				HRESP;
wire 				HREADY;

//SELECT SIGNALS
wire [3:0] 		MUX_SEL;

wire 				HSEL_MEM;
wire 				HSEL_LED;

//SLAVE READ DATA
wire [31:0] 	HRDATA_MEM;
wire [31:0] 	HRDATA_LED;

//SLAVE HREADYOUT
wire 				HREADYOUT_MEM;
wire 				HREADYOUT_LED;

//CM0-DS Sideband signals
wire 				LOCKUP;
wire 				TXEV;
wire 				SLEEPING;
wire [15:0]		IRQ;


reg [3:0] count;

//reg HRESETn;
reg enable;

  
//SYSTEM GENERATES NO ERROR RESPONSE
assign 			HRESP = 1'b0;

//CM0-DS INTERRUPT SIGNALS  
assign 			IRQ = {16'b0000_0000_0000_0000};
assign 			LED[7] = LOCKUP;



//ClockDiv	uClockDiv	(
//	.clk_in1(CLK),
//	.clk_out1(HCLK)
//	);
	

ClockDiv  instance_name
  (
  // Clock out ports  
  .clk_out1(HCLK),
 // Clock in ports
  .clk_in1(CLK)
  );

/*assign 			HRESETn = RESETn;*/
//assign 			HCLK = CLK;  

always @ (posedge HCLK)

if (RESETn == 1'b1) begin

    HRESETn <= 1'b0;
     
end else if(RESETn == 1'b0) begin

    HRESETn <= 1'b1;

end



/*
always @ (posedge CLK)

if (RESETn == 0'b0) begin

    count <= 0;

    enable=1;

end else if(enable==1) begin

    count <= count + 1;

end

always @ (posedge CLK)

if (count == 4'b0) begin

    HRESETn <= 0;
    
end else if ( count == 5) begin

    HRESETn <= 1;
    //count=1;
    enable=0;
    
end

*/
/*
always @(posedge CLK)
begin
if (~HRESETn)
     HCLK <= 1'b0;
else
     HCLK <= ~HCLK;	
end               
*/

//AHBLite MASTER --> CM0-DS

CORTEXM0DS u_cortexm0ds (
	//Global Signals
	.HCLK        (HCLK),
	.HRESETn     (HRESETn),
	//Address, Control & Write Data	
	.HADDR       (HADDR[31:0]),
	.HBURST      (HBURST[2:0]),
	.HMASTLOCK   (HMASTLOCK),
	.HPROT       (HPROT[3:0]),
	.HSIZE       (HSIZE[2:0]),
	.HTRANS      (HTRANS[1:0]),
	.HWDATA      (HWDATA[31:0]),
	.HWRITE      (HWRITE),
	//Transfer Response & Read Data	
	.HRDATA      (HRDATA[31:0]),			
	.HREADY      (HREADY),					
	.HRESP       (HRESP),					

	//CM0 Sideband Signals
	.NMI         (1'b0),
	.IRQ         (IRQ[15:0]),
	.TXEV        (),
	.RXEV        (1'b0),
	.LOCKUP      (LOCKUP),
	.SYSRESETREQ (),
	.SLEEPING    ()
);

//Address Decoder 

AHBDCD uAHBDCD (
	.HADDR(HADDR[31:0]),
	 
	.HSEL_S0(HSEL_MEM),
	.HSEL_S1(HSEL_LED),
	.HSEL_S2(),
	.HSEL_S3(),
	.HSEL_S4(),
	.HSEL_S5(),
	.HSEL_S6(),
	.HSEL_S7(),
	.HSEL_S8(),
	.HSEL_S9(),
	.HSEL_NOMAP(HSEL_NOMAP),
	 
	.MUX_SEL(MUX_SEL[3:0])
);

//Slave to Master Mulitplexor

AHBMUX uAHBMUX (
	.HCLK(HCLK),
	.HRESETn(HRESETn),
	.MUX_SEL(MUX_SEL[3:0]),
	 
	.HRDATA_S0(HRDATA_MEM),
	.HRDATA_S1(HRDATA_LED),
	.HRDATA_S2(),
	.HRDATA_S3(),
	.HRDATA_S4(),
	.HRDATA_S5(),
	.HRDATA_S6(),
	.HRDATA_S7(),
	.HRDATA_S8(),
	.HRDATA_S9(),
	.HRDATA_NOMAP(32'hDEADBEEF),
	 
	.HREADYOUT_S0(HREADYOUT_MEM),
	.HREADYOUT_S1(HREADYOUT_LED),
	.HREADYOUT_S2(1'b1),
	.HREADYOUT_S3(1'b1),
	.HREADYOUT_S4(1'b1),
	.HREADYOUT_S5(1'b1),
	.HREADYOUT_S6(1'b1),
	.HREADYOUT_S7(1'b1),
	.HREADYOUT_S8(1'b1),
	.HREADYOUT_S9(1'b1),
	.HREADYOUT_NOMAP(1'b1),
    
	.HRDATA(HRDATA[31:0]),
	.HREADY(HREADY)
);

// AHBLite Peripherals


//AHBLite Slave 
AHB2MEM uAHB2MEM (
	//AHBLITE Signals
	.HSEL(HSEL_MEM),
	.HCLK(HCLK), 
	.HRESETn(HRESETn), 
	.HREADY(HREADY),     
	.HADDR(HADDR),
	.HTRANS(HTRANS[1:0]), 
	.HWRITE(HWRITE),
	.HSIZE(HSIZE),
	.HWDATA(HWDATA[31:0]), 
	.HRDATA(HRDATA_MEM), 
	.HREADYOUT(HREADYOUT_MEM),
	.LED(deLED[7:0])
);

//AHBLite Slave 
AHB2LED uAHB2LED (
	//AHBLITE Signals
	.HSEL(HSEL_LED),
	.HCLK(HCLK), 
	.HRESETn(HRESETn), 
	.HREADY(HREADY),     
	.HADDR(HADDR),
	.HTRANS(HTRANS[1:0]), 
	.HWRITE(HWRITE),
	.HSIZE(HSIZE),
	.HWDATA(HWDATA[31:0]), 
	
	.HRDATA(HRDATA_LED), 
	.HREADYOUT(HREADYOUT_LED),
	//Sideband Signals
	.LED(LED[6:0])
);

endmodule
