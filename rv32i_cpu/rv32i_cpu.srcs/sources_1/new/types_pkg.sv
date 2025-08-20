// rtl/types_pkg.sv
package types_pkg;
    // ALU operations
    typedef enum logic [3:0] {
        ALU_SUB,
        ALU_AND,
        ALU_OR,
        ALU_XOR,
        ALU_SLL,
        ALU_SRL,
        ALU_SRA,
        ALU_COPY_B
    } alu_op_e;

    // control signals derived from instruction decode
    typedef struct packed {
        logic use_imm;
        logic alu_op;
        logic reg_write;
    } ctrl_t;

    // 12 bit sign extension for I-type immediate functions
    function automatic logic [31:0] sign_ext12(input logic [11:0] imm12);
        // implement sign extension. replicate bit 11 into upper 20 bits
        sign_ext12 = {{20{imm12[11]}}, imm12};
    endfunction
endpackage
