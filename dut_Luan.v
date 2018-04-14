//********************************************************************
// Project Name : Rensas RTL coding training, 
// : LFU algorithm
// Module Name : lfu_algorithm
// Function : this logic flash lamps in sequence at evry clock rise time
// lamp will go up and down.
// Note : Following code does use * for sensitivity list.
// In real project make rule to use * or not to use * in
// sensitivity list. Using * can avoid possible error
// such as missing variables from sensitivity list.
// Author : Le Duy Luan
//----------------------------------------------------------
//** History                                                        **
//** Version  Date        Author       Description                  ** 
//** ver.1.0  04/03/2018  Le Duy Luan  -New creation                **
//** ver.1.1  04/04/2018  Le Duy Luan  -Change the default          **
//**                                   case of lamp and state.      **
//**                                   -Change the way to shift     **
//**                                   variable a_lamp.             **
//** ver.1.2  04/04/2018  Le Duy Luan  -Add meaningful revision to  **
//**                                   record changes of the module **
//********************************************************************
module lfu_finder (clk, rst_n, new_buf_req, ref_buf_numbr, buf_num_replc);
/////////// parameter ////////
parameter BUF_0 = 2'd0;
parameter BUF_1 = 2'd1;
parameter BUF_2 = 2'd2;
parameter BUF_3 = 2'd3;
parameter FF_DLY = 1;
parameter LEN = 2;
parameter LEN_F = 8;
////////// port declaration ////////
input clk;
input rst_n;
input new_buf_req;
input [LEN-1:0] ref_buf_numbr;
output [LEN-1:0] buf_num_replc;

wire clk, rst_n;
wire new_buf_req;
wire [LEN-1:0] ref_buf_numbr;
wire [LEN-1:0] buf_num_replc;
///////// internal variable /////////
wire [LEN-1:0] access_time_0;
wire [LEN-1:0] access_time_1;
wire [LEN-1:0] access_time_2;
wire [LEN-1:0] access_time_3;
reg [LEN-1:0] min;
reg [LEN-1:0] n_buf_num_replc;
reg [LEN-1:0] temp_buf_num_replc;
wire [LEN_F-1:0] flag;
/////////////////////////////
assign buf_num_replc = temp_buf_num_replc;
assign flag = {{access_time_3}, {access_time_2}, {access_time_1}, {access_time_0}};
///////////
defparam counter_01.BIT = 1;
defparam counter_01.BUF = BUF_0;
counter counter_01(.rst_n(rst_n),.clk(clk),.req(new_buf_req),.ref(ref_buf_numbr),.flag(flag),.buff(n_buf_num_replc),.access_time(access_time_0));
defparam counter_02.BIT = 3;
defparam counter_02.BUF = BUF_1;
counter counter_02(.rst_n(rst_n),.clk(clk),.req(new_buf_req),.ref(ref_buf_numbr),.flag(flag),.buff(n_buf_num_replc),.access_time(access_time_1));
defparam counter_03.BIT = 5;
defparam counter_03.BUF = BUF_2;
counter counter_03(.rst_n(rst_n),.clk(clk),.req(new_buf_req),.ref(ref_buf_numbr),.flag(flag),.buff(n_buf_num_replc),.access_time(access_time_2));
defparam counter_04.BIT = 7;
defparam counter_04.BUF = BUF_3;
counter counter_04(.rst_n(rst_n),.clk(clk),.req(new_buf_req),.ref(ref_buf_numbr),.flag(flag),.buff(n_buf_num_replc),.access_time(access_time_3));
///////////// Replacement Flip Flop///////////////
always @ (posedge clk or negedge rst_n) begin 
  if (rst_n == 1'b0) begin
      temp_buf_num_replc <= #FF_DLY BUF_0;
  end
  else begin
      if (new_buf_req) begin
          temp_buf_num_replc <= #FF_DLY n_buf_num_replc;
      end
  end
end
///////////// Repalcement control logic ///////////
always @ (access_time_0 or access_time_1 or access_time_2 or access_time_3) begin
  min[0] = (access_time_0 > access_time_1) ? 1'b1 : 1'b0;
  min[1] = (access_time_2 > access_time_3) ? 1'b1 : 1'b0;
  case (min) 
      2'b00: begin 
        n_buf_num_replc = (access_time_0 > access_time_2) ? BUF_2 : BUF_0;
      end
      2'b01: begin 
        n_buf_num_replc = (access_time_1 > access_time_2) ? BUF_2 : BUF_1;
      end
      2'b10: begin 
        n_buf_num_replc = (access_time_0 > access_time_3) ? BUF_3 : BUF_0;
      end
      2'b11: begin 
        n_buf_num_replc = (access_time_1 > access_time_3) ? BUF_3 : BUF_1;
      end
  endcase
end
endmodule
//////////////// Access time control logic
module counter (rst_n, clk, ref, req, flag, buff, access_time);
  parameter BUF = 2'b00;//parameter
  parameter FF_DLY = 1;
  parameter LEN = 2;
  parameter LEN_F = 8;
  parameter BIT = 0;

  input rst_n; //port declaration
  input clk;
  input req;
  input [LEN-1:0] ref;
  input [LEN-1:0] buff;
  input [LEN_F-1:0]flag;
  output [LEN-1:0] access_time;

  wire rst_n, clk; // port data type
  wire req;
  wire [LEN-1:0] ref, temp;
  wire [LEN-1:0] access_time;
  wire [LEN_F-1:0] flag;

  reg [LEN-1:0] n_access_time;// internal variable
  reg [LEN-1:0] t;

  assign access_time = t;

  always @ (req or ref or flag or buff) begin
    if (req) begin 
      n_access_time = (buff == BUF) ? 2'b01 : flag[BIT:BIT-1]; 
    end
    else begin 
      case (flag[BIT:BIT-1])
          2'b01 : begin 
            n_access_time = (ref == BUF) ? 2'b10 : flag[BIT:BIT-1];
          end
          2'b10 : begin 
            n_access_time = (ref == BUF) ? 2'b11 : flag[BIT:BIT-1];
          end
          2'b11 : begin 
            if (flag == 8'hFF) begin 
              n_access_time = (ref == BUF) ? 2'b10 : 2'b01;
            end
            else begin 
              n_access_time = flag[BIT:BIT-1];
            end
          end
          default : begin
            n_access_time = 2'b00;
          end
      endcase
    end
  end

  always @ (posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      t <= #FF_DLY 2'b01;
    end
    else begin
      t <= #FF_DLY n_access_time;
    end
  end
endmodule
