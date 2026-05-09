module alu
    import rv32_pkg::*;
(
    input   word_t      lhs_i,
    input   word_t      rhs_i,
    input   alu_op_e    op_i,
    output  word_t      result_o
);

    always_comb begin
        unique case (op_i)
            ALU_ADD:    result_o = lhs_i + rhs_i;
            ALU_SUB:    result_o = lhs_i - rhs_i;
            ALU_AND:    result_o = lhs_i & rhs_i;
            ALU_OR:     result_o = lhs_i | rhs_i;
            ALU_XOR:    result_o = lhs_i ^ rhs_i;
            ALU_SLL:    result_o = lhs_i << rhs_i[4:0];
            ALU_SRL:    result_o = lhs_i >> rhs_i[4:0];
            ALU_SRA:    result_o = $signed(lhs_i) >>> rhs_i[4:0];
            ALU_SLT:    result_o = ($signed(lhs_i) < $signed(rhs_i)) ? 32'd1 : 32'd0;
            ALU_SLTU:   result_o = (lhs_i < rhs_i) ? 32'd1 : 32'd0;
            default:    result_o = '0;
        endcase
    end

endmodule