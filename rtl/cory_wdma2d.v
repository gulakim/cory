//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_WDMA2D
    `define CORY_WDMA2D

//------------------------------------------------------------------------------
module cory_wdma2d # (
    parameter   A       = 32,
    parameter   L       = 4,
    parameter   D       = 64,
    parameter   S       = 16,                   // for stride
    parameter   R       = 11                    // # bit for resolution 
) (
    input           clk,

    input           i_cmd_v,
    input   [R-1:0] i_cmd_width,
    input   [R-1:0] i_cmd_height,
    input   [A-1:0] i_cmd_base,
    input   [S-1:0] i_cmd_stride,
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

reg     [A-1:0] aw_base;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        aw_base <= i_cmd_base;
    else if (cmd_start_1shot)
        aw_base <= i_cmd_base;
    else if (cmd_1d_vr)
        aw_base <= aw_base + i_cmd_stride;

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
wire    [A-1:0] cmd_1d_base     = aw_base;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        cmd_1d_v    <= 0;
    else if (cmd_start_1shot)                   // frame
        cmd_1d_v    <= 1;
    else if (cmd_1d_vr & line_cnt_last)
        cmd_1d_v    <= 0;

assign  cmd_1d_vr   = cmd_1d_v & cmd_1d_r;

//------------------------------------------------------------------------------

cory_wdma1d #(.A(A), .L(L), .D(D), .R(R)) u_wdma1d (
    .clk            (clk),
    .i_cmd_v        (cmd_1d_v),
    .i_cmd_width    (cmd_1d_width),
    .i_cmd_base     (cmd_1d_base),
    .o_cmd_r        (cmd_1d_r),

    .o_aw_v         (o_aw_v),
    .o_aw_a         (o_aw_a),
    .o_aw_l         (o_aw_l),
    .i_aw_r         (i_aw_r),
    .o_w_v          (o_w_v),
    .o_w_l          (o_w_l),
    .o_w_d          (o_w_d),
    .i_w_r          (i_w_r),

    .i_din_v        (i_din_v),
    .i_din_d        (i_din_d),
    .o_din_r        (o_din_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------

assign  o_cmd_r  = i_cmd_v & cmd_1d_vr & line_cnt_last;

//------------------------------------------------------------------------------
`ifdef  SIM
    cory_monitor #(.N(R+A)) u_mon_cmd (
        .clk        (clk),
        .i_v        (cmd_1d_v),
        .i_d        ({cmd_1d_base, cmd_1d_width}),
        .i_r        (cmd_1d_r),
        .reset_n    (reset_n)
    );

`endif                                          //  SIM

endmodule


`endif
