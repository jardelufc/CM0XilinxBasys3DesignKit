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


module AHBDUMMY2(
  //Inputs
  input wire HSEL,
  input wire HCLK,
  input wire HRESETn,
  input wire [31:0] HADDR,
  input wire [1:0] HTRANS,
  input wire [31:0] HWDATA,
  input wire HWRITE,
  input wire HREADY,

  //Output
  output reg HREADYOUT,
  output reg [31:0] HRDATA
);

  //State parameters
  localparam [1:0] st_idle = 2'b00;
  localparam [1:0] st_wait = 2'b01;
  localparam [1:0] st_rw = 2'b10;

  //Register select parameters
  localparam [3:0] REG0 = 4'h0;
  localparam [3:0] REG1 = 4'h4;
  localparam [3:0] REG2 = 4'h8;
  localparam [3:0] REG3 = 4'hC;

  //State machine registers
  reg [1:0] current_state;
  reg [1:0] next_state;
  reg [3:0] wait_reg;
  reg [3:0] wait_next;

  reg HREADYOUT_next;

  //Data Regs
  reg [31:0] d_reg0;
  reg [31:0] d_reg1;
  reg [31:0] d_reg2;
  reg [31:0] d_reg3;

  //AHB-Lite Address Phase Regs
  reg last_HSEL;
  reg [31:0] last_HADDR;
  reg last_HWRITE;
  reg [1:0] last_HTRANS;


  always@ (posedge HCLK)
  begin
    if(HREADY)
      begin
        last_HSEL         <= HSEL;
        last_HADDR        <= HADDR;
        last_HWRITE       <= HWRITE;
        last_HTRANS       <= HTRANS;
      end
  end

  //State Machine
  always @(posedge HCLK, negedge HRESETn)
  begin
    if(!HRESETn)
      begin
        current_state <= st_idle;
        HREADYOUT <= 1'b0;
        wait_reg <= 4'h0;
      end
    else
      begin
        current_state <= next_state;
        HREADYOUT <= HREADYOUT_next;
        wait_reg <= wait_next;
      end
  end

  //Next State Logic
  always @*
  begin
    next_state = current_state;
    HREADYOUT_next = 1'b0;
    wait_next = wait_reg;
    case(current_state)
      st_idle:
        if(HSEL & HREADY)
          begin
            next_state = st_wait;
            case(HADDR[3:0])
              REG0:wait_next = 4'h0;
              REG1:wait_next = 4'h4;
              REG2:wait_next = 4'h8;
              REG3:wait_next = 4'hC;
              default: wait_next = 4'h0;
            endcase
          end
      st_wait:
        if(wait_reg == 0)
          begin
            next_state = st_idle;
            HREADYOUT_next = 1'b1;
          end
        else
          wait_next = wait_reg - 1'b1;
          
    endcase
  end





  //Register 0
  always @(posedge HCLK, negedge HRESETn)
  begin
    if(!HRESETn)
      d_reg0 <= 32'h0000_0000;
    else if(last_HSEL & last_HWRITE & last_HTRANS[1] & HREADYOUT)
      if(last_HADDR[3:0] == REG0)
        d_reg0 <= HWDATA;
  end


  //Register 1
  always @(posedge HCLK, negedge HRESETn)
  begin
    if(!HRESETn)
      d_reg1 <= 32'h0000_0000;
    else if(last_HSEL & last_HWRITE & last_HTRANS[1] & HREADYOUT)
      if(last_HADDR[3:0] == REG1)
        d_reg1 <= HWDATA;
  end

  //Register 2
  always @(posedge HCLK, negedge HRESETn)
  begin
    if(!HRESETn)
      d_reg2 <= 32'h0000_0000;
    else if(last_HSEL & last_HWRITE & last_HTRANS[1] & HREADYOUT)
      if(last_HADDR[3:0] == REG2)
        d_reg2 <= HWDATA;
  end

  //Register 3
  always @(posedge HCLK, negedge HRESETn)
  begin
    if(!HRESETn)
      d_reg3 <= 32'h0000_0000;
    else if(last_HSEL & last_HWRITE & last_HTRANS[1] & HREADYOUT)
      if(last_HADDR[3:0] == REG3)
        d_reg3 <= HWDATA;
  end

  //Multiplexer for Output
  always @*
  begin
    if(last_HSEL)
      case(last_HADDR[3:0])
        REG0:
          HRDATA = d_reg0;
        REG1:
          HRDATA = d_reg1;
        REG2:
          HRDATA = d_reg2;
        REG3:
          HRDATA = d_reg3;
        default:
          HRDATA = 0;
      endcase
    else
      HRDATA = 0;
  end

endmodule
