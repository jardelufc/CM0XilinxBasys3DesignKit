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


module vga_image(
  input wire clk,
  input wire resetn,
  input wire video_on,
  input wire [9:0] pixel_x,
  input wire [9:0] pixel_y,
  input wire image_we,
  input wire [7:0] image_data,
  input wire [15:0] address,

  output wire image_on,
  output reg [7:0] image_rgb
  );


  wire [15:0] addr_r;
  wire [15:0] addr_w;
  wire [7:0] din;
  wire [7:0] dout;

  reg [15:0] address_reg;
  reg [2:0] u3;
  
  //buffer address
  always @(posedge clk)
    address_reg <= address;

 dual_port_ram_sync
  #(.ADDR_WIDTH(16), .DATA_WIDTH(8))
  uimage_ram
  ( .clk(clk),
    .we(image_we),
    .addr_a(addr_w),
    .addr_b(addr_r),
    .din_a(din),
    .dout_a(),
    .dout_b(dout)
  );
  

  assign addr_w = address_reg[15:0];
  assign din = image_data;
  
  
  //assign addr_r = {pixel_y[7:0], ~pixel_x[7], pixel_x[6:0]}; //offset x address by -128
  //assign addr_r = {~pixel_y[5],pixel_y[4:0], pixel_x[8:0]}; //offset x address by -128
  //assign addr_r = pixel_y[5:0] * 12'h280 + pixel_x[9:0];
  
  always@*
  begin
	if(pixel_y[7:5] == 3'b011)
		u3 = 3'b000;
	else if(pixel_y[7:5] == 3'b100)
		u3 = 3'b001;
	else if(pixel_y[7:5] == 3'b101)
		u3 = 3'b010;	
	else if(pixel_y[7:5] == 3'b110)
		u3 = 3'b011;
	else
		u3 = 3'b100;
	end
  		
  assign addr_r = {u3[1:0],pixel_y[4:0], pixel_x[8:0]}; //offset x address by -128
  
  //image on only in top right
  assign image_on = ((pixel_y[9:8] == 2'b01) && (u3[2] == 1'b0) && (pixel_x[9] == 1'b0));
  
  //image output
  always @*
  if(~image_on || ~video_on)
    image_rgb = 8'h00;
  else
    image_rgb = dout;



endmodule
