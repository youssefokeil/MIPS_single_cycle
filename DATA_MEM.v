// Code your design here

module Data_Memory #(
  parameter DATA_WIDTH=8, //8 BIT "byte-addressable"
  parameter MEMORY_SIZE=16384,
  parameter ADDRESS_LENGTH=$clog2(MEMORY_SIZE)
) (
   // assume there's no enable for read and write
  input [31:0] data_in,
  input [ADDRESS_LENGTH-1:0] address,
  input inst_type,
  input wire clk,
  
  output [31:0] Data_out
);
  // initialization of the memory
  reg [DATA_WIDTH-1:0] data_memory [0:MEMORY_SIZE-1];
  
  // register for data output
  reg [DATA_WIDTH-1:0] reg_out;
  always@(data_in, address, inst_type, Data_out, clk)
    begin
      if(inst_type==0) //lw
        reg_out= {data_memory[address],data_memory[address+1],data_memory[address+2],data_memory[address+3]};
      else //sw
         {data_memory[address],data_memory[address+1],data_memory[address+2],data_memory[address+3]}<=data_in;
          
        
    end
    
  assign Data_out=reg_out;
  
endmodule
