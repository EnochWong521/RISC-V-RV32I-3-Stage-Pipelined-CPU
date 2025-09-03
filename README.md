# RISC-V RV32I 3-Stage Pipelined CPU

This project implements a 3-stage pipelined RISC-V RV32I CPU core in SystemVerilog, built from scratch to practice computer architecture and RTL design.  
The design is modular, with self-checking testbenches for each component and a top-level testbench that runs assembly programs loaded via `$readmemh`.

---

## Features
- Implements a subset of the **RV32I Base ISA**: integer arithmetic, logical operations, and simple branch instructions.
- **3 pipeline stages**:
  - **IF (Instruction Fetch)** – Program counter update and instruction memory access
  - **EX (Execute)** – Immediate generation, register file read, control decode, ALU operations, and branch target calculation
  - **WB (Writeback)** – Register file writeback of results
- **Pipeline control**:
  - Stall logic for load-use hazards  
  - Flush logic on taken branches
- **Modular design**:
  - Arithmetic Logic Unit (ALU)  
  - Register file (synchronous write, combinational read)  
  - Immediate generator  
  - Decoder / Control unit  
  - Pipeline registers  
  - Top-level core (`core_top`)
- Fully synthesizable (compatible with Vivado and FPGA flows)

---

## Repository Structure
```text
repo-root/
- rtl/           # RTL design files (SystemVerilog)
- tb/            # Testbenches + memory init files
- .gitignore
- README.md
