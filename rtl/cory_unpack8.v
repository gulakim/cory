//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_UNPACK8
    `define CORY_UNPACK8

//------------------------------------------------------------------------------
module cory_unpack8 #(
    parameter   N   = 8,
    parameter   Z0  = N,
    parameter   Z1  = N,
    parameter   Z2  = N,
    parameter   Z3  = N,
    parameter   Z4  = N,
    parameter   Z5  = N,
    parameter   Z6  = N,
    parameter   Z7  = N,
    parameter   A   = Z0 + Z1 + Z2 + Z3 + Z4 + Z5 + Z6 + Z7
) (
    input           clk,
    input           i_a_v,
    input   [A-1:0] i_a_d,
    output          o_a_r,

    output          o_z0_v,
    output  [Z0-1:0]o_z0_d,
    input           i_z0_r,
    output          o_z1_v,
    output  [Z1-1:0]o_z1_d,
    input           i_z1_r,
    output          o_z2_v,
    output  [Z2-1:0]o_z2_d,
    input           i_z2_r,
    output          o_z3_v,
    output  [Z3-1:0]o_z3_d,
    input           i_z3_r,
    output          o_z4_v,
    output  [Z4-1:0]o_z4_d,
    input           i_z4_r,
    output          o_z5_v,
    output  [Z5-1:0]o_z5_d,
    input           i_z5_r,
    output          o_z6_v,
    output  [Z6-1:0]o_z6_d,
    input           i_z6_r,
    output          o_z7_v,
    output  [Z7-1:0]o_z7_d,
    input           i_z7_r,

    input           reset_n
);

//------------------------------------------------------------------------------
localparam  X   = Z0 + Z1 + Z2 + Z3;
localparam  Y   = Z4 + Z5 + Z6 + Z7;

wire            x_v;
wire    [X-1:0] x_d;
wire            x_r;

wire            y_v;
wire    [Y-1:0] y_d;
wire            y_r;

cory_unpack2 #(.Z0(X), .Z1(Y)) u_unpack_all (
    .clk        (clk),
    .i_a_v      (i_a_v),
    .i_a_d      (i_a_d),
    .o_a_r      (o_a_r),
    .o_z0_v     (x_v),
    .o_z0_d     (x_d),
    .i_z0_r     (x_r),
    .o_z1_v     (y_v),
    .o_z1_d     (y_d),
    .i_z1_r     (y_r),
    .reset_n    (reset_n)
);

cory_unpack4 #(.Z0(Z0), .Z1(Z1), .Z2(Z2), .Z3(Z3)) u_unpack_low (
    .clk        (clk),
    .i_a_v      (x_v),
    .i_a_d      (x_d),
    .o_a_r      (x_r),
    .o_z0_v     (o_z0_v),
    .o_z0_d     (o_z0_d),
    .i_z0_r     (i_z0_r),
    .o_z1_v     (o_z1_v),
    .o_z1_d     (o_z1_d),
    .i_z1_r     (i_z1_r),
    .o_z2_v     (o_z2_v),
    .o_z2_d     (o_z2_d),
    .i_z2_r     (i_z2_r),
    .o_z3_v     (o_z3_v),
    .o_z3_d     (o_z3_d),
    .i_z3_r     (i_z3_r),
    .reset_n    (reset_n)
);

cory_unpack4 #(.Z0(Z4), .Z1(Z5), .Z2(Z6), .Z3(Z7)) u_unpack_high (
    .clk        (clk),
    .i_a_v      (y_v),
    .i_a_d      (y_d),
    .o_a_r      (y_r),
    .o_z0_v     (o_z4_v),
    .o_z0_d     (o_z4_d),
    .i_z0_r     (i_z4_r),
    .o_z1_v     (o_z5_v),
    .o_z1_d     (o_z5_d),
    .i_z1_r     (i_z5_r),
    .o_z2_v     (o_z6_v),
    .o_z2_d     (o_z6_d),
    .i_z2_r     (i_z6_r),
    .o_z3_v     (o_z7_v),
    .o_z3_d     (o_z7_d),
    .i_z3_r     (i_z7_r),
    .reset_n    (reset_n)
);

`ifdef SIM
`ifdef  CORY_MON
`endif                                          //  CORY_MON
`endif
endmodule


`endif
