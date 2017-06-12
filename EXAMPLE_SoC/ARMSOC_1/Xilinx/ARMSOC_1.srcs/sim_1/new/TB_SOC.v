`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2017 03:03:24 PM
// Design Name: 
// Module Name: TB_SOC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module TB_SOC();

reg CLK;
reg RESETn;


wire [7:0] LED;
        
        
 AHBLITE_SYS uut(
            //CLOCKS & RESET
            .CLK(CLK),
            .RESETn(RESETn), 
            
            //TO BOARD LEDs
            .LED(LED)
        
        );
        
  initial begin
  CLK = 0;
  RESETn=0;   
  
  #200;
  
  RESETn=1;
  
  #400;
  RESETn=0;
  
  end
  
  always begin
  #10 CLK = !CLK;
  end
  

  
   

    
endmodule
