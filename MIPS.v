// Code your design here
module MIPS();
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
  alu_src, 
  ALU_op;
  wire [5:0] funct, write_register;
  
  wire [1:0] alu_op;
  
    
  // instantiting of the modules
  
  /////////////////////////////////////////////////
  //////////////// ALU ////////////////////////////
  ALU alu(.A(read_data1),
          .B(in_B),
          .ALU_ctl(ALU_Op),
          .ALU_out(ALU_result),
          .zero_flag(z_flag),
          .c_flag(c_flag));
  
  // in_B needs a MUX
  assign in_B = alu_src ? imm_extend : read_data2;
  
    
  // ALU needs a mux for ALU_ctl
  assign ALU_ctl= (ALU_op==2'b10) ? (funct==32 ? 1 : 0) : ALU_op;
  
  
  ////////////////////////////////////////////////
  ///////////////// Register /////////////////////
  Register register(.ReadRegister1(instruction[25:21]),
                    .ReadRegister2(instruction[20:16]), 
                    .WriteRegister(write_register),
                    .WriteData(data_in_reg), 
                    .ReadData1(read_data1),
                    .ReadData2(read_data2),
                    .RegWrite(reg_write));
  // write data in reg needs MUX 
  assign data_in_reg = mem_to_reg ? read_data_mem : ALU_result;
  
  // write register needs a MUX rt or rd?
  assign write_register = reg_dst ? instruction[15:11] : instruction[20:16];
  
  
  ///////////////////////////////////////////////////
  ////////////// Instruction Memory ////////////////
  InstructionMemory inst_mem (.Instruction(instruction),
                              .ReadAddress(inst_read_add));
  
  // we need logic for branching
  assign inst_read_add = (branch && z_flag ) ? ((inst_read_add+4)+((imm_extend)<<2)):(inst_read_add+4);


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
  Data_Memory data_mem (.address(ALU_result),
                        .inst_type(data_inst),
                        .data_in(read_data2),
                        .Data_out(read_data_mem));
  // need mux for data_inst
  assign data_inst = mem_write ? 1 : 0; // only time we write is in sw


  ////////////////////////////////////////////////////////
  ///////// sign extension /////////////////////////////
  SignExtension extension (.immediate(instruction[15:0]),
                           .extended(imm_extend));
  
endmodule
