module prescaler(
  input wire inclk,
  output wire outclk
    );

reg [3:0] counter;

always @(posedge inclk)
  counter <= counter + 1'b1;
  
assign outclk = counter == 4'b1111;

endmodule
