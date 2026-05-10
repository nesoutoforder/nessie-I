module if_stage
  import rv32_pkg::*;
#(
    parameter word_t RESET_PC = 32'h8000_0000
)
(
    input  logic  clk_i,
    input  logic  rst_ni,

    input  word_t pc_next_i,

    output word_t pc_o,
    output word_t imem_addr_o
);

    word_t pc_q;

    assign pc_o        = pc_q;
    assign imem_addr_o = pc_q;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni)
            pc_q <= RESET_PC;
        else
            pc_q <= pc_next_i;
    end

endmodule
