//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_WDMA1D
    `define CORY_WDMA1D

//------------------------------------------------------------------------------
//  write-only dma
//------------------------------------------------------------------------------
module cory_wdma1d # (
    parameter   A       = 32,
    parameter   L       = 4,
    parameter   D       = 64,
    parameter   R       = 11                    // # bit for resolution 
) (
    input           clk,

    input           i_cmd_v,
    input   [R-1:0] i_cmd_width,
    input   [A-1:0] i_cmd_base,
    output          o_cmd_r,

    output          o_aw_v,
    output  [A-1:0] o_aw_a,
    output  [L-1:0] o_aw_l,
    input           i_aw_r,
    output          o_w_v,
    output          o_w_l,
    output  [D-1:0] o_w_d,
    input           i_w_r,

    input           i_din_v,
    input   [D-1:0] i_din_d,
    output          o_din_r,

    input           reset_n
);

//------------------------------------------------------------------------------
localparam  BUS_WIDTH   = D/8;                  // byte
localparam  MAX_LEN     = (2**L);               // word
localparam  MAX_BYTE    = MAX_LEN * BUS_WIDTH;  // 16 * 8 = 128 byte
localparam  BYTE_ADDR_WIDTH = f_log2 (BUS_WIDTH);   // log2(8)=3

//------------------------------------------------------------------------------

wire    cmd_start_1shot;
cory_posedge u_cmd_start_det (
    .clk            (clk),
    .i_a            (i_cmd_v & !o_cmd_r),       // continuous cmd_v and cmd_r cycle is to be removed
    .o_z            (cmd_start_1shot),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------

wire    axi_aw_vr    = o_aw_v & i_aw_r;
wire    axi_w_vr    = o_w_v & i_w_r;
wire    data_vr     = i_din_v & o_din_r;

//------------------------------------------------------------------------------

reg     [R-1:0] aw_cnt;
wire            aw_cnt_done     = aw_cnt >= i_cmd_width;
wire    [R-1:0] rem_aw_byte      = i_cmd_width > MAX_BYTE ? i_cmd_width - aw_cnt : i_cmd_width;
wire            aw_cnt_len      = rem_aw_byte <= MAX_BYTE ? 1'b1 : 1'b0;
wire    [R-1:0] aw_len_in_byte  = rem_aw_byte >= MAX_BYTE ? MAX_BYTE : rem_aw_byte;

reg     aw_v;
wire    aw_r;
wire    aw_vr   = aw_v & aw_r;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        aw_cnt  <= 0;
    else if (cmd_start_1shot)
        aw_cnt  <= 0;
    else if (aw_vr)
        aw_cnt  <= aw_cnt + aw_len_in_byte;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        aw_v    <= 0;
    else if (cmd_start_1shot)
        aw_v    <= 1;
    else if (aw_vr & aw_cnt_len)
        aw_v    <= 0;

reg     [A-1:0] aw_addr;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        aw_addr <= 0;
    else if (cmd_start_1shot)
        aw_addr <= i_cmd_base;
    else if (aw_vr)
        aw_addr <= aw_addr + aw_len_in_byte;

wire    [L:0]   aw_len_in_word  = aw_len_in_byte[R-1:BYTE_ADDR_WIDTH] + (|aw_len_in_byte[BYTE_ADDR_WIDTH-1:0]);
wire    [L-1:0] aw_len          = aw_len_in_word - 1'b1;

//------------------------------------------------------------------------------

wire            w_len_queue_v;                  // aw-queue'd _l
wire    [A-1:0] w_len_queue_a;                  // only _l used after
wire    [L-1:0] w_len_queue_l;                  // only _l used after
wire            w_len_queue_r;

cory_dup2 #(.N(A+L)) u_awreq_split (
    .clk            (clk),
    .i_a_v          (aw_v),
    .i_a_d          ({aw_addr, aw_len}),
    .o_a_r          (aw_r),
    .o_z0_v         (o_aw_v),
    .o_z0_d         ({o_aw_a, o_aw_l}),
    .i_z0_r         (i_aw_r),
    .o_z1_v         (w_len_queue_v),
    .o_z1_d         ({w_len_queue_a, w_len_queue_l}),
    .i_z1_r         (w_len_queue_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------

wire            w_len_v;
wire    [L-1:0]  w_len_d;
wire            w_len_r;

cory_queue #(.N(L), .Q(2)) u_w_d_cnt (
    .clk            (clk),
    .i_a_v          (w_len_queue_v),
    .i_a_d          (w_len_queue_l),
    .o_a_r          (w_len_queue_r),
    .o_z_v          (w_len_v),
    .o_z_d          (w_len_d),
    .i_z_r          (w_len_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------

reg     [L-1:0]  wcnt;

assign  o_w_v   = i_din_v & w_len_v;
assign  o_w_d   = i_din_d;
assign  o_w_l   = (wcnt == w_len_d) & w_len_v;

assign  w_len_r = w_len_v & o_w_l & axi_w_vr;
assign  o_din_r = i_din_v & i_w_r;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        wcnt    <= 0;
    else if (axi_w_vr) begin
        if (o_w_l)
            wcnt    <= 0;
        else
            wcnt    <= wcnt + 1;
    end

//------------------------------------------------------------------------------

reg     [R-1:0] data_cnt;
wire    [R-1:0] rem_din_byte    = i_cmd_width - data_cnt;
wire    [R-1:0] data_addr       = data_cnt[R-1:BYTE_ADDR_WIDTH];        // word address
wire            data_cnt_len    = data_cnt >= i_cmd_width - BUS_WIDTH;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        data_cnt <= {R{1'b1}};
    else if (cmd_start_1shot)
        data_cnt <= 0;
    else if (axi_w_vr)
        data_cnt <= data_cnt + BUS_WIDTH;

//------------------------------------------------------------------------------

assign  o_cmd_r = i_cmd_v & axi_w_vr & data_cnt_len;

//------------------------------------------------------------------------------

`ifdef  SIM
    cory_axiwo_monitor #(.A(A), .D(D), .L(L)) u_axiwo_mon (
        .clk            (clk),
        .i_aw_v         (o_aw_v),
        .i_aw_a         (o_aw_a),
        .i_aw_l         (o_aw_l),
        .i_aw_r         (i_aw_r),
        .i_w_v          (o_w_v),
        .i_w_d          (o_w_d),
        .i_w_l          (o_w_l),
        .i_w_r          (i_w_r),
        .reset_n        (reset_n)
    );

    initial
        if (D > 1024 || (2**BYTE_ADDR_WIDTH != BUS_WIDTH)) begin
            $display ("ERROR:%m: D = %d, not supported", D);
            $finish;
        end
`endif

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
