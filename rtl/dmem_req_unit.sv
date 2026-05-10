module dmem_req_unit
  import rv32_pkg::*;
(
    input  decode_ctrl_t ctrl_i,
    input  word_t        addr_i,
    input  word_t        store_data_i,
    input  byte_en_t     wstrb_i,

    output byte_en_t     dmem_wstrb_o,
    output word_t        dmem_addr_o,
    output word_t        dmem_wdata_o
);

    assign dmem_wstrb_o = ctrl_i.mem_write ? wstrb_i : 4'b0000;
    assign dmem_addr_o  = addr_i;
    assign dmem_wdata_o = store_data_i;

endmodule
