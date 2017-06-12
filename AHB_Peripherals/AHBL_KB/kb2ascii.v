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

module kb2ascii
   (
    input wire [8:0] key_code,
    output reg [7:0] ascii_code
   );

   localparam lower = 0;
   localparam upper = 1;
   
always @*
case(key_code[8]) //no shift
  lower:
    case(key_code[7:0])
      8'h45: ascii_code = 8'h30;   // 0
      8'h16: ascii_code = 8'h31;   // 1
      8'h1e: ascii_code = 8'h32;   // 2
      8'h26: ascii_code = 8'h33;   // 3
      8'h25: ascii_code = 8'h34;   // 4
      8'h2e: ascii_code = 8'h35;   // 5
      8'h36: ascii_code = 8'h36;   // 6
      8'h3d: ascii_code = 8'h37;   // 7
      8'h3e: ascii_code = 8'h38;   // 8
      8'h46: ascii_code = 8'h39;   // 9
      8'h1c: ascii_code = 8'h61;   // a
      8'h32: ascii_code = 8'h62;   // b
      8'h21: ascii_code = 8'h63;   // c
      8'h23: ascii_code = 8'h64;   // d
      8'h24: ascii_code = 8'h65;   // e
      8'h2b: ascii_code = 8'h66;   // f
      8'h34: ascii_code = 8'h67;   // g
      8'h33: ascii_code = 8'h68;   // h
      8'h43: ascii_code = 8'h69;   // i
      8'h3b: ascii_code = 8'h6a;   // j
      8'h42: ascii_code = 8'h6b;   // k
      8'h4b: ascii_code = 8'h6c;   // l
      8'h3a: ascii_code = 8'h6d;   // m
      8'h31: ascii_code = 8'h6e;   // n
      8'h44: ascii_code = 8'h6f;   // o
      8'h4d: ascii_code = 8'h70;   // p
      8'h15: ascii_code = 8'h71;   // q
      8'h2d: ascii_code = 8'h72;   // r
      8'h1b: ascii_code = 8'h73;   // s
      8'h2c: ascii_code = 8'h74;   // t
      8'h3c: ascii_code = 8'h75;   // u
      8'h2a: ascii_code = 8'h76;   // v
      8'h1d: ascii_code = 8'h77;   // w
      8'h22: ascii_code = 8'h78;   // x
      8'h35: ascii_code = 8'h79;   // y
      8'h1a: ascii_code = 8'h7a;   // z
      8'h0e: ascii_code = 8'h60;   // `
      8'h4e: ascii_code = 8'h2d;   // -
      8'h55: ascii_code = 8'h3d;   // =
      8'h54: ascii_code = 8'h5b;   // [
      8'h5b: ascii_code = 8'h5d;   // ]
      8'h5d: ascii_code = 8'h5c;   // \
      8'h4c: ascii_code = 8'h3b;   // ;
      8'h52: ascii_code = 8'h27;   // '
      8'h41: ascii_code = 8'h2c;   // ,
      8'h49: ascii_code = 8'h2e;   // .
      8'h4a: ascii_code = 8'h2f;   // /

      8'h29: ascii_code = 8'h20;   // (space)
      8'h5a: ascii_code = 8'h0d;   // (enter, cr)
      8'h66: ascii_code = 8'h08;   // (backspace)
      default: ascii_code = 8'h2a; // *
    endcase
  default:
    case(key_code[7:0]) //shift
      8'h45: ascii_code = 8'h29;   // )
      8'h16: ascii_code = 8'h21;   // !
      8'h1e: ascii_code = 8'h40;   // @
      8'h26: ascii_code = 8'h23;   // #
      8'h25: ascii_code = 8'h24;   // $
      8'h2e: ascii_code = 8'h25;   // %
      8'h36: ascii_code = 8'h5e;   // ^
      8'h3d: ascii_code = 8'h26;   // &
      8'h3e: ascii_code = 8'h2a;   // *
      8'h46: ascii_code = 8'h28;   // (
      8'h1c: ascii_code = 8'h41;   // A
      8'h32: ascii_code = 8'h42;   // B
      8'h21: ascii_code = 8'h43;   // C
      8'h23: ascii_code = 8'h44;   // D
      8'h24: ascii_code = 8'h45;   // E
      8'h2b: ascii_code = 8'h46;   // F
      8'h34: ascii_code = 8'h47;   // G
      8'h33: ascii_code = 8'h48;   // H
      8'h43: ascii_code = 8'h49;   // I
      8'h3b: ascii_code = 8'h4a;   // J
      8'h42: ascii_code = 8'h4b;   // K
      8'h4b: ascii_code = 8'h4c;   // L
      8'h3a: ascii_code = 8'h4d;   // M
      8'h31: ascii_code = 8'h4e;   // N
      8'h44: ascii_code = 8'h4f;   // O
      8'h4d: ascii_code = 8'h50;   // P
      8'h15: ascii_code = 8'h51;   // Q
      8'h2d: ascii_code = 8'h52;   // R
      8'h1b: ascii_code = 8'h53;   // S
      8'h2c: ascii_code = 8'h54;   // T
      8'h3c: ascii_code = 8'h55;   // U
      8'h2a: ascii_code = 8'h56;   // V
      8'h1d: ascii_code = 8'h57;   // W
      8'h22: ascii_code = 8'h58;   // X
      8'h35: ascii_code = 8'h59;   // Y
      8'h1a: ascii_code = 8'h5a;   // Z
      8'h0e: ascii_code = 8'h7e;   // ~
      8'h4e: ascii_code = 8'h5f;   // _
      8'h55: ascii_code = 8'h2b;   // +
      8'h54: ascii_code = 8'h7b;   // {
      8'h5b: ascii_code = 8'h7d;   // }
      8'h5d: ascii_code = 8'h7c;   // |
      8'h4c: ascii_code = 8'h3a;   // :
      8'h52: ascii_code = 8'h22;   // "
      8'h41: ascii_code = 8'h3c;   // <
      8'h49: ascii_code = 8'h3e;   // >
      8'h4a: ascii_code = 8'h3f;   // ?

      8'h29: ascii_code = 8'h20;   // (space)
      8'h5a: ascii_code = 8'h0d;   // (enter, cr)
      8'h66: ascii_code = 8'h08;   // (backspace)
      default: ascii_code = 8'h2a; // *
      
    endcase
  endcase

endmodule
