//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_PACK4
    `define CORY_PACK4

//------------------------------------------------------------------------------
module cory_pack4 #(
    parameter   N   = 8,
    parameter   A0  = N,
    parameter   A1  = N,
    parameter   A2  = N,
    parameter   A3  = N,
    parameter   Z   = A0 + A1 + A2 + A3
) (
    input           clk,
    input           i_a0_v,
    input   [A0-1:0]i_a0_d,
    output          o_a0_r,
    input           i_a1_v,
    input   [A1-1:0]i_a1_d,
    output          o_a1_r,
    input           i_a2_v,
    input   [A2-1:0]i_a2_d,
    output          o_a2_r,
    input           i_a3_v,
    input   [A3-1:0]i_a3_d,
    output          o_a3_r,

    output          o_z_v,
    output  [Z-1:0] o_z_d,
    input           i_z_r,
    input           reset_n
);

//------------------------------------------------------------------------------
localparam  X   = A0 + A1;
localparam  Y   = A2 + A3;

wire            x0_v;
wire    [X-1:0] x0_d;
wire            x0_r;

wire            x1_v;
wire    [Y-1:0] x1_d;
wire            x1_r;

cory_pack2 #(.A0(A0), .A1(A1)) u_pack_low (
    .clk        (clk),
    .i_a0_v     (i_a0_v),
    .i_a0_d     (i_a0_d),
    .o_a0_r     (o_a0_r),
    .i_a1_v     (i_a1_v),
    .i_a1_d     (i_a1_d),
    .o_a1_r     (o_a1_r),
    .o_z_v      (x0_v),
    .o_z_d      (x0_d),
    .i_z_r      (x0_r),
    .reset_n    (reset_n)
);

cory_pack2 #(.A0(A2), .A1(A3)) u_pack_high (
    .clk        (clk),
    .i_a0_v     (i_a2_v),
    .i_a0_d     (i_a2_d),
    .o_a0_r     (o_a2_r),
    .i_a1_v     (i_a3_v),
    .i_a1_d     (i_a3_d),
    .o_a1_r     (o_a3_r),
    .o_z_v      (x1_v),
    .o_z_d      (x1_d),
    .i_z_r      (x1_r),
    .reset_n    (reset_n)
);

cory_pack2 #(.A0(X), .A1(Y)) u_pack_all (
    .clk        (clk),
    .i_a0_v     (x0_v),
    .i_a0_d     (x0_d),
    .o_a0_r     (x0_r),
    .i_a1_v     (x1_v),
    .i_a1_d     (x1_d),
    .o_a1_r     (x1_r),
    .o_z_v      (o_z_v),
    .o_z_d      (o_z_d),
    .i_z_r      (i_z_r),
    .reset_n    (reset_n)
);

`ifdef SIM

`ifdef  CORY_MON
    cory_monitor #(Z) u_monitor_z (
        .clk        (clk),
        .i_v        (o_z_v),
        .i_d        (o_z_d),
        .i_r        (i_z_r),
        .reset_n    (reset_n)
    );
`endif                                          //  CORY_MON

`endif
endmodule


`endif
