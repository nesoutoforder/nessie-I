module tb_decoder;
    import rv32_pkg::*;

    instr_t instr;

    reg_addr_t rs1_addr;
    reg_addr_t rs2_addr;
    reg_addr_t rd_addr;
    decode_ctrl_t ctrl;

    decoder DUT(
        .instr_i(instr),
        .rd_addr_o(rd_addr),
        .rs1_addr_o(rs1_addr),
        .rs2_addr_o(rs2_addr),
        .ctrl_o(ctrl)
    );

    initial begin
        // add x5, x1, x2
        instr = {7'h00, 5'd2, 5'd1, 3'h0, 5'd5, OPCODE_OP};
        #1;
        assert(ctrl.valid);
        assert(!ctrl.alu_src_imm);
        assert(ctrl.alu_op == ALU_ADD);

        // addi x5, x1, 123
        instr = {12'd123, 5'd1, 3'h0, 5'd5, OPCODE_OP_IMM};
        #1;
        assert(ctrl.valid);
        assert(ctrl.alu_src_imm);
        assert(ctrl.alu_op == ALU_ADD);

        // invalid opcode
        instr = 32'd0;
        #1;
        assert(!ctrl.valid);

        $display("DECODER tests passed");
        $finish;
    end

endmodule