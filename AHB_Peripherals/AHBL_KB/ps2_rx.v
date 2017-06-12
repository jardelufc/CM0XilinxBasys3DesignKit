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


module ps2_rx(
  input wire clk,
  input wire resetn,
  input wire ps2d,
  input wire ps2c,
  input wire rx_en,
  output reg rx_done,
  output wire [7:0] dout
);
  
  localparam [1:0]
    idle_st = 2'b00,
    data_st = 2'b01,
    load_st = 2'b10;
    
  reg [7:0] filter;         //ps2c filtering reg
  wire [7:0] filter_next;
  reg f_ps2c;               //filtered ps2c
  wire f_ps2c_next;
  reg [1:0] next_state;
  reg [1:0] current_state;
  reg [3:0] n;              //count register
  reg [3:0] n_next;
  reg [10:0] data;             //data and next data
  reg [10:0] data_next;
  wire fall_edge;             //falling edge of ps2c
  
  
  
  
  //Filter PS2 Clock Signal
  // Uses and 8-bit filter to make sure ps2 clk
  // signal is not jumping around then generates
  // the falling edge signal for the ps2 clk.
  
  always @(posedge clk, negedge resetn)
  begin
    if(!resetn)
      begin
        filter <= 0;
        f_ps2c <= 0;
      end
    else
      begin
        filter <= filter_next;
        f_ps2c <= f_ps2c_next;
      end
  end
  
  assign filter_next = {ps2c, filter[7:1]};
  assign f_ps2c_next = (filter == 8'b11111111) ? 1'b1 :
                       (filter == 8'b00000000) ? 1'b0 :
                       f_ps2c;
   
  assign fall_edge = f_ps2c & ~f_ps2c_next;
  
  
  //State Machine
  
  always @(posedge clk, negedge resetn)
  begin
    if(!resetn)
      begin
        current_state <= idle_st;
        n <= 0;
        data <= 0;
      end
    else
      begin
        current_state <= next_state;
        n <= n_next;
        data <= data_next;
      end
  end

  //Next state logic for receiving in the PS/2 protocol
  always @*
  begin
    next_state = current_state;
    rx_done = 1'b0;
    n_next = n;
    data_next = data;
    
    case(current_state)
      idle_st:
      begin
        if(fall_edge & rx_en)
          begin
            data_next = {ps2d, data[10:1]};
            n_next = 4'b1001;
            next_state = data_st;
          end
      end
      data_st:
      begin
        if(fall_edge)
          begin
            data_next = {ps2d, data[10:1]};
            if(n == 0)
              next_state = load_st;
            else
              n_next = n - 1;
          end
      end
      load_st:
        begin
          next_state = idle_st;
          rx_done = 1'b1;
        end
    endcase
  end
  
  //output - data bits
  assign dout = data[8:1];

endmodule
