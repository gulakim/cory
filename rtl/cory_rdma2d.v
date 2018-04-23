//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_RDMA2D
    `define CORY_RDMA2D

//------------------------------------------------------------------------------
//  2d read only dma
//------------------------------------------------------------------------------
module cory_rdma2d # (
    parameter   A       = 32,
    parameter   L       = 4,
    parameter   D       = 64,
    parameter   S       = 16,                   // for stride
    parameter   R       = 11,                   // # bit for resolution 
    parameter   Q       = 0                     // # of queue for output data
) (
    input           clk,

    input           i_cmd_v,
    input   [R-1:0] i_cmd_width,                // pixel width
    input   [R-1:0] i_cmd_height,               // pixel height
    input   [A-1:0] i_cmd_base,                 // base address of 2d
    input   [S-1:0] i_cmd_stride,               // stride for the next line
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

    output          o_cmd_1d_vr,

    input           reset_n
);

//------------------------------------------------------------------------------

wire    cmd_start_1shot;
cory_posedge u_cmd_start_det (
    .clk            (clk),
    .i_a            (i_cmd_v),
    .o_z            (cmd_start_1shot),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            cmd_1d_vr;

assign  o_cmd_1d_vr = cmd_1d_vr;

reg     [A-1:0] ar_base;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        ar_base <= i_cmd_base;
    else if (cmd_start_1shot)
        ar_base <= i_cmd_base;
    else if (cmd_1d_vr)
        ar_base <= ar_base + i_cmd_stride;

//------------------------------------------------------------------------------

reg     [R-1:0] line_cnt;
wire            line_cnt_last   = line_cnt >= (i_cmd_height - 1'b1);

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        line_cnt <= {R{1'b1}};
    else if (cmd_start_1shot)
        line_cnt <= 0;
    else if (cmd_1d_vr)
        if (line_cnt_last)
            line_cnt    <= 0;
        else
            line_cnt <= line_cnt + 1'b1;

//------------------------------------------------------------------------------
reg             cmd_1d_v;
wire            cmd_1d_r;
wire    [R-1:0] cmd_1d_width    = i_cmd_width;
wire    [A-1:0] cmd_1d_base     = ar_base;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        cmd_1d_v    <= 0;
    else if (cmd_start_1shot)                   // frame
        cmd_1d_v    <= 1;
    else if (cmd_1d_vr & line_cnt_last)
        cmd_1d_v    <= 0;

assign  cmd_1d_vr   = cmd_1d_v & cmd_1d_r;

//------------------------------------------------------------------------------

cory_rdma1d #(.A(A), .D(D), .L(L), .R(R), .Q(Q)) u_rdma1d (
    .clk            (clk),
    .i_cmd_v        (cmd_1d_v),
    .i_cmd_width    (cmd_1d_width),
    .i_cmd_base     (cmd_1d_base),
    .o_cmd_r        (cmd_1d_r),

    .o_ar_v         (o_ar_v),
    .o_ar_a         (o_ar_a),
    .o_ar_l         (o_ar_l),
    .i_ar_r         (i_ar_r),

    .i_r_v          (i_r_v),
    .i_r_l          (i_r_l),
    .i_r_d          (i_r_d),
    .o_r_r          (o_r_r),

    .o_dout_v       (o_dout_v),
    .o_dout_d       (o_dout_d),
    .i_dout_r       (i_dout_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------

//  assign  o_cmd_r  = i_cmd_v & cmd_1d_vr & line_cnt_last;
assign  o_cmd_r  = cmd_1d_vr & line_cnt_last;

//------------------------------------------------------------------------------
`ifdef  SIM
    cory_monitor #(.N(A+R)) u_mon_cmd (
        .clk        (clk),
        .i_v        (cmd_1d_v),
        .i_d        ({cmd_1d_base, cmd_1d_width}),
        .i_r        (cmd_1d_r),
        .reset_n    (reset_n)
    );

`endif                                          //  SIM
endmodule


`endif
