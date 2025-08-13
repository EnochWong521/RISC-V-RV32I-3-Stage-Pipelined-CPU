`timescale 1ns / 1ps

module regfile (
    input  wire clk,     // rising-edge clock
    input  wire rst_n,   // active-low reset
    input  wire we,      // write enable (synchronous)
    input  wire [4:0] ra1,     // read addr 1
    input  wire [4:0] ra2,     // read addr 2
    input  wire [4:0] wa,      // write addr
    input  wire [31:0] wd,      // write data
    output wire [31:0] rd1,     // read data 1 (combinational)
    output wire [31:0] rd2      // read data 2 (combinational)
);
endmodule
