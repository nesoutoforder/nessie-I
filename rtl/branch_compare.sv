module branch_compare
    import rv32_pkg::*;
(
    input  word_t      lhs_i,
    input  word_t      rhs_i,
    input  logic       branch_i,
    input  branch_op_e branch_op_i,
    output logic       taken_o
);

    always_comb begin
        taken_o = 1'b0;

        if (branch_i) begin
            unique case (branch_op_i)
                BR_EQ:  taken_o = (lhs_i == rhs_i);
                BR_NE:  taken_o = (lhs_i != rhs_i);
                BR_LT:  taken_o = ($signed(lhs_i) < $signed(rhs_i));
                BR_GE:  taken_o = ($signed(lhs_i) >= $signed(rhs_i));
                BR_LTU: taken_o = (lhs_i < rhs_i);
                BR_GEU: taken_o = (lhs_i >= rhs_i);
                default: taken_o = 1'b0;
            endcase
        end
    end

endmodule