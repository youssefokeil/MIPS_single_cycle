module ALU(
  input [31:0] A, B,
  input [1:0] ALU_ctl,
  
  output reg c_flag, // Carry flag
  output reg [31:0] ALU_out,
  output reg zero_flag // Zero flag
);

  always @(A, B, ALU_ctl) begin
    case (ALU_ctl)
      2'b00: begin // Add
        ALU_out = A + B;
        c_flag = (ALU_out < A); // Carry flag (detect overflow)
      end
      2'b01: begin // Subtract
        ALU_out = A - B;
        c_flag = (A < B); // Carry flag (borrow detected)
      end
      default: begin
        ALU_out = 32'b0; // Default to 0 for unsupported operations
        c_flag = 0;
      end
    endcase
  end
  
  // Zero flag (set if ALU_out is zero)
  assign zero_flag = (ALU_out == 0) ? 1 : 0;

endmodule
