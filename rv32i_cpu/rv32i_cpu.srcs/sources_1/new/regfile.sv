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
    
    // combinational read with raw bypass
    always_comb begin
        if (raddr1 == 0)
            rdata1 = 0;
        else if (we && (raddr1 == waddr) && (waddr != 0))
            rdata1 = wdata;
        else 
            rdata1 = register[raddr1];
    end
    
    always_comb begin
        if (raddr2 == 0)
            rdata2 = 0;
        else if (we && (raddr2 == waddr) && (waddr != 0))
            rdata1 = wdata;
        else 
            rdata1 = register[raddr2];
    end
    
endmodule
