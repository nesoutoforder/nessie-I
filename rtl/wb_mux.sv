module wb_mux
    import rv32_pkg::*;
(
    input  decode_ctrl_t ctrl_i,

    input  word_t alu_result_i,
    input  word_t dmem_rdata_i,
    input  word_t pc_plus4_i,
    input  word_t imm_i,
    input  word_t pc_imm_i,

    output word_t wb_data_o
);

    always_comb begin
        wb_data_o = alu_result_i;

        if (ctrl_i.wb_from_mem)
            wb_data_o = dmem_rdata_i;

        if (ctrl_i.wb_from_pc4)
            wb_data_o = pc_plus4_i;

        if (ctrl_i.wb_from_imm)
            wb_data_o = imm_i;

        if (ctrl_i.wb_from_pc_imm)
            wb_data_o = pc_imm_i;
    end

endmodule
