// header file
package types_pkg;
    // ALU operations
    typedef enum logic [3:0] {
        ALU_ADD,
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

endpackage
