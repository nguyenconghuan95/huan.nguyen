//Main module
module lfu_finder (clk, 
                   rst_n,
                   new_buf_req,
                   ref_buf_req,
                   buf_num_replc);
  
  parameter BUF_BIT = 2;

  input clk;
  input rst_n;
  input new_buf_req;
  input [BUF_BIT-1:0] ref_buf_req;

  output [BUF_BIT-1:0] buf_num_replc;

  wire clk;
  wire rst_n;
  wire new_buf_req;
  wire [BUF_BIT-1:0] ref_buf_req;

  wire [BUF_BIT-1:0] buf_num_replc;
  
  //internal variables
  wire [BUF_BIT-1:0] t_in_01;    //
  wire [BUF_BIT-1:0] t_in_02;    //
  wire [BUF_BIT-1:0] t_in_03;    //
  wire [BUF_BIT-1:0] t_in_04;    //
  wire [BUF_BIT-1:0] t_out_01;   // 
  wire [BUF_BIT-1:0] t_out_02;   // 
  wire [BUF_BIT-1:0] t_out_03;   //
  wire [BUF_BIT-1:0] t_out_04;   //
  
  wire max_flg;

  wire [BUF_BIT-1:0] rplc_buf_req; 
  wire [BUF_BIT-1:0] rplc_buf_int;

//This part calculate the access time of buffer 01
  defparam ctnr_time_01.BUF_ADDR = 2'b00;
  cntr_time ctnr_time_01 (.max_cntr_flg(max_flg), 
                          .rplc_buf_req_int(rplc_buf_req),
                          .ref_buf_req_int(ref_buf_req),
                          .new_buf_req_int(new_buf_req),
                          .t_in(t_in_01),
                          .t_out(t_out_01));
  ff_2bit buff_01 (.clk(clk),
                   .rst_n(rst_n),
                   .in_a(t_out_01), 
                   .out_y(t_in_01));    
  
//This part calculate the access time of buffer 02
  defparam ctnr_time_02.BUF_ADDR = 2'b01;
  cntr_time ctnr_time_02 (.max_cntr_flg(max_flg), 
                          .rplc_buf_req_int(rplc_buf_req),
                          .ref_buf_req_int(ref_buf_req),
                          .new_buf_req_int(new_buf_req),
                          .t_in(t_in_02),
                          .t_out(t_out_02));
  ff_2bit buff_02 (.clk(clk),
                   .rst_n(rst_n),
                   .in_a(t_out_02), 
                   .out_y(t_in_02));

//This part calculate the access time of buffer 03
  defparam ctnr_time_03.BUF_ADDR = 2'b10;
  cntr_time ctnr_time_03 (.max_cntr_flg(max_flg), 
                          .rplc_buf_req_int(rplc_buf_req),
                          .ref_buf_req_int(ref_buf_req),
                          .new_buf_req_int(new_buf_req),
                          .t_in(t_in_03),
                          .t_out(t_out_03));
  ff_2bit buff_03 (.clk(clk),
                   .rst_n(rst_n),
                   .in_a(t_out_03), 
                   .out_y(t_in_03));

//This part calculate the access time of buffer 04
  defparam ctnr_time_04.BUF_ADDR = 2'b11;
  cntr_time ctnr_time_04 (.max_cntr_flg(max_flg), 
                          .rplc_buf_req_int(rplc_buf_req),
                          .ref_buf_req_int(ref_buf_req),
                          .new_buf_req_int(new_buf_req),
                          .t_in(t_in_04),
                          .t_out(t_out_04));
  ff_2bit buff_04 (.clk(clk),
                   .rst_n(rst_n),
                   .in_a(t_out_04),
                   .out_y(t_in_04));

  assign max_flg = (& {{t_in_01},{t_in_02},{t_in_03},{t_in_04}}) 
                      ? 1'b1 
                      : 1'b0;
  assign buf_num_replc = rplc_buf_req;
  
  buf_rplc_handle buf_rplc_handle_01 (.t_out_01_int(t_in_01), 
                                      .t_out_02_int(t_in_02), 
                                      .t_out_03_int(t_in_03),
                                      .t_out_04_int(t_in_04),
                                      .rplc_buf_int(rplc_buf_int));
  ff_2bit buf_rplc_handle_ff (.in_a(rplc_buf_int),
                              .out_y(rplc_buf_req));
endmodule

