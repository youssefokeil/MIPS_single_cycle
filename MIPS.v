/// including for eda playground
/*
`include "ALU.svh"
`include "DATA_MEMORY.svh"
`include "INST_MEM.svh"
`include "REG.svh"
`include "SIGN_EXT.svh"
`include "CONTROL.svh"
`include "PC.svh"
`include "ALU_ctrl.svh"
*/

// Code your design here
module MIPS(
	input clk
);
  
  // Making the wires needed
  wire [31:0] read_data1, 
  read_data2, 
  ALU_result, 
  in_B, 
  instruction, 
  read_data_mem, 
  data_in_reg, 
  imm_extend;
  
  // flags
  wire z_flag,c_flag;
  
  // data_inst type
  wire data_inst;
  
  // control wires
  wire reg_write, 
  reg_dst,branch, 
  mem_read, 
  mem_to_reg,  
  mem_write,
  alu_src; 
  wire [1:0] ALU_ctl;
  
  wire [4:0] write_register;
  wire [5:0] funct;
  wire [1:0] alu_op;
  wire [31:0] current_pc, next_pc; //we only need 12 bits to map a 4kB memory
  
    
  // instantiting of the modules
  
  /////////////////////////////////////////////////
  //////////////// ALU ////////////////////////////
  ALU alu(.A(read_data1),
          .B(in_B),
          .ALU_ctl(ALU_ctl),
          .ALU_out(ALU_result),
          .zero_flag(z_flag),
          .c_flag(c_flag));
  
  ////////////////////////////////////////////////////
  ////////////// ALU Control ////////////////////////
  ALU_ctrl alu_ctrl(.funct(instruction[5:0]),
                    .ALU_op(alu_op),
                    .ALU_ctl(ALU_ctl)); 	
  
  // in_B needs a MUX
  assign in_B = (alu_src==1) ? imm_extend : read_data2;
  
  
  ////////////////////////////////////////////////
  ///////////////// Register /////////////////////
  Register register(.ReadRegister1(instruction[25:21]),
                    .ReadRegister2(instruction[20:16]), 
                    .WriteRegister(write_register),
                    .WriteData(data_in_reg), 
                    .ReadData1(read_data1),
                    .ReadData2(read_data2),
                    .RegWrite(reg_write),
                    .clk(clk));
  
  // write data in reg needs MUX 
  assign data_in_reg = mem_to_reg ? read_data_mem : ALU_result;
  
  // write register needs a MUX rt or rd?
  assign write_register = (reg_dst==1) ? instruction[15:11] : instruction[20:16];
  
  
  ///////////////////////////////////////////////////
  ////////////// Instruction Memory ////////////////
  InstructionMemory inst_mem (.Instruction(instruction),
                              .ReadAddress(current_pc[11:0]));
  
  
  ///////////////////////////////////////////////////
  /////////////// Program Counter //////////////////
  PC pc(.clk(clk),
        .current_inst(current_pc),
        .next_inst(next_pc));
  
  // we need logic for branching for beq
  assign next_pc = (branch && z_flag) ? (current_pc+4+(imm_extend<<2)):(current_pc+4);


  ////////////////////////////////////////////////////
  ///////////////////// CONTROL /////////////////////
  ControlUnit control (.opcode(instruction[31:26]),            
                       .RegDst(reg_dst),
                       .Branch(branch),
                       .MemRead(mem_read),
                       .MemtoReg(mem_to_reg),
                       .ALUOp(alu_op),
                       .MemWrite(mem_write),
                       .ALUSrc(alu_src),
                       .RegWrite(reg_write));


  /////////////////////////////////////////////////////
  //////////////// DATA MEMORY ////////////////////////
  Data_Memory data_mem (.address(ALU_result[13:0]),
                        .inst_type(data_inst),
                        .data_in(read_data2),
                        .Data_out(read_data_mem),
                        .clk(clk));
  // need mux for data_inst
  assign data_inst = mem_write ? 1 : 0; // only time we write is in sw


  ////////////////////////////////////////////////////////
  /////////// sign extension /////////////////////////////
  SignExtension extension (.immediate(instruction[15:0]),
                           .extended(imm_extend));
  
endmodule
