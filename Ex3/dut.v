module bit_block_counter (data,
                          data_enb,
                          clk,
                          rst_n,
                          block_cnt,
                          valid);
  parameter DATA_B_W = 32;
  parameter CNT_B_W = 4;

  parameter NO_B_1 = 2'b00;
  parameter ONE_B_1 = 2'b01;
  parameter TWO_B_1 = 2'b10;
  parameter BLCK_B_1 = 2'b11;
  
  input [DATA_B_W-1:0] data;
  input data_enb;
  input clk;
  input rst_n;

  output [CNT_B_W-1:0] block_cnt;
  output valid;

  wire [DATA_B_W-1:0] data;
  wire data_enb;
  wire clk;
  wire rst_n;

  reg [CNT_B_W-1:0] block_cnt;
  wire valid;

  //Internal variable  
  reg [DATA_B_W-1:0] data_int;
  wire data_enb_int;
  wire valid_int;
  reg [DATA_B_W:0] flg;
  reg [1:0] state;
  reg [CNT_B_W-1:0] block_cnt_int;

  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      data_int <= 32'h0000_0000;
    end
    else begin
      if (data_enb == 1'b1) begin
        data_int <= data;
      end
    end
  end

  ff_1_bit ff_1_bit_01 (.data(data_enb),
                        .clk(clk),
                        .rst_n(rst_n),
                        .next_data(data_enb_int));

  assign valid_int = data_enb_int;

  ff_1_bit ff_1_bit_02 (.data(valid_int),
                        .clk(clk),
                        .rst_n(rst_n),
                        .next_data(valid));


  always @(data_int) begin
    block_cnt_int = 4'b0000;
    state = NO_B_1;
    flg = 32'h0000_0000;
  end

  genvar k;

  generate
  for (k=0; k<=DATA_B_W-1; k=k+1) begin : cntr_time
    always @(flg[k]) begin
      case (data_int) 
        1'b0: begin
                state = NO_B_1;
              end
        1'b1: begin
                if (state == NO_B_1) begin
                  state = ONE_B_1;
                end
                else if (state == ONE_B_1) begin
                  state = BLCK_B_1;
                end
                else begin
                  state = BLCK_B_1;
                end
              end
        default: begin
                   state = 2'b11;
                 end
      endcase
      flg[k+1] = 1'b1;
    end

    always @(state) begin
      case (state) 
        NO_B_1, ONE_B_1, BLCK_B_1: begin
                                     block_cnt_int = block_cnt_int;
                                   end
        TWO_B_1: begin
                   block_cnt_int = block_cnt_int + 1;
                 end
        default: begin
                   block_cnt_int = 4'b1111;
                 end
      endcase
    end
  end
  endgenerate

  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      block_cnt <= 4'h0;
    end
    else begin
      block_cnt <= block_cnt_int;
    end
  end
endmodule

module ff_1_bit (data,
                 clk,
                 rst_n,
                 next_data);

  input data;
  input clk;
  input rst_n;
  
  output next_data;

  wire data;
  wire clk;
  wire rst_n;

  reg next_data;

  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      next_data <= 1'b0;
    end
    else begin
      next_data <= data;
    end
  end
endmodule

