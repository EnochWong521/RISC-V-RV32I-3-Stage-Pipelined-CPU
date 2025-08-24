`timescale 1ns / 1ps

module decoder(
    input [31:0] inst,
    output alu_op_e alu_op,
    output logic use_imm,
    output logic reg_write,
    output logic is_write,
    output logic [4:0] rs1, rs2, rd
    );
    
    
endmodule
