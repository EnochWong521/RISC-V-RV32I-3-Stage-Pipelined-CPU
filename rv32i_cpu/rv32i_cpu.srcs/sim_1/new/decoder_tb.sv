`timescale 1ns / 1ps

module decoder_tb;
    logic [31:0] inst;
    alu_op_e alu_op;
    logic use_imm, reg_write, is_branch;
    logic [4:0] rs1, rs2, rd;
endmodule
