//=============================================================================
//Module name: test_lfu_finder
//Module file: test_bench.v
//Author     : Le Duy Luan
//=============================================================================


module test_lfu_finder;

parameter HF_CYCL = 5;
parameter CYCL = HF_CYCL * 2 ;

reg clk;
reg rst_n;
reg new_buf_req;
reg [1:0] ref_buf_numbr;

wire [1:0] buf_num_replc;

//connect signals form the testbench to module lfu_finder

lfu_finder lfu_finder_01 (.clk(clk), .rst_n (rst_n), .new_buf_req(new_buf_req),
                          .ref_buf_numbr(ref_buf_numbr),
                          .buf_num_replc(buf_num_replc));
                      
// generate clock
always begin
    clk = 1'b0 ; #HF_CYCL;
    clk = 1'b1 ; #HF_CYCL;
end

initial begin
   rst_n = 0; #HF_CYCL;
   rst_n = 1; #(CYCL*4 + HF_CYCL);
   rst_n = 0; #CYCL;
   rst_n = 1;

end

initial  begin
    $monitor("t = %d, rst_n = %b, new_buf_req = %b, ref_buf_numbr = %d, #0 = %d, #1 = %d, #2 = %d, #3 = %d, flag = %b, n_temp = %d, temp = %d, replace = %d", $stime, rst_n, new_buf_req , ref_buf_numbr, lfu_finder_01.access_time_0, lfu_finder_01.access_time_1, lfu_finder_01.access_time_2, lfu_finder_01.access_time_3, lfu_finder_01.flag, lfu_finder_01.n_buf_num_replc,lfu_finder_01.temp_buf_num_replc,lfu_finder_01.buf_num_replc);
end

initial begin 
    $vcdplusfile ("test_lfu_finder.vpd");
    $vcdpluson (); 
end

initial begin
    #1          ref_buf_numbr = 2'd0;
    #(HF_CYCL)ref_buf_numbr = 2'd1;
    #(CYCL)   ref_buf_numbr = 2'd3;
    #(CYCL)   ref_buf_numbr = 2'd2;
    #(CYCL)   ref_buf_numbr = 2'd1;
    #(CYCL)   ref_buf_numbr = 2'd0;
    #(CYCL)   ref_buf_numbr = 2'd0;
    #(CYCL)   ref_buf_numbr = 2'd2;
    #(CYCL)   ref_buf_numbr = 2'd0;
    #(CYCL)   ref_buf_numbr = 2'd2;
    #(CYCL)   ref_buf_numbr = 2'd3;
    #(CYCL)   ref_buf_numbr = 2'd3;
    #(CYCL)   ref_buf_numbr = 2'd1;
    #(CYCL)   ref_buf_numbr = 2'd1;
    #(CYCL)   ref_buf_numbr = 2'd0;
    #(CYCL)   ref_buf_numbr = 2'd2;
    #(CYCL)   ref_buf_numbr = 2'd0;
    #(CYCL)   ref_buf_numbr = 2'd1;
    #(CYCL)   ref_buf_numbr = 2'd3;
    #(CYCL)   ref_buf_numbr = 2'd0;
    #(CYCL)   ref_buf_numbr = 2'd1;
    #(CYCL)   ref_buf_numbr = 2'd0;
    #(CYCL)   ref_buf_numbr = 2'd2;
    #(CYCL)   ref_buf_numbr = 2'd1;
    #(CYCL*4) $finish;
end

initial begin 
                          new_buf_req = 0;
    #(CYCL)               new_buf_req = 1;
    #(CYCL)               new_buf_req = 0;
    #(CYCL*12)            new_buf_req = 1;
    #(CYCL*2)             new_buf_req = 0;
end
endmodule

`include "dut.v"
