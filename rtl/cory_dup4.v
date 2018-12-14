//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_DUP4
    `define CORY_DUP4

//------------------------------------------------------------------------------
module cory_dup4 #(
    parameter   N   = 16,
    parameter   Q   = 0,
    parameter   Q0  = Q,
    parameter   Q1  = Q,
    parameter   Q2  = Q,
    parameter   Q3  = Q
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    output          o_z0_v,
    output  [N-1:0] o_z0_d,
    input           i_z0_r,

    output          o_z1_v,
    output  [N-1:0] o_z1_d,
    input           i_z1_r,

    output          o_z2_v,
    output  [N-1:0] o_z2_d,
    input           i_z2_r,

    output          o_z3_v,
    output  [N-1:0] o_z3_d,
    input           i_z3_r,

    input           reset_n
);

//------------------------------------------------------------------------------
wire            z0_v;
wire    [N-1:0] z0_d;
wire            z0_r;
wire            z1_v;
wire    [N-1:0] z1_d;
wire            z1_r;

cory_dup2 #(.N(N)) u_dup_0 (
    .clk            (clk),
    .i_a_v          (i_a_v),
    .i_a_d          (i_a_d),
    .o_a_r          (o_a_r),
    .o_z0_v         (z0_v),
    .o_z0_d         (z0_d),
    .i_z0_r         (z0_r),
    .o_z1_v         (z1_v),
    .o_z1_d         (z1_d),
    .i_z1_r         (z1_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------

cory_dup2 #(.N(N), .Q0(Q0), .Q1(Q1)) u_dup_1 (
    .clk            (clk),
    .i_a_v          (z0_v),
    .i_a_d          (z0_d),
    .o_a_r          (z0_r),
    .o_z0_v         (o_z0_v),
    .o_z0_d         (o_z0_d),
    .i_z0_r         (i_z0_r),
    .o_z1_v         (o_z1_v),
    .o_z1_d         (o_z1_d),
    .i_z1_r         (i_z1_r),
    .reset_n        (reset_n)
);

cory_dup2 #(.N(N), .Q0(Q2), .Q1(Q3)) u_dup_2 (
    .clk            (clk),
    .i_a_v          (z1_v),
    .i_a_d          (z1_d),
    .o_a_r          (z1_r),
    .o_z0_v         (o_z2_v),
    .o_z0_d         (o_z2_d),
    .i_z0_r         (i_z2_r),
    .o_z1_v         (o_z3_v),
    .o_z1_d         (o_z3_d),
    .i_z1_r         (i_z3_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
`ifdef SIM

`ifdef  CORY_MON
`endif                                          //  CORY_MON

`endif
endmodule


`endif
