import types_pkg::*;

// alu ports
// no flags in risc architecture
module alu(
    input  logic [31:0] a, b,
    input  alu_op_e op,
    output logic [31:0] y
);
    
    // alu logic 
    always_comb begin
        unique case (op)
            ALU_SUB: y = a - b;
            ALU_AND: y = a & b;
            ALU_OR: y = a | b;
            ALU_XOR: y = a ^ b;
            ALU_SLL: y = a << b[4:0];
            ALU_SRL: y = a >> b[4:0];
            ALU_SRA: y = $signed(a) >>> b[4:0]; 
            ALU_COPY_B: y = b;
            default: y = 32'hDEAD_CODE;
        endcase
    end

endmodule
