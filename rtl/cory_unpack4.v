//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_UNPACK4
    `define CORY_UNPACK4

//------------------------------------------------------------------------------
module cory_unpack4 #(
    parameter   N   = 8,
    parameter   Z0  = N,
    parameter   Z1  = N,
    parameter   Z2  = N,
    parameter   Z3  = N,
    parameter   A   = Z0 + Z1 + Z2 + Z3
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
    input           reset_n
);

//------------------------------------------------------------------------------
localparam  X   = Z0 + Z1;
localparam  Y   = Z2 + Z3;

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

cory_unpack2 #(.Z0(Z0), .Z1(Z1)) u_unpack_low (
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
    .reset_n    (reset_n)
);

cory_unpack2 #(.Z0(Z2), .Z1(Z3)) u_unpack_high (
    .clk        (clk),
    .i_a_v      (y_v),
    .i_a_d      (y_d),
    .o_a_r      (y_r),
    .o_z0_v     (o_z2_v),
    .o_z0_d     (o_z2_d),
    .i_z0_r     (i_z2_r),
    .o_z1_v     (o_z3_v),
    .o_z1_d     (o_z3_d),
    .i_z1_r     (i_z3_r),
    .reset_n    (reset_n)
);

`ifdef SIM
`ifdef  CORY_MON
`endif                                          //  CORY_MON
`endif
endmodule


`endif
