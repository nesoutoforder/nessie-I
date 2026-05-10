module pc_next_unit
    import rv32_pkg::*;
(
    input   word_t          pc_i,
    input   word_t          imm_i,
    input   word_t          rs1_data_i,

    input   logic           branch_taken_i,

    input   logic           jump_i,
    input   logic           jump_reg_i,

    output  word_t          pc_next_o,
    output  word_t          pc_plus4_o,
    output  word_t          pc_imm_o
);

    assign pc_plus4_o  = pc_i + 32'd4;
    assign pc_imm_o = pc_i + imm_i;

    always_comb begin
        pc_next_o = pc_plus4_o;

        if (branch_taken_i)
            pc_next_o = pc_imm_o;

        if (jump_i)
            pc_next_o = pc_imm_o;

        if (jump_reg_i)
            pc_next_o = (rs1_data_i + imm_i) & 32'hFFFF_FFFE;
    end

endmodule
