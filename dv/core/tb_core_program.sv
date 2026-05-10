`timescale 1ns/1ps

module tb_core_program;

  import rv32_pkg::*;

  localparam time CLK_PERIOD = 10ns;

  localparam int unsigned RESET_CYCLES   = 5;
  localparam int unsigned TIMEOUT_CYCLES = 1000;

  localparam word_t MEM_BASE  = 32'h8000_0000;
  localparam int unsigned MEM_BYTES = 64 * 1024;
  localparam int unsigned MEM_WORDS = MEM_BYTES / 4;

  localparam word_t TEST_STATUS_ADDR = 32'h0000_0100;
  localparam word_t TEST_PASS_VALUE  = 32'h0000_0001;
  localparam word_t TEST_FAIL_VALUE  = 32'h0000_DEAD;

  logic clk_i;
  logic rst_ni;

  word_t    imem_addr_o;
  instr_t   imem_rdata_i;

  byte_en_t dmem_wstrb_o;
  word_t    dmem_addr_o;
  word_t    dmem_wdata_o;
  word_t    dmem_rdata_i;

  word_t mem [0:MEM_WORDS-1];

  string program_hex;

  core dut (
    .clk_i        (clk_i),
    .rst_ni       (rst_ni),

    .imem_addr_o  (imem_addr_o),
    .imem_rdata_i (imem_rdata_i),

    .dmem_wstrb_o (dmem_wstrb_o),
    .dmem_addr_o  (dmem_addr_o),
    .dmem_wdata_o (dmem_wdata_o),
    .dmem_rdata_i (dmem_rdata_i)
  );

  initial begin
    clk_i = 1'b0;
    forever #(CLK_PERIOD / 2) clk_i = ~clk_i;
  end

  initial begin
    rst_ni = 1'b0;
    repeat (RESET_CYCLES) @(posedge clk_i);
    rst_ni = 1'b1;
  end

  initial begin
    if (!$value$plusargs("PROGRAM=%s", program_hex)) begin
      program_hex = "build/simple.hex";
    end

    $display("[TB] Loading program: %s", program_hex);
    load_verilog_hex(program_hex);
  end

  always_comb begin
    imem_rdata_i = read_word(imem_addr_o);
    dmem_rdata_i = read_word(dmem_addr_o);
  end

  always_ff @(posedge clk_i) begin
    if (rst_ni && dmem_wstrb_o != '0) begin
      write_word(dmem_addr_o, dmem_wdata_o, dmem_wstrb_o);
    end
  end

  initial begin
    repeat (TIMEOUT_CYCLES) @(posedge clk_i);

    $error("[TB] TIMEOUT after %0d cycles", TIMEOUT_CYCLES);
    $fatal;
  end

  always_ff @(posedge clk_i) begin
    if (rst_ni) begin
      case (read_word(TEST_STATUS_ADDR))
        TEST_PASS_VALUE: begin
          $display("[TB] PASS");
          $finish;
        end

        TEST_FAIL_VALUE: begin
          $error("[TB] FAIL");
          $fatal;
        end

        default: begin
        end
      endcase
    end
  end

  function automatic int unsigned addr_to_index(input word_t addr);
    if (addr >= MEM_BASE) begin
      addr_to_index = (addr - MEM_BASE) >> 2;
    end else begin
      addr_to_index = addr >> 2;
    end
  endfunction

  function automatic word_t read_word(input word_t addr);
    read_word = mem[addr_to_index(addr)];
  endfunction

  task automatic write_word(
    input word_t    addr,
    input word_t    data,
    input byte_en_t wstrb
  );
    int unsigned idx;
    word_t old_data;

    idx = addr_to_index(addr);
    old_data = mem[idx];

    if (wstrb[0]) old_data[7:0]   = data[7:0];
    if (wstrb[1]) old_data[15:8]  = data[15:8];
    if (wstrb[2]) old_data[23:16] = data[23:16];
    if (wstrb[3]) old_data[31:24] = data[31:24];

    mem[idx] = old_data;
  endtask

  task automatic load_verilog_hex(input string path);
    int fd;
    string token;
    word_t byte_addr;
    word_t byte_value;
    int code;

    fd = $fopen(path, "r");

    if (fd == 0) begin
      $fatal(1, "[TB] Could not open program file: %s", path);
    end

    byte_addr = MEM_BASE;

    while (!$feof(fd)) begin
      code = $fscanf(fd, "%s", token);

      if (code != 1) begin
        continue;
      end

      if (token.substr(0, 0) == "@") begin
        code = $sscanf(token.substr(1, token.len()-1), "%h", byte_addr);
      end else begin
        code = $sscanf(token, "%h", byte_value);
        write_byte(byte_addr, byte_value[7:0]);
        byte_addr++;
      end
    end

    $fclose(fd);
  endtask

  task automatic write_byte(
    input word_t      addr,
    input logic [7:0] data
  );
    int unsigned idx;
    int unsigned lane;

    idx  = addr_to_index(addr);
    lane = addr[1:0];

    mem[idx][8*lane +: 8] = data;
  endtask

endmodule
