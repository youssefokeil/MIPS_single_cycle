// Code your design here
module ALU(
  input[31:0] A,B,
  input ALU_ctl,
  
  output reg c_flag,
  output [31:0] ALU_out,
  output zero_flag
);
  assign zero_flag= (ALU_out==0) ? 1 : 0;
  reg[31:0] reg_out;
  always@(A,B,ALU_ctl) begin
    case(ALU_ctl)
      0:{c_flag,reg_out} = A+B;   // if 0 do add
      1:{c_flag,reg_out} = A-B;	  // if 1 do subtract
      default: reg_out = 0;
    endcase  
  end
  assign ALU_out=reg_out;
endmodule
