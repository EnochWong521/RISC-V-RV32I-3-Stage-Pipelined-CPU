# RISC-V RV32I (Subset) 3-Stage Pipelined CPU

This project implements a 3-stage pipelined RISC-V RV32I CPU core in SystemVerilog, built from scratch to learn computer architecture and RTL design.  
The design is organized into modular components with testbenches for each, plus a top-level testbench that runs assembly programs loaded via `$readmemh`.

---

## Features
- Subset of RV32I Base ISA (integer arithmetic, logic, and simple branch instructions)
- 3 pipeline stages:
  - IF (Instruction Fetch) - PC update, instruction memory read
  - ID (Instruction Decode) - register file read, immediate generation, control decode
  - EX/WB (Execute + Writeback) - ALU operations, branch target calculation, register writeback
- Pipeline control:
  - Stall logic for load-use hazards
  - Pipeline flush on taken branches
- Modular design:
  - ALU
  - Register file (synchronous write, combinational read)
  - Immediate generator
  - Decoder / Control unit
  - Pipeline registers
  - Top-level core (`core_top`)
- Fully synthesizable (works in Vivado / FPGA flows)

---

## Repo Structure
```text
repo-root/
- rtl/             # RTL design files (SystemVerilog)
- tb/              # Testbenches + memory init files
- rv32i_cpu/       # Original Vivado project folder (ignored except .xpr)
- vivado.tcl       # Script to rebuild clean project in Vivado
- .gitignore
- README.md