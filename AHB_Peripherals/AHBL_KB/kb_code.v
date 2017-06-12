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


module kb_code(
  input wire clk,
  input wire resetn,
  input wire ps2d,
  input wire ps2c,
  output reg got_code,
  output wire [8:0] code_out
);
  
  //Special key codes
  localparam [7:0] BRK = 8'hF0;
  localparam [7:0] SHIFT = 8'h12;
  
  //States
  localparam [1:0]
    scan_st = 2'b00,
    break_st = 2'b01,
    stop_st = 2'b10;
  
  //Internal Signals
  reg [1:0] current_state;
  reg [1:0] next_state;
  reg shift_code;
  reg next_shift_code;
 
  wire [7:0] scan_out;
  wire scan_done;
  
  ps2_rx ups2_rx(
    .clk(clk),
    .resetn(resetn),
    .ps2d(ps2d),
    .ps2c(ps2c),
    .rx_en(1'b1),
    .rx_done(scan_done),
    .dout(scan_out)
  );
  
  //State Machine
  always @(posedge clk, negedge resetn)
  begin
    if(!resetn)
      begin
        current_state <= scan_st;
        shift_code <= 0;
      end
    else
      begin
        current_state <= next_state;
        shift_code <= next_shift_code;
      end
  end
  
  //Next state logic
  always @*
  begin
    next_state = current_state;
    next_shift_code = shift_code;
    got_code = 1'b0;
    
    case(current_state)
      scan_st:
        if(scan_done)
          begin
            if(scan_out == BRK)
              begin
                next_state = break_st; //found break
                got_code = 1'b0;       //no output for break
              end
            else if(scan_out == SHIFT)
              begin
                next_shift_code = 1'b1; //set shift true
                got_code = 1'b0;        //no output for shift
              end
            else
              got_code = 1'b1;          //got some scan code
          end
      break_st:
        if(scan_done)
          begin
            next_state = scan_st;
            if(scan_out == SHIFT)
              next_shift_code = 1'b0; //found ending shift
          end
    endcase
  end
  
  
  assign code_out = {shift_code,scan_out}; 
  
endmodule
