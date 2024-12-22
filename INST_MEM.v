// Code your design here
module InstructionMemory(
  input wire [11:0] ReadAddress, //4kB is mapped by 12 bits
 output reg [31:0]  Instruction
);
  reg [7:0] InstructionMemory [0:4095]; // 4 kB of Instruction Memory
  always @(*) begin
    Instruction={InstructionMemory[ReadAddress],
                 InstructionMemory[ReadAddress+1],
                 InstructionMemory[ReadAddress+2],
                 InstructionMemory[ReadAddress+3]};    
    end 
  
endmodule