//----------------------------------------------------------------------------
//Module to calculate access time
module cntr_time (max_cntr_flg, 
                  rplc_buf_req_int,
                  ref_buf_req_int,
                  new_buf_req_int, 
                  t_in, 
                  t_out);
  parameter CNTR_BIT = 2;
  parameter BUF_ADDR = 2'b00;

  input new_buf_req_int;
  input max_cntr_flg;
  input [CNTR_BIT-1:0] ref_buf_req_int;
  input [CNTR_BIT-1:0] rplc_buf_req_int;
  input [CNTR_BIT-1:0] t_in;

  output [CNTR_BIT-1:0] t_out;

  wire  new_buf_req_int;
  wire [CNTR_BIT-1:0] ref_buf_req_int;
  wire [CNTR_BIT-1:0] rplc_buf_req_int;
  wire max_cntr_flg;
  wire [CNTR_BIT-1:0] t_in;

  reg [CNTR_BIT-1:0] t_out;


  always @(new_buf_req_int 
           or t_in 
           or ref_buf_req_int 
           or max_cntr_flg) begin
    if (new_buf_req_int == 1) begin
      t_out = (rplc_buf_req_int == BUF_ADDR) 
             ? 2'b01 
             : t_in;
    end
    else begin
      case (t_in)
        2'b01: begin
         	       t_out = (ref_buf_req_int == BUF_ADDR)
         	              ? 2'b10
         	              : t_in;
         	     end
        2'b10: begin
         	       t_out = (ref_buf_req_int == BUF_ADDR)
         	               ? 2'b11
         	               : t_in;
         	     end
        2'b11: begin
                 if (max_cntr_flg == 1'b1) begin
                   t_out = (ref_buf_req_int == BUF_ADDR)
                           ? 2'b10
                           : 2'b01;
                 end
                 else begin
                   t_out = t_in;
                 end
               end
        default: begin
                 t_out = 2'b00;
               end
      endcase
    end
  end
endmodule

//----------------------------------------------------------------------------
//FF 2 bit
module ff_2bit (in_a, clk, rst_n, out_y);
  parameter INTL = 2'b01;
  parameter FF_DLY = 1;
  
  input [1:0] in_a;
  input clk;
  input rst_n;

  output [1:0] out_y;

  wire [1:0] in_a;
  wire clk;
  wire rst_n;

  reg [1:0] out_y;

  always @(posedge clk 
           or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      out_y <= #FF_DLY INTL;
    end
    else begin
      out_y <= #FF_DLY in_a;
    end
  end
endmodule

//-----------------------------------------------------------------------------
//Module decides which buffer will be replaced
module buf_rplc_handle (t_out_01_int, 
                        t_out_02_int, 
                        t_out_03_int, 
                        t_out_04_int, 
                        rplc_buf_int);
  parameter CNTR_BIT = 2;
  parameter BUF_NUM_01 = 2'b00;
  parameter BUF_NUM_02 = 2'b01;
  parameter BUF_NUM_03 = 2'b10;
  parameter BUF_NUM_04 = 2'b11;

  input [CNTR_BIT-1:0] t_out_01_int;
  input [CNTR_BIT-1:0] t_out_02_int;
  input [CNTR_BIT-1:0] t_out_03_int;
  input [CNTR_BIT-1:0] t_out_04_int;

  output [CNTR_BIT-1:0] rplc_buf_int;

  wire [CNTR_BIT-1:0] t_out_01_int;
  wire [CNTR_BIT-1:0] t_out_02_int;
  wire [CNTR_BIT-1:0] t_out_03_int;
  wire [CNTR_BIT-1:0] t_out_04_int;
  wire [CNTR_BIT-1:0] t_cmp_12;
  wire [CNTR_BIT-1:0] t_cmp_34;

  wire  [CNTR_BIT-1:0] t_cmp;
  reg  [CNTR_BIT-1:0] rplc_buf_int;

  assign t_cmp_12 = (t_out_01_int > t_out_02_int) 
                    ? t_out_02_int 
                    : t_out_01_int;
  assign t_cmp_34 = (t_out_03_int > t_out_04_int) 
                    ? t_out_03_int 
                    : t_out_04_int;
  assign t_cmp = (t_cmp_12 > t_cmp_34) 
                 ? t_cmp_12 
                 : t_cmp_34;

  always @(t_cmp) begin
    if (t_cmp == t_out_01_int) begin
      rplc_buf_int = BUF_NUM_01;
    end
    else if (t_cmp == t_out_02_int) begin
      rplc_buf_int = BUF_NUM_02;
    end
    else if (t_cmp == t_out_03_int) begin
      rplc_buf_int = BUF_NUM_03;
    end
    else begin
      rplc_buf_int = BUF_NUM_04;
    end
  end
endmodule
