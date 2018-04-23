//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_ARB8
    `define CORY_ARB8

//------------------------------------------------------------------------------
module cory_arb8 # (
    parameter   N       = 8,                    // # of data bits
    parameter   ROUND   = 1,                    // 1:round, 0:port (0>1>2=3>4=5=6=7)
    parameter   Q       = 0
) (
    input           clk,

    input           i_a0_v,
    input   [N-1:0] i_a0_d,
    output          o_a0_r,

    input           i_a1_v,
    input   [N-1:0] i_a1_d,
    output          o_a1_r,

    input           i_a2_v,
    input   [N-1:0] i_a2_d,
    output          o_a2_r,

    input           i_a3_v,
    input   [N-1:0] i_a3_d,
    output          o_a3_r,

    input           i_a4_v,
    input   [N-1:0] i_a4_d,
    output          o_a4_r,

    input           i_a5_v,
    input   [N-1:0] i_a5_d,
    output          o_a5_r,

    input           i_a6_v,
    input   [N-1:0] i_a6_d,
    output          o_a6_r,

    input           i_a7_v,
    input   [N-1:0] i_a7_d,
    output          o_a7_r,

    output          o_z_v,
    output  [N-1:0] o_z_d,
    output  [2:0]   o_z_s,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
wire            x_v;
wire    [N-1:0] x_d;
wire            x_r;
wire    [1:0]   x_s;

cory_arb4 #(.N(N), .ROUND(ROUND), .Q(Q)) u_arb_low (
    .clk        (clk),
    .i_a0_v     (i_a0_v),
    .i_a0_d     (i_a0_d),
    .o_a0_r     (o_a0_r),
    .i_a1_v     (i_a1_v),
    .i_a1_d     (i_a1_d),
    .o_a1_r     (o_a1_r),
    .i_a2_v     (i_a2_v),
    .i_a2_d     (i_a2_d),
    .o_a2_r     (o_a2_r),
    .i_a3_v     (i_a3_v),
    .i_a3_d     (i_a3_d),
    .o_a3_r     (o_a3_r),
    .o_z_v      (x_v),
    .o_z_d      (x_d),
    .o_z_s      (x_s),
    .i_z_r      (x_r),
    .reset_n    (reset_n)
);

wire            y_v;
wire    [N-1:0] y_d;
wire            y_r;
wire    [1:0]   y_s;

cory_arb4 #(.N(N), .ROUND(1), .Q(Q)) u_arb_high (
    .clk        (clk),
    .i_a0_v     (i_a4_v),
    .i_a0_d     (i_a4_d),
    .o_a0_r     (o_a4_r),
    .i_a1_v     (i_a5_v),
    .i_a1_d     (i_a5_d),
    .o_a1_r     (o_a5_r),
    .i_a2_v     (i_a6_v),
    .i_a2_d     (i_a6_d),
    .o_a2_r     (o_a6_r),
    .i_a3_v     (i_a7_v),
    .i_a3_d     (i_a7_d),
    .o_a3_r     (o_a7_r),
    .o_z_v      (y_v),
    .o_z_d      (y_d),
    .o_z_s      (y_s),
    .i_z_r      (y_r),
    .reset_n    (reset_n)
);

//------------------------------------------------------------------------------
wire    z_s1;

cory_arb2 #(.N(N), .ROUND(ROUND), .Q(Q)) u_arb (
    .clk        (clk),
    .i_a0_v     (x_v),
    .i_a0_d     (x_d),
    .o_a0_r     (x_r),
    .i_a1_v     (y_v),
    .i_a1_d     (y_d),
    .o_a1_r     (y_r),
    .o_z_v      (o_z_v),
    .o_z_d      (o_z_d),
    .o_z_s      (z_s1),
    .i_z_r      (i_z_r),
    .reset_n    (reset_n)
);

assign  o_z_s   = z_s1 ? {z_s1, y_s} : {z_s1, x_s};

endmodule

`endif                                          // CORY_ARBR4
