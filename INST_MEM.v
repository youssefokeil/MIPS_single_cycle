// Code your design here
module InstructionMemory(
 input [4:0] ReadAddress,
 output reg [31:0]  Instruction
);
  reg [7:0] InstructionMemory [0:4095]; // 4 kB of Instruction Memory
  always @(*) begin
    Instruction=InstructionMemory[ReadAddress];    
    end 
  
endmodule
