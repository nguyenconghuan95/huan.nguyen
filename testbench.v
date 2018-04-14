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
  
  initial begin
    $monitor ("t=%d, rst_n=%b, new_req=%b, ref_req=%d, t[0]=%d, t[1]=%d, t[2]=%d, t[3]=%d, t_cmp=%d, mx_flg=%b, buf_rplc_int=%d, buf_rplc=%d\n", $stime, rst_n_t, new_buf_req_t, ref_buf_req_t, lfu_finder_01.t_in_01, lfu_finder_01.t_in_02, lfu_finder_01.t_in_03, lfu_finder_01.t_in_04, lfu_finder_01.buf_rplc_handle_01.t_cmp, lfu_finder_01.max_flg, lfu_finder_01.rplc_buf_int, buf_num_rplc_t);
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
   
    //Rst for testcase 2.1 
    @(lfu_finder_01.max_flg == 1'b1) #CYCL rst_n_t = 1'b0;
    #CYCL rst_n_t = 1'b1;
    @(lfu_finder_01.max_flg == 1'b1) #CYCL rst_n_t = 1'b0;
    #CYCL rst_n_t = 1'b1;
    @(lfu_finder_01.max_flg == 1'b1) #CYCL rst_n_t = 1'b0;
    #CYCL rst_n_t = 1'b1;
    @(lfu_finder_01.max_flg == 1'b1) #CYCL rst_n_t = 1'b0;
    #CYCL rst_n_t = 1'b1;
    @(lfu_finder_01.max_flg == 1'b1) #CYCL rst_n_t = 1'b0;
    #CYCL rst_n_t = 1'b1;
    
  end

  initial begin
    #HLF_CYCL ref_buf_req_t = 2'b00;
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
    
    //2.1: Test case replace the lowest one
    @(rst_n_t == 1'b0) #HLF_CYCL ref_buf_req_t = 2'b01;
    @(lfu_finder_01.t_in_02 == 2'b11) ref_buf_req_t = 2'b10;
    @(lfu_finder_01.t_in_03 == 2'b11) ref_buf_req_t = 2'b11;
    @(lfu_finder_01.t_in_04 == 2'b11) ref_buf_req_t = 2'b00;
    @(rst_n_t == 1'b0) #HLF_CYCL ref_buf_req_t = 2'b00;
    @(lfu_finder_01.t_in_01 == 2'b11) ref_buf_req_t = 2'b10;
    @(lfu_finder_01.t_in_03 == 2'b11) ref_buf_req_t = 2'b11;
    @(lfu_finder_01.t_in_04 == 2'b11) ref_buf_req_t = 2'b01;
    @(rst_n_t == 1'b0) #HLF_CYCL ref_buf_req_t = 2'b00;
    @(lfu_finder_01.t_in_01 == 2'b11) ref_buf_req_t = 2'b01;
    @(lfu_finder_01.t_in_02 == 2'b11) ref_buf_req_t = 2'b11;
    @(lfu_finder_01.t_in_04 == 2'b11) ref_buf_req_t = 2'b10;
    @(rst_n_t == 1'b0) #HLF_CYCL ref_buf_req_t = 2'b00;
    @(lfu_finder_01.t_in_01 == 2'b11) ref_buf_req_t = 2'b01;
    @(lfu_finder_01.t_in_02 == 2'b11) ref_buf_req_t = 2'b10;
    @(lfu_finder_01.t_in_03 == 2'b11) ref_buf_req_t = 2'b11;

    //2.2 Test case replace buffer if they have the same access time
    @(rst_n_t == 1'b0) #HLF_CYCL ref_buf_req_t = 2'b00;
    @(lfu_finder_01.t_in_01 == 2'b10)  ref_buf_req_t = 2'b01;
    @(lfu_finder_01.t_in_02 == 2'b10)  ref_buf_req_t = 2'b11;
    @(lfu_finder_01.t_in_04 == 2'b10)  ref_buf_req_t = 2'b10;
    
    @(lfu_finder_01.t_in_03 == 2'b10)  ref_buf_req_t = 2'b00;
    @(lfu_finder_01.t_in_01 == 2'b11) #CYCL ref_buf_req_t = 2'b01;
    @(lfu_finder_01.t_in_02 == 2'b11) #CYCL ref_buf_req_t = 2'b10;
    @(lfu_finder_01.t_in_03 == 2'b11) #CYCL ref_buf_req_t = 2'b11;

  end

  initial begin
    #HLF_CYCL new_buf_req_t = 1'b0;
    #(CYCL * 60) new_buf_req_t = 1'b0;
    @(lfu_finder_01.t_in_01 == 2'b10) #HLF_CYCL new_buf_req_t = 1'b1;
    #CYCL new_buf_req_t = 1'b0;
    @(lfu_finder_01.t_in_02 == 2'b10) #HLF_CYCL new_buf_req_t = 1'b1;
    #CYCL new_buf_req_t = 1'b0;
    @(lfu_finder_01.t_in_03 == 2'b10) #HLF_CYCL new_buf_req_t = 1'b1;
    #CYCL new_buf_req_t = 1'b0;
    @(lfu_finder_01.t_in_04 == 2'b10) #HLF_CYCL new_buf_req_t = 1'b1;
    #CYCL new_buf_req_t = 1'b0;

    @(lfu_finder_01.t_in_03 == 2'b10) #HLF_CYCL new_buf_req_t = 1'b1;
    #CYCL new_buf_req_t = 1'b0;
    @(lfu_finder_01.t_in_01 == 2'b11) #HLF_CYCL new_buf_req_t = 1'b1;
    #CYCL new_buf_req_t = 1'b0;
    @(lfu_finder_01.t_in_02 == 2'b11) #HLF_CYCL new_buf_req_t = 1'b1;
    #CYCL new_buf_req_t = 1'b0;
    @(lfu_finder_01.t_in_03 == 2'b11) #HLF_CYCL new_buf_req_t = 1'b1;
    #CYCL new_buf_req_t = 1'b0;
    @(lfu_finder_01.max_flg == 1'b1) #HLF_CYCL new_buf_req_t = 1'b1;
    #CYCL new_buf_req_t = 1'b0;

//    @(lfu_finder_01.t_in_04 == 2'b10) #HLF_CYCL new_buf_req_t = 1'b1;
//    #CYCL new_buf_req_t = 1'b0;
//    @(lfu_finder_01.t_in_04 == 2'b10) #HLF_CYCL new_buf_req_t = 1'b1;
//    #CYCL new_buf_req_t = 1'b0;
//    @(lfu_finder_01.t_in_04 == 2'b10) #HLF_CYCL new_buf_req_t = 1'b1;
//    #CYCL new_buf_req_t = 1'b0;
//
    #(CYCL * 5) $finish;
  end

endmodule

`include "dut.v"
