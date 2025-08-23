`timescale 1ns / 1ps

module alu_tb;
    logic [31:0] a, b;
    alu_op_e op;
    logic [31:0] y;
    
    alu DUT(
        .a(a),
        .b(b),
        .op(op),
        .y(y)
    );
    
    task run(input alu_op_e op_code, input [31:0] a_in, b_in, string op_name);
        a = a_in;
        b = b_in;
        op = op_code;
        #1;
        $display("%s: a = 0x%08h, b = 0x%08h, y = 0x%08h", op_name, a, b, op);
    endtask
    
    initial begin
        run(ALU_ADD, 32'd5, 32'd7, "ADD");
        run(ALU_SUB, 32'd10, 32'd3, "SUB");
        run(ALU_AND, 32'hF0F0, 32'h0FF0, "AND");
        run(ALU_OR,  32'hF0F0, 32'h0FF0, "OR");
        run(ALU_XOR, 32'hAAAA, 32'h5555, "XOR");
        run(ALU_SLL, 32'd1, 32'd4, "SLL");
        run(ALU_SRL, 32'h8000_0000, 32'd4, "SRL");
        run(ALU_SRA, 32'h8000_0000, 32'd4, "SRA");
        run(ALU_COPY_B, 32'd123, 32'd456, "COPY_B");
        $finish;
    end
    
endmodule
