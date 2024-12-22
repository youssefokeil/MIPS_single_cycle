// Code your testbench here
// or browse Examples
`timescale 1ns/1ps
module MIPS_tb;
  //////// dump file information ////////////////
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end 
  
  
  reg clk;
  integer i;
    // Instantiate the MIPS processor
  MIPS mips (clk);
  // 50 MHz clk frequency, 20 ns clock period
  always begin
    # 10 clk=~clk;
  end 
    
    // Test memory initialization
    initial begin
        // Initialize instruction memory with machine code instructions
        // For simplicity, we'll encode instructions in hex directly here
        // check the read me or the pdf to understand

      // lw $t0, 0($zero)
      mips.inst_mem.InstructionMemory[0] = 8'h8C;    // 1st byte (0x8C)
      mips.inst_mem.InstructionMemory[1] = 8'h08;    // Second byte (0x08)
      mips.inst_mem.InstructionMemory[2] = 8'h00;    // Third byte (0x00)
      mips.inst_mem.InstructionMemory[3] = 8'h00;    // Fourth byte (0x00)
	
      // lw $t1, 4($zero)
      mips.inst_mem.InstructionMemory[4] = 8'h8C;     //First byte (0x8C)
      mips.inst_mem.InstructionMemory[5] = 8'h09;     //Second byte (0x09)
      mips.inst_mem.InstructionMemory[6] = 8'h00;     //Third byte (0x00)
      mips.inst_mem.InstructionMemory[7] = 8'h04;     //Fourth byte (0x04)
      
	
	  // add $t2, $t1, $t0
      mips.inst_mem.InstructionMemory[8] = 8'h01;    // First byte (0x01)
      mips.inst_mem.InstructionMemory[9] = 8'h28;    // Second byte (0x28)
      mips.inst_mem.InstructionMemory[10] = 8'h50;   // Third byte (0x50)
	  mips.inst_mem.InstructionMemory[11] = 8'h20;   // Fourth byte (0x20)

	  // sub $t2, $t2, $t0
      mips.inst_mem.InstructionMemory[12] = 8'h01;   // First byte (0x01)
      mips.inst_mem.InstructionMemory[13] = 8'h48;   // Second byte (0x48)
      mips.inst_mem.InstructionMemory[14] = 8'h50;   // Third byte (0x50)
      mips.inst_mem.InstructionMemory[15] = 8'h22;   // Fourth byte (0x22)
	
      // sw $t2, 0($zero)
      mips.inst_mem.InstructionMemory[16] = 8'hAC;   // First byte (0xAC)
      mips.inst_mem.InstructionMemory[17] = 8'h0A;   // Second byte (0x0A)
      mips.inst_mem.InstructionMemory[18] = 8'h00;   // Third byte (0x00)
      mips.inst_mem.InstructionMemory[19] = 8'h00;   // Fourth byte (0x00)
	
	  // beq $t2, $t2, 4
      mips.inst_mem.InstructionMemory[20] = 8'h11;   // First byte (0x11)
      mips.inst_mem.InstructionMemory[21] = 8'h4A;   // Second byte (0x4A)
      mips.inst_mem.InstructionMemory[22] = 8'h00;    // Third byte (0x00)
      mips.inst_mem.InstructionMemory[23] = 8'h04;   // Fourth byte (0x04)
      
      // add $t1, $t1, $t1
      mips.inst_mem.InstructionMemory[40] = 8'h01;   // First byte (0x01)
      mips.inst_mem.InstructionMemory[41] = 8'h29;   // Second byte (0x29)
      mips.inst_mem.InstructionMemory[42] = 8'h48;    // Third byte (0x48)
      mips.inst_mem.InstructionMemory[43] = 8'h20;   // Fourth byte (0x20)
    

	  //  Data at address 0: 16
    mips.data_mem.data_memory[0] = 8'h00;    // First byte (0x00)
    mips.data_mem.data_memory[1] = 8'h00;    // Second byte (0x00)
    mips.data_mem.data_memory[2] = 8'h00;    // Third byte (0x00)
    mips.data_mem.data_memory[3] = 8'h10;    // Fourth byte (0x10)
	
    	// Data at address 4: 5
    mips.data_mem.data_memory[4] = 8'h00;    // First byte (0x00)
    mips.data_mem.data_memory[5] = 8'h00;    // Second byte (0x00)
    mips.data_mem.data_memory[6] = 8'h00;    // Third byte (0x00)
    mips.data_mem.data_memory[7] = 8'h05;    // Fourth byte (0x05)


        // Initialize the program counter to start from the first instruction
     mips.pc.current_inst = 32'b0;

      for(i = 0; i<32; i = i+1) begin
		mips.register.register[i] = 32'b0;
	  end
	
       #10
       clk=0; //start the clock
        
    end
    
  // Run for a set amount of time (e.g., 2000ns or 200 cycles)
    initial begin
        #400;
        $finish;
    end
    
    // Display messages for debugging purposes
    initial begin
      $monitor("Time: %0t, PC: %h, instruction: %h, $t0: %d, $t1: %d, $t2: %d, Mem[0:3]: %d, Mem[4:7]: %d", 
               $time, mips.pc.current_inst, 
               mips.instruction,
               mips.register.register[8], 
               mips.register.register[9], 
               mips.register.register[10],	{mips.data_mem.data_memory[0],mips.data_mem.data_memory[1],mips.data_mem.data_memory[2],mips.data_mem.data_memory[3]}, {mips.data_mem.data_memory[4],mips.data_mem.data_memory[5],mips.data_mem.data_memory[6],mips.data_mem.data_memory[7]});
    end
endmodule
