module tb_regfile;
    import rv32_pkg::*;

    logic clk;
    logic rst_n;

    reg_addr_t rs1_addr;
    reg_addr_t rs2_addr;
    word_t rs1_data;
    word_t rs2_data;

    logic rd_we;
    reg_addr_t rd_addr;
    word_t rd_data;

    regfile DUT(
        .clk_i(clk),
        .rst_ni(rst_n),

        .rs1_addr_i(rs1_addr),
        .rs2_addr_i(rs2_addr),
        .rs1_data_o(rs1_data),
        .rs2_data_o(rs2_data),

        .rd_we_i(rd_we),
        .rd_addr_i(rd_addr),
        .rd_data_i(rd_data)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        rs1_addr = '0;
        rs2_addr = '0;

        rd_we = 0;
        rd_addr = '0;
        rd_data = '0;

        #20;
        rst_n = 1;

        rd_we = 1;
        rd_addr = 5'd1;
        rd_data = 32'd123;

        @(posedge clk);
        @(negedge clk);

        rd_we = 0;
        rs1_addr = 5'd1;

        #1;
        assert(rs1_data == 32'd123);


        rd_we = 1;
        rd_addr = 5'd0;
        rd_data = 32'hFFFF_FFFF;

        @(posedge clk);
        @(negedge clk);

        rd_we = 0;
        rs2_addr = 5'd0;
        #1;
        assert(rs2_data == 32'd0);

        $display("REGFILE tests passed");
        $finish;
    end

endmodule