`timescale 1ns / 1ps

import types_pkg::*;

module core_top(
    input logic clk,
    input logic reset_n
    );
    
    // Shell + PC/IF fetch
    // ROM module for instruction memory. Combinational read
    localparam int IMEM_WORDS = 256;
    logic [31:0] imem [0:IMEM_WORDS-1];
    
    // read instruction memory from hex file
    initial begin
        $readmemh("prog.mem", imem);
    end
    
    // PC and IF instructions
    // current PC from flip flop q output
    logic [31:0] pc_q;
    // next program count
    logic [31:0] pc_n;
    // instruction fetched from IF stage
    logic [31:0] if_inst;
    
    // word-aligned fetch. remove lower 2 bits
    logic [31:0] inst_f;
    assign inst_f = imem[pc_q[31:2]];
    
    // default next PC
    logic [31:0] pc_plus4;
    assign pc_plus4 = pc_q + 32'd4;
    
    //assign pc_n = pc_plus4;
    
    // IF pipeline register. IF side of IF/EX reg
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            pc_q <= '0;
            if_inst <= NOP;
        end
        else begin
            pc_q <= pc_n;
            if_inst <= inst_f;
        end
    end
    
    // EX/WB stage registers
    logic [31:0] ex_pc, ex_inst;
    
    // EX stage fetch signal from previous IF stage 
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            ex_pc <= '0;
            ex_inst <= NOP;
        end
        else begin
            // last cycle's PC
            ex_pc <= pc_q;
            // last cycle's instruction
            ex_inst <= if_inst;
        end    
    end
    
    //structural design. module declarations
    // decode EX stage instruction
    ctrl_t ex_ctrl;
    logic [4:0] ex_rs1, ex_rs2, ex_rd;
    
    // decoder block for EX stage
    decoder u_decoder(
        .inst(ex_inst),
        .ctrl(ex_ctrl),
        .rs1(ex_rs1),
        .rs2(ex_rs2),
        .rd(ex_rd)
    );
    
    // immediate generation
    logic [31:0] imm_i, imm_b;
    
    imm_gen u_imm(
        .inst(ex_inst),
        .imm_i(imm_i),
        .imm_b(imm_b)
    );
    
    logic wb_we;
    logic [4:0] wb_rd;
    logic [31:0] wb_result;
    logic [31:0] rs1_value, rs2_value;
    
    // register file
    regfile u_regfile(
        .clk(clk),
        .wb(wb_we),
        .waddr(wb_rd),
        .wdata(wb_result),
        .raddr1(ex_rs1),
        .raddr2(ex_rs2),
        .rdata1(rs1_value),
        .rdata2(rs2_value)
    );
    
    // WB to EX forwarding
    logic [31:0] fwd_rs1, fwd_rs2;
    // enable signals for forwarding. three conditions for forwarding: 
    // 1. WB stage is active
    // 2. WB stage register destination is not x0
    // 3. WB stage register destination conflicts with the rs1 or rs2 EX stage is trying to access
    logic fwd_rs1_en, fwd_rs2_en;
    assign fwd_rs1_en = wb_we && (wb_rd !== 5'd0) && (wb_rd == ex_rs1);
    assign fwd_rs2_en = wb_we && (wb_rd !== 5'd0) && (wb_rd == ex_rs2); 
    // forward wb result if enabled 
    assign fwd_rs1 = fwd_rs1_en? wb_result : rs1_value;
    assign fwd_rs2 = fwd_rs2_en? wb_result : rs2_value;
    
    // ALU module instantiation
    logic [31:0] alu_a, alu_b, alu_y;
    assign alu_a = fwd_rs1;
    assign alu_b = ex_ctrl.use_imm? imm_i : fwd_rs2;
    
    alu u_alu (
        .a(a),
        .b(b),
        .op(ex_ctrl.alu_op),
        .y(alu.y)
    );
    
    // writeback
    assign wb_result = alu_y;
    assign wb_rd = ex_rd;
    assign wb_we = ex_ctrl.reg_write;
    
    // branch decision and flush 
    // BEQ instruction
    logic branch_taken;
    assign branch_taken = ex_ctrl.is_branch && (fwd_rs1 == fwd_rs2);
    logic [31:0] branch_target;
    assign branch_target = ex_pc + imm_b;
    
    // determine if branch is taken 
    assign pc_n = branch_taken? branch_target : pc_plus4;
    
    // when branch is taken, squash IF instruction. one cycle penalty
    always_ff @(posedge clk or negedge reset_n) begin
        // skip reset boolean statement since it is already handled above
        if (branch_taken)
            if_inst = NOP; 
    end
endmodule
