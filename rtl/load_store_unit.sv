module load_store_unit
    import rv32_pkg::*;
(
    input  funct3_t  funct3_i,
    input  word_t    addr_i,
    input  word_t    store_data_i,
    input  word_t    dmem_rdata_i,

    output byte_en_t dmem_wstrb_o,
    output word_t    dmem_wdata_o,
    output word_t    load_data_o
);

    logic [7:0]  load_byte;
    logic [15:0] load_half;

    always_comb begin
        load_byte    = '0;
        load_half    = '0;
        dmem_wstrb_o = 4'b0000;
        dmem_wdata_o = '0;
        load_data_o  = dmem_rdata_i;

        unique case (funct3_i)

            // LB / SB
            3'b000: begin
                load_byte = dmem_rdata_i[8*addr_i[1:0] +: 8];
                load_data_o = {{24{load_byte[7]}}, load_byte};

                dmem_wstrb_o = 4'b0001 << addr_i[1:0];
                dmem_wdata_o = word_t'(store_data_i[7:0]) << (8 * addr_i[1:0]);
            end

            // LH / SH
            3'b001: begin
                load_half = addr_i[1] ? dmem_rdata_i[31:16] : dmem_rdata_i[15:0];
                load_data_o = {{16{load_half[15]}}, load_half};

                dmem_wstrb_o = addr_i[1] ? 4'b1100 : 4'b0011;
                dmem_wdata_o = addr_i[1] ? {store_data_i[15:0], 16'b0}
                                          : {16'b0, store_data_i[15:0]};
            end

            // LW / SW
            3'b010: begin
                load_data_o  = dmem_rdata_i;
                dmem_wstrb_o = 4'b1111;
                dmem_wdata_o = store_data_i;
            end

            // LBU
            3'b100: begin
                load_byte = dmem_rdata_i[8*addr_i[1:0] +: 8];
                load_data_o = {24'b0, load_byte};
            end

            // LHU
            3'b101: begin
                load_half = addr_i[1] ? dmem_rdata_i[31:16] : dmem_rdata_i[15:0];
                load_data_o = {16'b0, load_half};
            end

            default: begin
                load_data_o  = dmem_rdata_i;
                dmem_wstrb_o = 4'b0000;
                dmem_wdata_o = '0;
            end
        endcase
    end

endmodule
