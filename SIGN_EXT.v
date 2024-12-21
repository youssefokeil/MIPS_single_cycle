module SignExtension(
  input wire [15:0] immediate,
  output reg [31:0] extended,
);
  always@(*) begin
    if(immediate[15]==1)
      extended={16'b1111111111111111,immediate[15:0]};
    else
      extended={16'b0000000000000000,immediate[15:0]};
  
  end
endmodule
