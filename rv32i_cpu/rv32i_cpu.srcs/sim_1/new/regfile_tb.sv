`timescale 1ns / 1ps

module regfile_tb;
    logic clk = 0;
    logic we;
    logic [4:0] waddr;
    logic [31:0] wdata;
    logic [4:0] raddr1, raddr2;
    logic [31:0] rdata1, rdata2;
    
    integer success_cnt = 0;
    integer error_cnt = 0;
    integer test_cnt = 0;
    
    regfile DUT(
        .clk(clk), 
        .we(we),
        .waddr(waddr), 
        .wdata(wdata),
        .raddr1(raddr1), 
        .raddr2(raddr2),
        .rdata1(rdata1), 
        .rdata2(rdata2)
    );
    
    // task for writing to register
    task automatic write_reg(input [4:0] addr, input [31:0] data);
        we = 1;
        waddr = addr;
        wdata = data;
        @(posedge clk);
        we = 0;
        waddr = '0;
        wdata = '0;
        $display("Write Address: 0x%02h, Write Data: 0x%08h", waddr, wdata);
    endtask
    
    task automatic read_reg(input [4:0] addr1, addr2);
        raddr1 = addr1;
        raddr2 = addr2;
        $display("Read Address 1: 0x%02h, Read Data 1: 0x%08h, Read Address 2: 0x%02h, Read Data 2: 0x%08h", raddr1, rdata1, raddr2, rdata2);
    endtask
    
    task automatic compare(input [31:0] observed, input [31:0] expected);
        if (observed === expected) begin
            success_cnt++;
            $display("SUCCESS. Observed: 0x%08h, Expected: 0x%08h", observed, expected);
        end
        else begin
            error_cnt++;
            $display("ERROR. Observed: 0x%08h, Expected: 0x%08, 0x%08h", observed, expected);
        end
        test_cnt++;
    endtask
    
    // clock signal
    always #1 clk = ~clk; 
    
    initial begin
        // reset signals
        we = 0;
        waddr = '0;
        raddr1 = '0;
        raddr2 = '0;
        
        // write x1 = 0x42
        write_reg(5'd1, 32'h42);
        // read with port 1
        read_reg(5'd1, 5'd0);
        compare(rdata1, 32'h42);
        
        // check register x0
        write_reg(5'd0, 32'h99);
        read_reg(5'd0, 5'd0);
        compare(rdata1, 32'h0);
        
        // display summary
        $display("Test Count: %d, Success Count: %d, Error Count: %d", test_cnt, success_cnt, error_cnt);
    end
    
endmodule
