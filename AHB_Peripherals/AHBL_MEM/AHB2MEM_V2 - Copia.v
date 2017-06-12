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


module AHB2MEM
#(parameter MEMWIDTH = 10)					// SIZE = 1KB = 256 Words
(
	//AHBLITE INTERFACE
		//Slave Select Signals
			input wire HSEL,
		//Global Signal
			input wire HCLK,
			input wire HRESETn,
		//Address, Control & Write Data
			input wire HREADY,
			input wire [31:0] HADDR,
			input wire [1:0] HTRANS,
			input wire HWRITE,
			input wire [2:0] HSIZE,
			
			input wire [31:0] HWDATA,
		// Transfer Response & Read Data
			output wire HREADYOUT,
			output wire [31:0] HRDATA,
	//		output wire [7:0] deLED
	
	//LED Output
			output wire [7:0] LED
);


  assign HREADYOUT = 1'b1; // Always ready

// Registers to store Adress Phase Signals

  reg APhase_HSEL;
  reg APhase_HWRITE;
  reg [1:0] APhase_HTRANS;
  reg [31:0] APhase_HADDR;
  reg [2:0] APhase_HSIZE;

// Memory Array  
  //reg [31:0] memory[0:(2**(MEMWIDTH-2)-1)];
  
  reg [31:0] memory[0:42];
  
  initial
  begin
  //integer k;
//	$readmemh("/home/jardel/CM0DS-DesignKit/EXAMPLE_SoC/ARMSOC_1//Software/code.hex", memory, 0,(2**(MEMWIDTH-2)-1) );
	//$readmemh("/home/jardel/CM0DS-DesignKit/EXAMPLE_SoC/ARMSOC_1//Software/code.hex", memory, 0,42 );	

  /*memory[1]='h00000081;
  
  for (k = 2; k < 32; k = k + 1)
  begin
      mem[k] = 'h0;
      */
 /* memory[0]='h000003FC; //000003FC

  memory[1]='h00000081; 
  memory[2]='h00000000; 
  memory[3]='h00000000; 
  memory[4]='h00000000; 
  memory[5]='h00000000; 
  memory[6]='h00000000;       
  memory[7]='h00000000; 
  memory[8]='h00000000; 
  memory[9]='h00000000;       
  memory[10]='h00000000; 
  memory[11]='h00000000; 
  memory[12]='h00000000;       
  memory[13]='h00000000; 
  memory[14]='h00000000; 
  memory[15]='h00000000;       
  memory[16]='h00000000; 
  memory[17]='h00000000; 
  memory[18]='h00000000;       
  memory[19]='h00000000; 
  memory[20]='h00000000; 
  memory[21]='h00000000;       
  memory[22]='h00000000; 
  memory[23]='h00000000; 
  memory[24]='h00000000;       
  memory[25]='h00000000; 
  memory[26]='h00000000; 
  memory[27]='h00000000;       
  memory[28]='h00000000; 
  memory[29]='h00000000; 
  memory[30]='h00000000;       
  memory[31]='h00000000; 
        
  memory[32]='h48074906;
  memory[33]='h48076008;
  memory[34]='hD1FD1E40;
  memory[35]='h48064903;
  memory[36]='h48046008;
  memory[37]='hD1FD1E40;
  memory[38]='h0000E7F2;
  memory[39]='h50000000;
  memory[40]='h00000055;
  memory[41]='h002FFFFF;
  memory[42]='h000000AA;
*/

memory[0]='h000003FC;
memory[1]='h00000081;
memory[2]='h00000000;
memory[3]='h00000000;
memory[4]='h00000000;
memory[5]='h00000000;
memory[6]='h00000000;
memory[7]='h00000000;
memory[8]='h00000000;
memory[9]='h00000000;
memory[10]='h00000000;
memory[11]='h00000000;
memory[12]='h00000000;
memory[13]='h00000000;
memory[14]='h00000000;
memory[15]='h00000000;
memory[16]='h00000000;
memory[17]='h00000000;
memory[18]='h00000000;
memory[19]='h00000000;
memory[20]='h00000000;
memory[21]='h00000000;
memory[22]='h00000000;
memory[23]='h00000000;
memory[24]='h00000000;
memory[25]='h00000000;
memory[26]='h00000000;
memory[27]='h00000000;
memory[28]='h00000000;
memory[29]='h00000000;
memory[30]='h00000000;
memory[31]='h00000000;
memory[32]='h48074906;
memory[33]='h48076008;
memory[34]='hD1FD3801;
memory[35]='h48064903;
memory[36]='h48046008;
memory[37]='hD1FD3801;
memory[38]='h0000E7F2;
memory[39]='h50000000;
memory[40]='h55555555;
memory[41]='h002FFFFF;
memory[42]='hAAAAAAAA;
  end

//  deLED <= memory[0][0:7];
// Sample the Address Phase   
  always @(posedge HCLK or negedge HRESETn)
  begin
	 if(!HRESETn)
	 begin
		APhase_HSEL <= 1'b0;
      APhase_HWRITE <= 1'b0;
      APhase_HTRANS <= 2'b00;
		APhase_HADDR <= 32'h0;
		APhase_HSIZE <= 3'b000;
	 end
    else if(HREADY)
    begin
      APhase_HSEL <= HSEL;
      APhase_HWRITE <= HWRITE;
      APhase_HTRANS <= HTRANS;
		APhase_HADDR <= HADDR;
		APhase_HSIZE <= HSIZE;
    end
  end

// Decode the bytes lanes depending on HSIZE & HADDR[1:0]

  wire tx_byte = ~APhase_HSIZE[1] & ~APhase_HSIZE[0];
  wire tx_half = ~APhase_HSIZE[1] &  APhase_HSIZE[0];
  wire tx_word =  APhase_HSIZE[1];
  
  wire byte_at_00 = tx_byte & ~APhase_HADDR[1] & ~APhase_HADDR[0];
  wire byte_at_01 = tx_byte & ~APhase_HADDR[1] &  APhase_HADDR[0];
  wire byte_at_10 = tx_byte &  APhase_HADDR[1] & ~APhase_HADDR[0];
  wire byte_at_11 = tx_byte &  APhase_HADDR[1] &  APhase_HADDR[0];
  
  wire half_at_00 = tx_half & ~APhase_HADDR[1];
  wire half_at_10 = tx_half &  APhase_HADDR[1];
  
  wire word_at_00 = tx_word;
  
  wire byte0 = word_at_00 | half_at_00 | byte_at_00;
  wire byte1 = word_at_00 | half_at_00 | byte_at_01;
  wire byte2 = word_at_00 | half_at_10 | byte_at_10;
  wire byte3 = word_at_00 | half_at_10 | byte_at_11;

// Writing to the memory

  always @(posedge HCLK)
  begin
	 if(APhase_HSEL & APhase_HWRITE & APhase_HTRANS[1])
	 begin
		if(byte0)
			memory[APhase_HADDR[MEMWIDTH:2]][7:0] <= HWDATA[7:0];
		if(byte1)
			memory[APhase_HADDR[MEMWIDTH:2]][15:8] <= HWDATA[15:8];
		if(byte2)
			memory[APhase_HADDR[MEMWIDTH:2]][23:16] <= HWDATA[23:16];
		if(byte3)
			memory[APhase_HADDR[MEMWIDTH:2]][31:24] <= HWDATA[31:24];
	  end
  end

// Reading from memory 
  assign HRDATA = memory[APhase_HADDR[MEMWIDTH:2]];

// Diagnostic Signal out
  assign LED = memory[35][7:0];
  
endmodule
