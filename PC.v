module PC(
  input wire[31:0] next_inst,
  input wire clk,
  output reg[31:0] current_inst
);
  always@(posedge clk) begin
  	current_inst <= next_inst;  
  end
endmodule
