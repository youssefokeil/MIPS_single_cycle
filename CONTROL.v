// Code your design here
module ControlUnit(
  input [5:0] opcode,
  output reg RegDst,
  output reg Branch,
  output reg MemRead,
  output reg MemtoReg,
  output reg[1:0] ALUOp,
  output reg MemWrite,
  output reg ALUSrc,
  output reg RegWrite
);
  always@(*)
    begin
      case(opcode) 
        // R-format (add, sub)
        0: begin // r-format add & sub
          RegDst = 0; // rt
          Branch = 0; //No branching
          MemRead = 0; // no read op
          MemtoReg = 0; // rd is from ALU
          ALUOp = 2'b10; // don't care will be set by funct field
          MemWrite = 0; // not write anything in memory
          ALUSrc = 0; // from register 
          RegWrite = 1; //will write in rd
        end
        
        // lw instruction
        35: begin // lw opcode
          RegDst = 0; // rt
          Branch = 0; //No branching
          MemRead = 1; // read op
          MemtoReg = 1; // will load from memory
          ALUOp = 2'b00; // add inst
          MemWrite = 0; // not write in mem
          ALUSrc = 1; // from immediate 
          RegWrite = 1; //will write in rt
        end
        
        // sw instruction
        43: begin // sw opcode
          RegDst = 1'bX; // not write in reg
          Branch = 0; //No branching
          MemRead = 0; // not reading op
          MemtoReg = 1'bX; // no write in reg
          ALUOp = 2'b00; // add inst
          MemWrite = 1; // write in mem
          ALUSrc = 1; // from immediate 
          RegWrite = 0; //will not write in reg
        end  
        // beq instruction
        4: begin // beq opcode
          RegDst = 1'bX; // not write in reg
          Branch = 1; // branching
          MemRead = 0; // not reading op
          MemtoReg = 1'bX; // no write in reg
          ALUOp = 2'b01; // sub inst
          MemWrite = 0; // write in mem
          ALUSrc = 0; // from reg 
          RegWrite = 0; //will not write in reg    
        end
          
          /// not supported instructions
          default: begin         
          RegDst = 0; 
          Branch = 0; 
          MemRead = 0;
          MemtoReg = 0; 
          ALUOp = 2'b00;
          MemWrite = 0;  
          ALUSrc = 0;  
          RegWrite = 0;
        end
        
      endcase
    end
endmodule
