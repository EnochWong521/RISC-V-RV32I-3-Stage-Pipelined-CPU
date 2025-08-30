`timescale 1ns / 1ps

module core_top_tb;
    logic clk = 0;
    logic reset_n;
    
    // maintain scoreboard for registers
    logic [31:0] regs[0:31];
    int i;
    // parameter for indicating end of program
    localparam logic [31:0] EBREAK = 32'h0010_0073;
    
    // dut instantiation
    core_top dut(
        .clk(clk),
        .reset_n(reset_n)
    );
    
    // clock signal
    always #1 clk = ~clk;
    
    // check WB stage
    always_ff @(posedge clk) begin
        if (reset_n && dut.wb_we && (dut.wb_rd !== 5'b0)) begin
            regs[dut.wb_rd] <= dut.wb_result;
            $display("Register address: %0d, register value: 0x%08h", dut.wb_rd, dut.wb_result);
        end
    end
    
    // check values in scoreboard
    initial begin
        // reset score board and signals
        for (i = 0; i < 32; i++) begin
            regs[i] = 32'h0;
        end
        reset_n = 0;
        @(posedge clk);
        reset_n = 1;
        
        // wait for program to finish 
        wait (dut.ex_inst == EBREAK);
        @(posedge clk);
        
        // prog.mem computes x1=5, x2=7, x3=x1+x2=12, x4=1 (branch not taken)
        // check if contents of writeback lines up
        assert(regs[1] == 32'd5) 
            else $fatal("Expected value of 5. Got 0x%08h instead", regs[1]);
        assert(regs[2] == 32'd7) 
            else $fatal("Expected value of 7. Got 0x%08h instead", regs[2]); 
        assert(regs[3] == 32'd12) 
            else $fatal("Expected value of 12. Got 0x%08h instead", regs[3]);
        assert(regs[4] == 32'd1) 
            else $fatal("Expected value of 1. Got 0x%08h instead", regs[4]); 
        $display("Testbench passed");
        $finish;
    end
    
    
    
endmodule
