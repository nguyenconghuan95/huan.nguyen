`timescale 1ns/1ns
module bit_block_counter_tb;
  parameter HLF_CYCL = 5;
  parameter CYCL = HLF_CYCL * 2;
  reg [31:0] data_t;
  reg data_enb_t;
  reg clk_t;
  reg rst_n_t;

  wire [31:0] block_cnt_t;
  wire valid_t;

  bit_block_counter bit_block_counter_01 (.data(data_t),
                                          .data_enb(data_enb_t),
                                          .clk(clk_t),
                                          .rst_n(rst_n_t),
                                          .block_cnt(block_cnt_t),
                                          .valid(valid_t));
  
  initial begin
    $monitor ("t=%d, data=%b, data_enb=%b, state=%d, block_cnt=%d", $stime, data_t, data_enb_t, bit_block_counter_01.state, block_cnt_t);
  end

  always begin
              clk_t = 1'b0;
    #HLF_CYCL clk_t = 1'b1;
    #HLF_CYCL;
  end

  initial begin
    #HLF_CYCL rst_n_t = 1'b0;
    #(CYCL)  rst_n_t = 1'b1;
  end

  initial begin
    #(CYCL + HLF_CYCL) data_enb_t = 1'b1;
    #(CYCL)            data_enb_t = 1'b0;
    #(CYCL * 2)        data_enb_t = 1'b1;
    #(CYCL)            data_enb_t = 1'b0;
  end

  initial begin
    #(CYCL)            data_t = 32'hF244_FABC;
    #(CYCL * 3)        data_t = 32'h3023_F103;
    #(CYCL * 3) $finish;
  end
endmodule

`include "dut.v
