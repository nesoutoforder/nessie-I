module tb_alu;

    import rv32_pkg::*;

    word_t      lhs;
    word_t      rhs;
    alu_op_e    op;
    word_t      result;

    alu DUT(
        .rhs_i(rhs),
        .lhs_i(lhs),
        .op_i(op),
        .result_o(result)
    );

    initial begin
        lhs = 32'd10;
        rhs = 32'd3;
        op = ALU_ADD;
        #1;
        assert(result == 32'd13);

        op = ALU_SUB;
        #1;
        assert(result == 32'd7);

        op = ALU_AND;
        #1;
        assert(result == 32'd2);

        op = ALU_OR;
        #1;
        assert(result == 32'd11);

        op = ALU_XOR;
        #1;
        assert(result == 32'd9);    

        lhs = 32'hFFFF_FFFF;
        rhs = 32'd1;
        op = ALU_SLL;
        #1;
        assert(result == 32'hFFFF_FFFE);

        op = ALU_SRL;
        #1;
        assert(result == 32'h7FFF_FFFF);

        op = ALU_SRA;
        #1;
        assert(result == 32'hFFFF_FFFF);

        op = ALU_SLT;
        #1;
        assert(result == 32'd1);

        op = ALU_SLTU;
        #1;
        assert(result == 32'd0);
        
        $display("ALU tests passed");
        $finish;
    end

endmodule