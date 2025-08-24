`timescale 1ns / 1ps

import types_pkg::*;

module decoder_tb;
    logic [31:0] inst;
    alu_op_e alu_op;
    logic use_imm, reg_write, is_branch;
    logic [4:0] rs1, rs2, rd;
    
    decoder DUT(
        .inst(inst),
        .alu_op(alu_op),
        .use_imm(use_imm),
        .reg_write(reg_write),
        .is_branch(is_branch),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd)
    );
    
    task check(string msg, bit cond); 
        if(!cond) 
            $error("FAIL: %s", msg); 
        else
            $display("PASS: %s", msg); 
    endtask

    initial begin
        // ADDI x1,x0,5 : 0x00500093
        inst = 32'h0050_0093; #1;
        check("ADDI use_imm", use_imm==1);
        check("ADDI reg_write", reg_write==1);
        check("ADDI not branch", is_branch==0);
        check("ADDI alu_op ADD", alu_op==ALU_ADD);

        // ADD x3,x1,x2 : funct7=0, funct3=000, opcode=0x33
        inst = 32'b0000000_00010_00001_000_00011_0110011; #1;
        check("ADD use_imm=0", use_imm==0);
        check("ADD reg_write=1", reg_write==1);
        check("ADD alu_op ADD", alu_op==ALU_ADD);

        // SUB x3,x1,x2 : funct7=0x20
        inst = 32'b0100000_00010_00001_000_00011_0110011; #1;
        check("SUB alu_op", alu_op==ALU_SUB);

        // BEQ x3,x4, imm(any) : opcode=0x63, funct3=000
        inst = 32'b0_000000_00100_00011_000_0000_0_1100011; #1;
        check("BEQ is_branch=1", is_branch==1);
        check("BEQ no reg_write", reg_write==0);
        $finish;
  end
endmodule
