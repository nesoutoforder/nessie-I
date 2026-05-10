module core
  import rv32_pkg::*;
(
    input  logic    clk_i,
    input  logic    rst_ni,

    output word_t   imem_addr_o,
    input  instr_t  imem_rdata_i,

    output byte_en_t dmem_wstrb_o,
    output word_t   dmem_addr_o,
    output word_t   dmem_wdata_o,
    input  word_t   dmem_rdata_i
);

    word_t pc;
    word_t pc_next;
    word_t pc_plus4;
    word_t pc_imm;
    logic  branch_taken;


    reg_addr_t rs1_addr;
    reg_addr_t rs2_addr;
    reg_addr_t rd_addr;

    word_t rs1_data;
    word_t rs2_data;

    decode_ctrl_t ctrl;

    word_t imm;
    word_t alu_rhs;
    word_t alu_result;

    word_t wb_data;

    funct3_t funct3;
    byte_en_t dmem_wstrb;
    word_t lsu_wdata;
    word_t load_data;

    assign funct3 = imem_rdata_i[14:12];


    pc_next_unit PC_NEXT_UNIT (
        .pc_i(pc),
        .imm_i(imm),
        .rs1_data_i(rs1_data),
        .branch_taken_i(branch_taken),
        .jump_i(ctrl.jump),
        .jump_reg_i(ctrl.jump_reg),
        .pc_next_o(pc_next),
        .pc_plus4_o(pc_plus4),
        .pc_imm_o(pc_imm)
    );

    if_stage # ( 
        .RESET_PC(32'h8000_0000)
    ) IF_STAGE (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .pc_next_i(pc_next),
        .pc_o(pc),
        .imem_addr_o(imem_addr_o)
    );

    decoder DECODER (
        .instr_i(imem_rdata_i),
        .rs1_addr_o(rs1_addr),
        .rs2_addr_o(rs2_addr),
        .rd_addr_o(rd_addr),
        .ctrl_o(ctrl)
    );

    imm_gen IMM_GEN (
        .instr_i(imem_rdata_i),
        .imm_type_i(ctrl.imm_type),
        .imm_o(imm)
    );

    regfile REGFILE (
        .clk_i(clk_i),
        .rst_ni(rst_ni),

        .rs1_addr_i(rs1_addr),
        .rs2_addr_i(rs2_addr),
        .rs1_data_o(rs1_data),
        .rs2_data_o(rs2_data),

        .rd_we_i(ctrl.rd_we),
        .rd_addr_i(rd_addr),
        .rd_data_i(wb_data)
    );

    always_comb begin
        if (ctrl.alu_src_imm)
            alu_rhs = imm;
        else
            alu_rhs = rs2_data;
    end

    alu ALU (
        .lhs_i(rs1_data),
        .rhs_i(alu_rhs),
        .op_i(ctrl.alu_op),
        .result_o(alu_result)
    );

    branch_compare BRANCH_COMPARE (
        .lhs_i(rs1_data),
        .rhs_i(alu_rhs),
        .branch_i(ctrl.branch),
        .branch_op_i(ctrl.branch_op),
        .taken_o(branch_taken)
    );

    load_store_unit LSU (
        .funct3_i(funct3),
        .addr_i(alu_result),
        .store_data_i(rs2_data),
        .dmem_rdata_i(dmem_rdata_i),

        .dmem_wstrb_o(dmem_wstrb),
        .dmem_wdata_o(lsu_wdata),
        .load_data_o(load_data)
    );
    
    wb_mux WB_MUX (
        .ctrl_i(ctrl),
        .alu_result_i(alu_result),
        .dmem_rdata_i(load_data),
        .pc_plus4_i(pc_plus4),
        .imm_i(imm),
        .pc_imm_i(pc_imm),
        .wb_data_o(wb_data)
    );

    dmem_req_unit DMEM_REQ_UNIT (
        .ctrl_i(ctrl),
        .addr_i(alu_result),
        .store_data_i(lsu_wdata),
        .wstrb_i(dmem_wstrb),
        .dmem_wstrb_o(dmem_wstrb_o),
        .dmem_addr_o(dmem_addr_o),
        .dmem_wdata_o(dmem_wdata_o)
    );

endmodule
