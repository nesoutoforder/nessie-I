module decoder
    import rv32_pkg::*;
(
    input   instr_t         instr_i,
    output  reg_addr_t      rs1_addr_o,
    output  reg_addr_t      rs2_addr_o,
    output  reg_addr_t      rd_addr_o,
    output  decode_ctrl_t   ctrl_o
);

    opcode_t opcode;
    funct3_t funct3;
    funct7_t funct7;

    assign opcode       = instr_i[6:0];
    assign rd_addr_o    = instr_i[11:7];
    assign rs1_addr_o   = instr_i[19:15];
    assign rs2_addr_o   = instr_i[24:20];

    always_comb begin
        ctrl_o = '0;

        unique case (opcode)
            OPCODE_OP:  begin
                ctrl_o.valid        = 1'b1;
                ctrl_o.rd_we        = 1'b1;
                ctrl_o.alu_src_imm  = 1'b0;

                unique case (funct3)
                    3'h0: ctrl_o.alu_op = (funct7 == 7'h20) ? ALU_SUB : ALU_ADD;
                    3'h4: ctrl_o.alu_op = ALU_XOR;
                    3'h6: ctrl_o.alu_op = ALU_OR;
                    3'h7: ctrl_o.alu_op = ALU_AND;
                    3'h1: ctrl_o.alu_op = ALU_SLL;
                    3'h5: ctrl_o.alu_op = (funct7 == 7'h20) ? ALU_SRA : ALU_SRL;
                    3'h2: ctrl_o.alu_op = ALU_SLT;
                    3'h3: ctrl_o.alu_op = ALU_SLTU;
                    default: ctrl_o.valid = 1'b0;
                endcase
            end

            OPCODE_OP_IMM:  begin
                ctrl_o.valid        = 1'b1;
                ctrl_o.rd_we        = 1'b1;
                ctrl_o.alu_src_imm  = 1'b1;

                unique case (funct3)
                    3'h0: ctrl_o.alu_op = ALU_ADD;
                    3'h4: ctrl_o.alu_op = ALU_XOR;
                    3'h6: ctrl_o.alu_op = ALU_OR;
                    3'h7: ctrl_o.alu_op = ALU_AND;
                    3'h1: ctrl_o.alu_op = ALU_SLL;
                    3'h5: ctrl_o.alu_op = (funct7 == 7'h20) ? ALU_SRA : ALU_SRL;
                    3'h2: ctrl_o.alu_op = ALU_SLT;
                    3'h3: ctrl_o.alu_op = ALU_SLTU;
                    default: ctrl_o.valid = 1'b0;
                endcase
            end   

            default:    begin
                ctrl_o.valid = 1'b0;
            end   
        endcase
    end

endmodule
