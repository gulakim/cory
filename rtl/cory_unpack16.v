//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_UNPACK16
    `define CORY_UNPACK16

//------------------------------------------------------------------------------
module cory_unpack16 #(
    parameter   N   = 8,
    parameter   Z0  = N,
    parameter   Z1  = N,
    parameter   Z2  = N,
    parameter   Z3  = N,
    parameter   Z4  = N,
    parameter   Z5  = N,
    parameter   Z6  = N,
    parameter   Z7  = N,
    parameter   Z8  = N,
    parameter   Z9  = N,
    parameter   ZA  = N,
    parameter   ZB  = N,
    parameter   ZC  = N,
    parameter   ZD  = N,
    parameter   ZE  = N,
    parameter   ZF  = N,
    parameter   A   = Z0 + Z1 + Z2 + Z3 + Z4 + Z5 + Z6 + Z7 + Z8 + Z9 + ZA + ZB + ZC + ZD + ZE + ZF
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
    output          o_z8_v,
    output  [Z8-1:0]o_z8_d,
    input           i_z8_r,
    output          o_z9_v,
    output  [Z9-1:0]o_z9_d,
    input           i_z9_r,
    output          o_za_v,
    output  [ZA-1:0]o_za_d,
    input           i_za_r,
    output          o_zb_v,
    output  [ZB-1:0]o_zb_d,
    input           i_zb_r,
    output          o_zc_v,
    output  [ZC-1:0]o_zc_d,
    input           i_zc_r,
    output          o_zd_v,
    output  [ZD-1:0]o_zd_d,
    input           i_zd_r,
    output          o_ze_v,
    output  [ZE-1:0]o_ze_d,
    input           i_ze_r,
    output          o_zf_v,
    output  [ZF-1:0]o_zf_d,
    input           i_zf_r,

    input           reset_n
);

//------------------------------------------------------------------------------
localparam  X   = Z0 + Z1 + Z2 + Z3 + Z4 + Z5 + Z6 + Z7;
localparam  Y   = Z8 + Z9 + ZA + ZB + ZC + ZD + ZE + ZF;

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

cory_unpack8 #(.Z0(Z0), .Z1(Z1), .Z2(Z2), .Z3(Z3), .Z4(Z4), .Z5(Z5), .Z6(Z6), .Z7(Z7)) u_unpack_low (
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
    .o_z4_v     (o_z4_v),
    .o_z4_d     (o_z4_d),
    .i_z4_r     (i_z4_r),
    .o_z5_v     (o_z5_v),
    .o_z5_d     (o_z5_d),
    .i_z5_r     (i_z5_r),
    .o_z6_v     (o_z6_v),
    .o_z6_d     (o_z6_d),
    .i_z6_r     (i_z6_r),
    .o_z7_v     (o_z7_v),
    .o_z7_d     (o_z7_d),
    .i_z7_r     (i_z7_r),
    .reset_n    (reset_n)
);

cory_unpack8 #(.Z0(Z8), .Z1(Z9), .Z2(ZA), .Z3(ZB), .Z4(ZC), .Z5(ZD), .Z6(ZE), .Z7(ZF)) u_unpack_high (
    .clk        (clk),
    .i_a_v      (y_v),
    .i_a_d      (y_d),
    .o_a_r      (y_r),
    .o_z0_v     (o_z8_v),
    .o_z0_d     (o_z8_d),
    .i_z0_r     (i_z8_r),
    .o_z1_v     (o_z9_v),
    .o_z1_d     (o_z9_d),
    .i_z1_r     (i_z9_r),
    .o_z2_v     (o_za_v),
    .o_z2_d     (o_za_d),
    .i_z2_r     (i_za_r),
    .o_z3_v     (o_zb_v),
    .o_z3_d     (o_zb_d),
    .i_z3_r     (i_zb_r),
    .o_z4_v     (o_zc_v),
    .o_z4_d     (o_zc_d),
    .i_z4_r     (i_zc_r),
    .o_z5_v     (o_zd_v),
    .o_z5_d     (o_zd_d),
    .i_z5_r     (i_zd_r),
    .o_z6_v     (o_ze_v),
    .o_z6_d     (o_ze_d),
    .i_z6_r     (i_ze_r),
    .o_z7_v     (o_zf_v),
    .o_z7_d     (o_zf_d),
    .i_z7_r     (i_zf_r),
    .reset_n    (reset_n)
);

`ifdef SIM
`ifdef  CORY_MON
`endif                                          //  CORY_MON
`endif
endmodule


`endif
