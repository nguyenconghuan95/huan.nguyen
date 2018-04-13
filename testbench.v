`timescale 1ns/1ns
module lfu_finder_tb;
  parameter BUF_BIT = 2;
  parameter HLF_CYCL = 5;
  parameter CYCL = 2 * HLF_CYCL;

  reg clk_t;
  reg rst_n_t;

  reg new_buf_req_t;
  reg [BUF_BIT-1:0] ref_buf_req_t;

  wire [BUF_BIT-1:0] buf_num_rplc_t;

  lfu_finder lfu_finder_01 (.clk(clk_t),
                            .rst_n(rst_n_t),
                            .new_buf_req(new_buf_req_t),
                            .ref_buf_req(ref_buf_req_t),
                            .buf_num_replc(buf_num_rplc_t));

  always begin //clock generator
              clk_t = 1'b0;
    #HLF_CYCL clk_t = 1'b1;
    #HLF_CYCL;
  end

  always @(posedge clk_t) begin
    $strobe ("t=%d, rst_n=%b, new_req=%b, ref_req=%b, t[1]=%b, t[2]=%b, t[3]=%b, t[4]=%b, mx_flg=%b, buf_rplc=%b", $stime, rst_n_t, new_buf_req_t, ref_buf_req_t, lfu_finder_01.t_in_01, lfu_finder_01.t_in_02, lfu_finder_01.t_in_03, lfu_finder_01.t_in_04, lfu_finder_01.max_flg, buf_num_rplc_t);
  end

  initial begin
    rst_n_t = 1'b0;
    #(CYCL * 4) rst_n_t = 1'b1;
    @(lfu_finder_01.max_flg == 1'b1) #(CYCL * 2) rst_n_t = 1'b0;
    #CYCL rst_n_t = 1'b1;
    @(lfu_finder_01.max_flg == 1'b1) #(CYCL * 2) rst_n_t = 1'b0;
    #CYCL rst_n_t = 1'b1;
    @(lfu_finder_01.max_flg == 1'b1) #(CYCL * 2) rst_n_t = 1'b0;
    #CYCL rst_n_t = 1'b1;
    @(lfu_finder_01.max_flg == 1'b1) #(CYCL * 2) rst_n_t = 1'b0;
    #CYCL $finish;
  end

  initial begin
    #CYCL ref_buf_req_t = 2'b00;
    @(lfu_finder_01.t_in_01 == 2'b11) #CYCL ref_buf_req_t = 2'b01;
    @(lfu_finder_01.t_in_02 == 2'b11) #CYCL ref_buf_req_t = 2'b10;
    @(lfu_finder_01.t_in_03 == 2'b11) #CYCL ref_buf_req_t = 2'b11;
    @(lfu_finder_01.max_flg == 1'b1) #HLF_CYCL ref_buf_req_t = 2'b00;
    @(rst_n_t == 1'b0) #HLF_CYCL ref_buf_req_t = 2'b01;
    @(lfu_finder_01.t_in_02 == 2'b11) #CYCL ref_buf_req_t = 2'b00;
    @(lfu_finder_01.t_in_01 == 2'b11) #CYCL ref_buf_req_t = 2'b10;
    @(lfu_finder_01.t_in_03 == 2'b11) #CYCL ref_buf_req_t = 2'b11;
    @(lfu_finder_01.max_flg == 1'b1) #HLF_CYCL ref_buf_req_t = 2'b01;
    @(rst_n_t == 1'b0) #HLF_CYCL ref_buf_req_t = 2'b10;
    @(lfu_finder_01.t_in_03 == 2'b11) #CYCL ref_buf_req_t = 2'b00;
    @(lfu_finder_01.t_in_01 == 2'b11) #CYCL ref_buf_req_t = 2'b01;
    @(lfu_finder_01.t_in_02 == 2'b11) #CYCL ref_buf_req_t = 2'b11;
    @(lfu_finder_01.max_flg == 1'b1) #HLF_CYCL ref_buf_req_t = 2'b10;
    @(rst_n_t == 1'b0) #HLF_CYCL ref_buf_req_t = 2'b11;
    @(lfu_finder_01.t_in_04 == 2'b11) #CYCL ref_buf_req_t = 2'b00;
    @(lfu_finder_01.t_in_01 == 2'b11) #CYCL ref_buf_req_t = 2'b01;
    @(lfu_finder_01.t_in_02 == 2'b11) #CYCL ref_buf_req_t = 2'b10;
    @(lfu_finder_01.max_flg == 1'b1) #HLF_CYCL ref_buf_req_t = 2'b11;
  end

  initial begin
    #CYCL new_buf_req_t = 1'b0;
  end
endmodule

`include "dut.v"
