//////////////////////////////////////////////////////////////////////////////////
//END USER LICENCE AGREEMENT                                                    //
//                                                                              //
//Copyright (c) 2012, ARM All rights reserved.                                  //
//                                                                              //
//THIS END USER LICENCE AGREEMENT (“LICENCE”) IS A LEGAL AGREEMENT BETWEEN      //
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


module AHB2SRAMFLSH(
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
	
	//SRAM/FLASH at 0x0
			input	 wire FlashAtZero,
			
	//Towards Memory
			inout	 wire [15:0] MemDB,
			output wire [26:1] MemAdr,
			output wire RamCS,
			output wire FlashCS,
			output wire MemWR,
			output wire MemOE,
			output wire RamUB,
			output wire RamLB,
			output wire RamCre,
			output wire RamAdv,
			output wire RamClk,
			input  wire RamWait,
			output wire FlashRp

);


  assign RamCre = 1'b0;
  assign RamAdv = 1'b0;
  assign RamClk = 1'b0;
  assign FlashRp = HRESETn;
  

// Registers to store Adress Phase Signals

  reg APhase_HSEL;
  reg APhase_HWRITE;
  reg [1:0] APhase_HTRANS;
  reg [31:0] APhase_HADDR;
  reg [2:0] APhase_HSIZE;
  reg start;

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
		start <= 1'b0;
	 end
    else if(HREADY && HSEL)
    begin
      APhase_HSEL <= HSEL;
      APhase_HWRITE <= HWRITE;
      APhase_HTRANS <= HTRANS;
		APhase_HADDR <= HADDR;
		APhase_HSIZE <= HSIZE;
		start <= 1'b1;
    end
	 else if(done)
		start <= 1'b0;
	 
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

  localparam idle		= 16'b0000_0000_0000_0000;
  localparam read1	= 16'b0000_0000_0000_0001;
  localparam read2	= 16'b0000_0000_0000_0010;
  localparam read3	= 16'b0000_0000_0000_0100;
  localparam read4	= 16'b0000_0000_0000_1000;
  localparam write1	= 16'b0000_0001_0000_0000;
  localparam write2	= 16'b0000_0010_0000_0000;
  localparam write3	= 16'b0000_0100_0000_0000;
  localparam write4 	= 16'b0000_1000_0000_0000;
  localparam write5	= 16'b0001_0000_0000_0000;
  localparam write6	= 16'b0010_0000_0000_0000;
  

  reg [15:0] pstate;
  reg [15:0] nstate;
  reg [31:0] rHRDATA;
  
  always @(posedge HCLK or negedge HRESETn)
  begin
    if(!HRESETn)
	 	pstate <= idle;
	 else
		pstate <= nstate;
  end

  always @*
  begin
	case(pstate)
		idle:
		begin
				if(start & APhase_HWRITE)
				begin
					if(byte0 | byte1)
						nstate = write1;
					else if(byte2|byte3)
						nstate = write3;
					else
						nstate = idle;
				end
				else if (start & !APhase_HWRITE)
					nstate = read1;
				else
					nstate = idle;
		end
		
		read1:
				if(cdone)
					nstate = read2;
				else
					nstate = read1;
		read2:
				if(cdone)
					nstate = read3;
				else
					nstate = read2;
		read3:
				if(cdone)
					nstate = read4;
				else
					nstate = read3;
		read4:
				if(cdone)
					nstate = idle;
				else
					nstate = read4;
		
		write1:
				if(cdone)
					nstate = write2;
				else
					nstate = write1;
		write2:
				if(cdone)
				begin
					if(byte2|byte3)
						nstate = write3;
					else
						nstate = idle;
				end		
				else
					nstate = write2;
		write3:
				if(cdone)
					nstate = write4;
				else
					nstate = write3;
		write4:
				if(cdone)
					nstate = idle;
				else
					nstate = write4;
		default:
				nstate = idle;
	endcase
  end

				
  assign HREADYOUT = !start;
  wire done = !(|nstate);
   
  wire CS = !(pstate[0] | pstate[2] | pstate[8] | pstate[10]);
  assign MemWR = pstate[0] | pstate[1] | pstate[2] | pstate[3];
  assign MemOE = !(pstate[0] | pstate[1] | pstate[2] | pstate[3] );

  assign MemAdr[22:1] = (pstate[0]|pstate[1]) ? {APhase_HADDR[22:2],1'b0} :
								(pstate[2]|pstate[3]) ? {APhase_HADDR[22:2],1'b1} :
								(pstate[8]|pstate[9]) ? {APhase_HADDR[22:2],1'b0} :
								(pstate[10]|pstate[11]) ? {APhase_HADDR[22:2],1'b1} : 23'h0;
			
  assign MemAdr[26:23] = 4'b000;
  wire lowCS = APhase_HADDR[23] | CS;
  wire highCS = !APhase_HADDR[23] | CS;  

  assign RamCS = FlashAtZero ? highCS : lowCS;
  assign FlashCS = !FlashAtZero ? highCS : lowCS;

  assign MemDB[15:0] = 	(pstate[8]|pstate[9]) ? HWDATA[15:0] :
								(pstate[10]|pstate[11]) ? HWDATA[31:16] : 16'hz;
  
  assign RamUB = !(byte1|byte3);
  assign RamLB = !(byte0|byte2);

  always @(posedge HCLK or negedge HRESETn)
  begin
	if(!HRESETn)
		rHRDATA <= 32'h0;
	else if(pstate[0])
		rHRDATA[15:0] <= MemDB[15:0];
	else if(pstate[2])
		rHRDATA[31:16] <= MemDB[15:0];
  end
 
  wire rc = |pstate;
  reg [3:0] count;
  always @(posedge HCLK or negedge HRESETn)
  begin
	if(!HRESETn || !rc)
		count <= 4'b1111;
	else 
		count <= count - 1'b1;
  end
		
  wire cdone = !(|count);
// Reading from memory 
  assign HRDATA = rHRDATA;

endmodule
