module ALU_ctrl (
  input wire [1:0] ALU_op,
  input wire [5:0] funct,
  
  output reg [1:0] ALU_ctl
);   
  always @(*) begin
    // Default value assignment
    ALU_ctl = 2'b00;
    
    case (ALU_op)
      2'b01: ALU_ctl = 2'b01; // sub
      2'b00: ALU_ctl = 2'b00; // add
      2'b10: begin // r-format
        case (funct)
          6'b100000: ALU_ctl = 2'b00; // add
          6'b100010: ALU_ctl = 2'b01; // sub
          default: ALU_ctl = 2'b00;   // default to add (if funct is unrecognized)
        endcase
      end
      default: ALU_ctl = 2'b00; // default to add (if ALU_op is unrecognized)
    endcase
  end
endmodule
