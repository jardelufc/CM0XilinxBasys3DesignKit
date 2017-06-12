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


module AHBKB(
  input wire HCLK,
  input wire HRESETn,
  input wire [31:0] HADDR,
  input wire [31:0] HWDATA,
  input wire HWRITE,
  input wire [1:0] HTRANS,
  input wire HREADY,
  input wire HSEL,
  
  output wire HREADYOUT,
  output wire [31:0] HRDATA,
  output wire kb_irq,
  
  input wire ps2d,
  input wire ps2c  
    );
    
  reg last_HSEL;
  reg last_HWRITE;
  reg [1:0] last_HTRANS;
  
  always @(posedge HCLK)
  if(HREADY)
    begin
      last_HSEL <= HSEL;
      last_HWRITE <= HWRITE;
      last_HTRANS <= HTRANS;
    end
  
    
    
  wire [8:0] code_out;  //shift + kb scan code
  wire got_code;        //scan code received
  wire [7:0] ascii_out; //ascii value of code_out
  wire empty;           //fifo status
  wire [7:0] dout;      //fifo output
  wire rd;              //fifo read
  
  
//Module Instantiation
  
  kb_code ukb_code(
    .clk(HCLK),
    .resetn(HRESETn),
    .ps2d(ps2d),
    .ps2c(ps2c),
    .got_code(got_code),
    .code_out(code_out[8:0])
  );
    
  kb2ascii ukb2ascii(
    .key_code(code_out[8:0]),
    .ascii_code(ascii_out[7:0])
  );
    
  FIFO uFIFO(
  .clk(HCLK),
  .resetn(HRESETn),
  .rd(rd),
  .wr(got_code),
  .w_data(ascii_out[7:0]),
  .empty(empty),
  .full(),
  .r_data(dout[7:0])
  );
  

  //Only read if not empty
  assign rd = ~last_HWRITE & last_HTRANS[1] & last_HSEL & ~empty;

  //If empty wait for input
  assign HREADYOUT = ~empty;

  //Interrupt if something has been received but not if already trying to read
  assign kb_irq = ~empty & ~rd;

  //assign output
  assign HRDATA[7:0] = dout;
  
endmodule
