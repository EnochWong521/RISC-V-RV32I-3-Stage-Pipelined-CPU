`timescale 1ns / 1ps

import types_pkg::*;

module decoder(
    input [31:0] inst,
    output alu_op_e alu_op,
    output logic use_imm,
    output logic reg_write,
    output logic is_branch,
    output logic [4:0] rs1, rs2, rd
    );
    
    // extract partially common fields
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;
    
    assign opcode = inst[6:0];
    assign funct3 = inst[14:12];
    assign funct7 = inst[31:25];
    
    // extract universally common field for B, I, R type instructions
    assign rd = inst[11:7];
    assign rs1 = inst[19:15];
    assign rs2 = inst[24:20];
    
    // categorize by instruction-type. Further process with function code
    // R-type
    localparam logic [6:0] OP = 7'h33;
    // I-type
    localparam logic [6:0] OP_IMM = 7'h13;
    // B-type
    localparam logic [6:0] BRANCH = 7'h63;
    
    // operation processing
    always_comb begin
        // default values
        reg_write = 0;
        alu_op = ALU_ADD;
        use_imm = 0;
        is_branch = 0;
        unique case (opcode)
            // R-type
            OP: begin
                reg_write = 1'b1;
                unique case (funct3)
                    3'b000: alu_op = (funct7 == 7'h20)? ALU_SUB:ALU_ADD;
                    3'b111: alu_op = ALU_AND;
                    3'b110: alu_op = ALU_OR;
                    3'b100: alu_op = ALU_XOR;
                    3'b001: alu_op = ALU_SLL;
                    3'b101: alu_op = (funct7 == 7'h20)? ALU_SRA: ALU_SRL;  
                endcase
            end
            // I-type
            OP_IMM: begin
                use_imm = 1'b1;
                reg_write = 1'b1;
            end
            // B-type
            BRANCH: begin
                is_branch = 1'b1;
            end 
            default:;
        endcase
    end
    
endmodule
