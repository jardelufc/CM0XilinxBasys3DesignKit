module dual_port_ram_sync
  #(
      parameter ADDR_WIDTH = 6,
      parameter DATA_WIDTH = 8
  )
  (
  input wire clk,
  input wire we,
  input wire [ADDR_WIDTH-1:0] addr_a,
  input wire [ADDR_WIDTH-1:0] addr_b,
  input wire [DATA_WIDTH-1:0] din_a,
  
  output wire [DATA_WIDTH-1:0] dout_a,
  output wire [DATA_WIDTH-1:0] dout_b
  );

  reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
  reg [ADDR_WIDTH-1:0] addr_a_reg;
  reg [ADDR_WIDTH-1:0] addr_b_reg;
  
  always @ (posedge clk)
  begin
    if(we)
      ram[addr_a] <= din_a;
    addr_a_reg <= addr_a;
    addr_b_reg <= addr_b;
  end
  
  assign dout_a = ram[addr_a_reg];
  assign dout_b = ram[addr_b_reg];
  
endmodule
