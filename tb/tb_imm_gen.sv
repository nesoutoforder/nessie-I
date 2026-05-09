module tb_imm_gen;

    import rv32_pkg::*;

    instr_t instr;
    imm_type_e imm_type;
    word_t imm;

    imm_gen DUT(
        .instr_i(instr),
        .imm_type_i(imm_type),
        .imm_o(imm)
    );

    initial begin
        // I-type: add x1, x0, 123
        instr = {12'd123, 5'd0, 3'b000, 5'd1, OPCODE_OP_IMM};
        imm_type = IMM_I;
        #1;
        assert(imm == 32'd123);

        // I-type negative: addi x1, x0, -1
        instr = {12'hFFF, 5'd0, 3'b000, 5'd1, OPCODE_OP_IMM};
        imm_type = IMM_I;
        #1;
        assert(imm == 32'hFFFF_FFFF);

        // S-type: sw x3, 16(x2)
        instr = {7'd0, 5'd3, 5'd2, 3'b010, 5'b10000, OPCODE_STORE};
        imm_type = IMM_S;
        #1;
        assert(imm == 32'd16);

        // S-type negative: sw x3, -4(x2)
        instr = {7'b1111111, 5'd3, 5'd2, 3'b010, 5'b11100, OPCODE_STORE};
        imm_type = IMM_S;
        #1;
        assert(imm == 32'hFFFF_FFFC);

        // B-type: branch offset +8
        instr = {1'b0, 6'b000000, 5'd2, 5'd1, 3'b000, 4'b0100, 1'b0, OPCODE_BRANCH};
        #1;
        assert(imm == 32'd8);

        // U-type: lui x1, 0x12345
        instr = {20'h12345, 5'd1, OPCODE_LUI};
        imm_type = IMM_U;
        #1;
        assert(imm == 32'h12345000);

        // J-type: jal offset +16
        instr = {1'b0, 10'b0000001000, 1'b0, 8'b00000000, 5'd1, OPCODE_JAL};
        imm_type = IMM_J;
        #1;
        assert(imm == 32'd16);

        $display("IMM_GEN tests passed");
        $finish;
    end

endmodule
