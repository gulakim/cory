//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_RDMA1D
    `define CORY_RDMA1D

//------------------------------------------------------------------------------
//  1d read only dma
//------------------------------------------------------------------------------
module cory_rdma1d # (
    parameter   A       = 32,
    parameter   L       = 4,
    parameter   D       = 64,
    parameter   R       = 11,                   // # bit for resolution 
    parameter   Q       = 0                     // # of queue for output data
) (
    input           clk,

    input           i_cmd_v,
    input   [R-1:0] i_cmd_width,                // width in pixel
    input   [A-1:0] i_cmd_base,                 // base address of the line
    output          o_cmd_r,

    output          o_ar_v,
    output  [A-1:0] o_ar_a,
    output  [L-1:0] o_ar_l,
    input           i_ar_r,
    input           i_r_v,
    input           i_r_l,
    input   [D-1:0] i_r_d,
    output          o_r_r,

    output          o_dout_v,
    output  [D-1:0] o_dout_d,
    input           i_dout_r,

    input           reset_n
);

//------------------------------------------------------------------------------
localparam  BUS_WIDTH   = D/8;                  // byte
localparam  MAX_LEN     = (2**L);               // word
localparam  MAX_BYTE    = MAX_LEN * BUS_WIDTH;  // 16 * 8 = 128 byte
localparam  BYTE_ADDR_WIDTH = f_log2 (BUS_WIDTH);   // log2(8)=3

//------------------------------------------------------------------------------

wire    axi_ar_vr    = o_ar_v & i_ar_r;
wire    axi_r_vr    = i_r_v & o_r_r;
wire    dout_vr     = o_dout_v & i_dout_r;

//------------------------------------------------------------------------------

wire    cmd_start_1shot;
cory_posedge u_cmd_start_det (
    .clk            (clk),
    .i_a            (i_cmd_v & !o_cmd_r),       // continuous cmd_v and cmd_r cycle is to be removed
    .o_z            (cmd_start_1shot),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------

reg     [R-1:0] ar_cnt;
wire            ar_cnt_done     = ar_cnt >= i_cmd_width;
wire    [R-1:0] rem_ar_byte      = i_cmd_width > MAX_BYTE ? i_cmd_width - ar_cnt : i_cmd_width;
wire            ar_cnt_last     = rem_ar_byte <= MAX_BYTE ? 1'b1 : 1'b0;
wire    [R-1:0] ar_len_in_byte  = rem_ar_byte >= MAX_BYTE ? MAX_BYTE : rem_ar_byte;

reg     ar_v;
wire    ar_r;
wire    ar_vr   = ar_v & ar_r;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        ar_cnt  <= 0;
    else if (cmd_start_1shot)
        ar_cnt  <= 0;
    else if (ar_vr)
        ar_cnt  <= ar_cnt + ar_len_in_byte;


always @(posedge clk or negedge reset_n)
    if (!reset_n)
        ar_v    <= 0;
    else if (cmd_start_1shot)
        ar_v    <= 1;
    else if (ar_vr & ar_cnt_last)
        ar_v    <= 0;

reg     [A-1:0] ar_addr;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        ar_addr <= 0;
    else if (cmd_start_1shot)
        ar_addr <= i_cmd_base;
    else if (ar_vr)
        ar_addr <= ar_addr + ar_len_in_byte;

wire    [L:0]   ar_len_in_word  = ar_len_in_byte[R-1:BYTE_ADDR_WIDTH] + (|ar_len_in_byte[BYTE_ADDR_WIDTH-1:0]);
wire    [L-1:0] ar_len          = ar_len_in_word - 1'b1;

assign  o_ar_v   = ar_v;
assign  o_ar_l   = ar_len;
assign  o_ar_a   = ar_addr;
assign  ar_r    = i_ar_r;

//------------------------------------------------------------------------------

reg     [R-1:0] dout_cnt;
wire    [R-1:0] rem_dout_byte    = i_cmd_width - dout_cnt;
wire    [R-1:0] dout_addr        = dout_cnt[R-1:BYTE_ADDR_WIDTH];   // word address
wire            dout_cnt_last    = dout_cnt >= i_cmd_width - BUS_WIDTH;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        dout_cnt <= {R{1'b1}};
    else if (cmd_start_1shot)
        dout_cnt <= 0;
    else if (dout_vr)
        dout_cnt <= dout_cnt + BUS_WIDTH;

//------------------------------------------------------------------------------
cory_queue #(.N(D), .Q(Q)) u_queue (
    .clk            (clk),
    .i_a_v          (i_r_v),
    .i_a_d          (i_r_d),
    .o_a_r          (o_r_r),
    .o_z_v          (o_dout_v),
    .o_z_d          (o_dout_d),
    .i_z_r          (i_dout_r),
    .reset_n        (reset_n)
);

//  assign  o_dout_v    = i_r_v;
//  assign  o_dout_d    = i_r_d;
//  assign  o_r_r       = i_dout_r;

//------------------------------------------------------------------------------

assign  o_cmd_r = i_cmd_v & dout_vr & dout_cnt_last;

//------------------------------------------------------------------------------

`ifdef  SIM
    cory_axiro_monitor #(.A(A), .D(D), .L(L)) u_axiro_mon (
        .clk            (clk),
        .i_ar_v         (o_ar_v),
        .i_ar_a         (o_ar_a),
        .i_ar_l         (o_ar_l),
        .i_ar_r         (i_ar_r),
        .i_r_v          (i_r_v),
        .i_r_d          (i_r_d),
        .i_r_l          (i_r_l),
        .i_r_r          (o_r_r),
        .reset_n        (reset_n)
    );

    initial
        if (D > 1024 || (2**BYTE_ADDR_WIDTH != BUS_WIDTH)) begin
            $display ("ERROR:%m: D = %d, not supported", D);
            $finish;
        end
`endif

//------------------------------------------------------------------------------
function integer f_log2;
    input   integer value;
    begin
		     if(value <= 2) f_log2= 1;
		else if(value <= 4) f_log2= 2;
		else if(value <= 8) f_log2= 3;
		else if(value <= 16) f_log2= 4;
		else if(value <= 32) f_log2= 5;
		else if(value <= 64) f_log2= 6;
		else if(value <= 128) f_log2= 7;
		else if(value <= 256) f_log2= 8;
		else if(value <= 512) f_log2= 9;
		else if(value <= 1024) f_log2= 10;
		else if(value <= 2048) f_log2= 11;
		else if(value <= 4096) f_log2= 12;
		else if(value <= 8192) f_log2= 13;
		else if(value <= 16384) f_log2= 14;
		else if(value <= 32768) f_log2= 15;
		else if(value <= 65536) f_log2= 16;
    end
endfunction

endmodule


`endif
