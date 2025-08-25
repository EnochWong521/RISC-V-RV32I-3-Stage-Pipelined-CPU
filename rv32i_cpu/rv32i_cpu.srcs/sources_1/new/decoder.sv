`timescale 1ns / 1ps

import types_pkg::*;

module decoder(
    input [31:0] inst,
    output ctrl_t ctrl,
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
        ctrl.reg_write = 0;
        ctrl.alu_op = ALU_ADD;
        ctrl.use_imm = 0;
        ctrl.is_branch = 0;
        unique case (opcode)
            // R-type
            OP: begin
                ctrl.reg_write = 1'b1;
                unique case (funct3)
                    3'b000: ctrl.alu_op = (funct7 == 7'h20)? ALU_SUB:ALU_ADD;
                    3'b111: ctrl.alu_op = ALU_AND;
                    3'b110: ctrl.alu_op = ALU_OR;
                    3'b100: ctrl.alu_op = ALU_XOR;
                    3'b001: ctrl.alu_op = ALU_SLL;
                    3'b101: ctrl.alu_op = (funct7 == 7'h20)? ALU_SRA: ALU_SRL;  
                endcase
            end
            // I-type
            OP_IMM: begin
                ctrl.use_imm = 1'b1;
                ctrl.reg_write = 1'b1;
            end
            // B-type
            BRANCH: begin
                ctrl.is_branch = 1'b1;
            end 
            default:;
        endcase
    end
    
endmodule
