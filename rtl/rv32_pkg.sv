package rv32_pkg;

    parameter int XLEN = 32;
    parameter int REG_COUNT = 32;

    typedef logic [XLEN-1:0]    word_t;
    typedef logic [4:0]         reg_addr_t;
    typedef logic [31:0]        instr_t;

    typedef logic [2:0] funct3_t;
    typedef logic [6:0] funct7_t;
    typedef logic [6:0] opcode_t;

    typedef enum logic [6:0] {  
        OPCODE_LUI      = 7'b0110111,
        OPCODE_AUIPC    = 7'b0010111,
        OPCODE_JAL      = 7'b1101111,
        OPCODE_JALR     = 7'b1100111,
        OPCODE_BRANCH   = 7'b1100011,
        OPCODE_LOAD     = 7'b0000011,
        OPCODE_STORE    = 7'b0100011,
        OPCODE_OP_IMM   = 7'b0010011,
        OPCODE_OP       = 7'b0110011
    } opcode_e;

    typedef enum logic [3:0] {
        ALU_ADD,
        ALU_SUB,
        ALU_AND,
        ALU_OR,
        ALU_XOR,
        ALU_SLL,
        ALU_SRL,
        ALU_SRA,
        ALU_SLT,
        ALU_SLTU
    } alu_op_e;

    typedef enum logic [2:0] {
        IMM_I,
        IMM_S,
        IMM_B,
        IMM_U,
        IMM_J
    } imm_type_e;

    typedef struct packed {
        logic       valid;
        alu_op_e    alu_op;
        logic       rd_we;
        logic       alu_src_imm;
    } decode_ctrl_t;

endpackage