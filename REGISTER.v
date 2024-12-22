// Code your design here
module Register(
  input [4:0] ReadRegister1,
  input [4:0] ReadRegister2,
  input [4:0] WriteRegister,
  input [31:0] WriteData,
  input RegWrite,
  input wire clk,
  
  output reg[31:0] ReadData1,
  output reg[31:0] ReadData2
);
  // register declaration
  reg [31:0] register [31:0]; // 32 registers each of size 32-bit
  
  always @(*) begin
    ReadData1 = register[ReadRegister1];
    ReadData2 = register[ReadRegister2];
  end
  always@(posedge clk) begin
    if(RegWrite)
      register[WriteRegister]<=WriteData;
  end
    
endmodule
