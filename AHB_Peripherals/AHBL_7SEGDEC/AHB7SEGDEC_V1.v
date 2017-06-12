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


module AHB7SEGDEC(
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
	
	//7segment displa
			output [6:0] seg,
			output [3:0] an,
			output dp
  );

//Address Phase Sampling Registers
  reg rHSEL;
  reg [31:0] rHADDR;
  reg [1:0] rHTRANS;
  reg rHWRITE;
  reg [2:0] rHSIZE;


//Address Phase Sampling
  always @(posedge HCLK or negedge HRESETn)
  begin
	 if(!HRESETn)
	 begin
		rHSEL		<= 1'b0;
		rHADDR	<= 32'h0;
		rHTRANS	<= 2'b00;
		rHWRITE	<= 1'b0;
		rHSIZE	<= 3'b000;
	 end
    else if(HREADY)
    begin
      rHSEL		<= HSEL;
		rHADDR	<= HADDR;
		rHTRANS	<= HTRANS;
		rHWRITE	<= HWRITE;
		rHSIZE	<= HSIZE;
    end
  end

//Data Phase data transfer

  reg [15:0]	DATA;
  always @(posedge HCLK or negedge HRESETn)
  begin
    if(!HRESETn)
      DATA <= 16'h1234;
    else if(rHSEL & rHWRITE & rHTRANS[1])
      DATA <= HWDATA[15:0];
  end

//Transfer Response
  assign HREADYOUT = 1'b1; //Single cycle Write & Read. Zero Wait state operations

//Read Data  
  assign HRDATA = {16'h0,DATA};

  reg [31:0] counter;
  reg [3:0] ring = 4'b0001;
  
  wire [3:0] code;
  wire [6:0] seg_out;
  assign seg = ~seg_out;
  assign an = ~ring;
  assign dp = 1'b1;

  always @(posedge HCLK or negedge HRESETn)
  begin
	if(!HRESETn)
		counter <= 32'h0000_0000;
	else
		counter <= counter + 1'b1;
  end

  always @(posedge counter[15] or negedge HRESETn)
  begin
	if(!HRESETn)
		ring <= 4'b0001;
	else
		ring <= {ring[2:0],ring[3]};
  end

  assign code =
	(ring == 4'b0001) ? DATA[3:0] :
	(ring == 4'b0010) ? DATA[7:4] :
	(ring == 4'b0100) ? DATA[11:8] :
	(ring == 4'b1000) ? DATA[15:12] :
		4'b1110;
		

parameter A      = 7'b0000001;
parameter B      = 7'b0000010;
parameter C      = 7'b0000100;
parameter D      = 7'b0001000;
parameter E      = 7'b0010000;
parameter F      = 7'b0100000;
parameter G      = 7'b1000000;

assign seg_out =
    (code == 4'h0) ? A|B|C|D|E|F :
    (code == 4'h1) ? B|C :
    (code == 4'h2) ? A|B|G|E|D :
    (code == 4'h3) ? A|B|C|D|G :

    (code == 4'h4) ? F|B|G|C :
    (code == 4'h5) ? A|F|G|C|D : 
    (code == 4'h6) ? A|F|G|C|D|E :
    (code == 4'h7) ? A|B|C :

    (code == 4'h8) ? A|B|C|D|E|F|G :
    (code == 4'h9) ? A|B|C|D|F|G :
    (code == 4'ha) ? A|F|B|G|E|C :
    (code == 4'hb) ? F|G|C|D|E :

    (code == 4'hc) ? G|E|D :
    (code == 4'hd) ? B|C|G|E|D :
    (code == 4'he) ? A|F|G|E|D :
    (code == 4'hf) ? A|F|G|E :
           7'b000_0000;

endmodule
