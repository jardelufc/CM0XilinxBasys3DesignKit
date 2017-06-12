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


module vga_sync(
  input wire        clk,
  input wire        resetn,
  
  output wire       hsync,
  output wire       vsync,
  output wire       video_on,
  output wire       p_tick,
  output wire [9:0] pixel_x,
  output wire [9:0] pixel_y
);


  localparam HD = 640;  //horizontal display
  localparam HF = 48;   //h. front border
  localparam HB = 16;   //h. back border
  localparam HR = 96;   //h. retrace

  localparam VD = 480;  //vertical display
  localparam VF = 10;   //v. front border
  localparam VB = 33;   //v. back border
  localparam VR = 2;    //v. retrace



  reg mod2_reg;
  wire mod2_next;

  reg [9:0] h_count;
  reg [9:0] h_count_next;

  reg [9:0] v_count;
  reg [9:0] v_count_next;
  
  reg hsync_reg;
  wire hsync_next;
  
  reg vsync_reg;
  wire vsync_next;
  
  

  //Mod-2 Counter to generate 25MHz clk 
  always @(posedge clk, negedge resetn)
  begin
    if(!resetn)
      mod2_reg <= 1'b0;
    else
      mod2_reg <= mod2_next;
  end
  
  assign mod2_next = ~mod2_reg;
  assign p_tick = mod2_next;

  //Horizontal Pixel Counter
  always @(posedge clk, negedge resetn)
  begin
    if(!resetn)
      h_count <= 1'b0;
    else
      h_count <= h_count_next;
  end

  always @*
  begin
    if(p_tick)
      if(h_count == (HD+HF+HB+HR-1))
        h_count_next = 1'b0;
      else
        h_count_next = h_count + 1;
    else
      h_count_next = h_count;
  end

  assign pixel_x = h_count;

  //Vertical Pixel Counter
  always @(posedge clk, negedge resetn)
  begin
    if(!resetn)
      v_count <= 1'b0;
    else
      v_count <= v_count_next;
  end

  always @*
  begin
    if(p_tick & (h_count == (HD+HF+HB+HR-1)))
      if(v_count == (VD+VF+VB+VR-1))
        v_count_next = 1'b0;
      else
        v_count_next = v_count +1;
    else
      v_count_next = v_count;
  end

  assign pixel_y = v_count;

  //Horizontal and Vertical Sync
  always @(posedge clk, negedge resetn)
  begin
    if(!resetn)
      begin
        hsync_reg <= 1'b0;
        vsync_reg <= 1'b0;
      end
    else
      begin
        hsync_reg <= hsync_next;
        vsync_reg <= vsync_next;
      end
  end
  
  //If h_count and v_count are in the hsync range assert the signal
  assign hsync_next = ((h_count >= HD+HB) && (h_count <=HD+HB+HR-1));
  assign vsync_next = ((v_count >= VD+VB) && (v_count <=VD+VB+VR-1));

  assign hsync = hsync_reg;
  assign vsync = vsync_reg;

  //video_on signal
  assign video_on = ((h_count < HD) && (v_count < VD));

endmodule
  

