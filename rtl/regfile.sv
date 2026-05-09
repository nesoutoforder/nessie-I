module regfile
    import rv32_pkg::*;
(
    input   logic   clk_i,
    input   logic   rst_ni,

    input   reg_addr_t  rs1_addr_i,
    input   reg_addr_t  rs2_addr_i,
    output  word_t      rs1_data_o,
    output  word_t      rs2_data_o,
    
    input   logic       rd_we_i,
    input   reg_addr_t  rd_addr_i,
    input   word_t      rd_data_i        
);

    word_t  regs_q [REG_COUNT];

    assign  rs1_data_o = (rs1_addr_i == 5'd0) ? '0 : regs_q[rs1_addr_i];
    assign  rs2_data_o = (rs2_addr_i == 5'd0) ? '0 : regs_q[rs2_addr_i];

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if(!rst_ni) begin
            for(int i = 0; i < REG_COUNT; i++) begin
                regs_q[i] <= '0;
            end
        end else begin
            if(rd_we_i && rd_addr_i != 5'd0) begin
                regs_q[rd_addr_i] <= rd_data_i;
            end
        end
    end

endmodule
