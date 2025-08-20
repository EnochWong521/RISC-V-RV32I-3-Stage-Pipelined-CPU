`timescale 1ns / 1ps

module regfile(
    input logic clk,
    input logic we,
    input logic [4:0] waddr,
    input logic [31:0] wdata,
    input logic [4:0] raddr1, raddr2,
    output logic [31:0] rdata1, rdata2    
    );
    
    // 32x32 register array
    logic [31:0] register [31:0];
    
    // sequential write
    always_ff @(posedge clk) begin
        if (we && (waddr != 5'd0))
            register[waddr] <= wdata;
    end
    
    // combinational read
    assign rdata1 = (raddr1 == 0)? register[raddr1]:0;
    assign rdata2 = (raddr2 == 0)? register[raddr2]:0;
    assign register[0] = '0;
    
    // same cycle raw bypass
    
    // read during write bypass if needed
    
endmodule
