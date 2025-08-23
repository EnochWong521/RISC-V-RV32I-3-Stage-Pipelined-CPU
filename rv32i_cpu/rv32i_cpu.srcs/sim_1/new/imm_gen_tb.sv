`timescale 1ns / 1ps

module imm_gen_tb;
    logic [31:0] inst; 
    logic [31:0] imm_i;
    logic [31:0] imm_b;
    
    imm_gen DUT (
        .inst(inst),
        .imm_i(imm_i),
        .imm_b(imm_b)
    );
    
    task show(string name, logic [31:0] val);
        $display("%s = 0x%08h (signed %0d)", name, val, $signed(val));
    endtask
    
    initial begin
        // I-type ADDI x1,x0, -1
        inst = 32'b111111111111_00000_000_00001_0010011; // imm[11:0]=0xFFF, rs1=x0, rd=x1, opcode=0x13
        #1; 
        show("imm_i (ADDI -1)", imm_i);

        // I-type ADDI x2,x0, +5
        inst = 32'b000000000101_00000_000_00010_0010011;
        #1; 
        show("imm_i (ADDI +5)", imm_i);

        // B-type BEQ x0,x0, +8 bytes
        inst = 32'b0_000000_00000_00000_000_0100_0_1100011; // rs1=x0, rs2=x0, funct3=000, opcode=0x63
        #1; 
        show("imm_b (BEQ +8)", imm_b);

        // B-type BEQ x0,x0
        inst = 32'b1_111110_00000_00000_000_1111_1_1100011; // rs1=x0, rs21=x0, funct3=000, opcode=0x63
        #1; 
        show("imm_b (BEQ -4, demo)", imm_b);

    $finish;
  end
endmodule
