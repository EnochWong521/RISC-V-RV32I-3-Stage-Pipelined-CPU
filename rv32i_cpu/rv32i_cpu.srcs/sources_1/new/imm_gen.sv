`timescale 1ns / 1ps

module imm_gen(
    input [31:0] inst,
    output [31:0] imm_i, // I-type instruction
    output [31:0] imm_b // B-type  instruction
);
    // extract raw fields from instruction
    // I-type
    logic [11:0] i_imm;
    assign i_imm = inst [31:20];
    // B-type
    logic [12:0] b_imm;
    assign b_imm = {inst [31], inst[7], inst[30:25], inst[11:8], 1'b0};
    
    // sign extension
    assign imm_i = {{20{i_imm[11]}}, i_imm};
    assign imm_b = {{19{b_imm[12]}}, b_imm};
    
endmodule
