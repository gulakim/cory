//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_PACK16
    `define CORY_PACK16

//------------------------------------------------------------------------------
module cory_pack16 #(
    parameter   N   = 8,
    parameter   A0  = N,
    parameter   A1  = N,
    parameter   A2  = N,
    parameter   A3  = N,
    parameter   A4  = N,
    parameter   A5  = N,
    parameter   A6  = N,
    parameter   A7  = N,
    parameter   A8  = N,
    parameter   A9  = N,
    parameter   AA  = N,
    parameter   AB  = N,
    parameter   AC  = N,
    parameter   AD  = N,
    parameter   AE  = N,
    parameter   AF  = N,
    parameter   Z   = A0 + A1 + A2 + A3 + A4 + A5 + A6 + A7 + A8 + A9 + AA + AB + AC + AD + AE + AF
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
    input           i_a4_v,
    input   [A4-1:0]i_a4_d,
    output          o_a4_r,
    input           i_a5_v,
    input   [A5-1:0]i_a5_d,
    output          o_a5_r,
    input           i_a6_v,
    input   [A6-1:0]i_a6_d,
    output          o_a6_r,
    input           i_a7_v,
    input   [A7-1:0]i_a7_d,
    output          o_a7_r,
    input           i_a8_v,
    input   [A8-1:0]i_a8_d,
    output          o_a8_r,
    input           i_a9_v,
    input   [A9-1:0]i_a9_d,
    output          o_a9_r,
    input           i_aa_v,
    input   [AA-1:0]i_aa_d,
    output          o_aa_r,
    input           i_ab_v,
    input   [AB-1:0]i_ab_d,
    output          o_ab_r,
    input           i_ac_v,
    input   [AC-1:0]i_ac_d,
    output          o_ac_r,
    input           i_ad_v,
    input   [AD-1:0]i_ad_d,
    output          o_ad_r,
    input           i_ae_v,
    input   [AE-1:0]i_ae_d,
    output          o_ae_r,
    input           i_af_v,
    input   [AF-1:0]i_af_d,
    output          o_af_r,

    output          o_z_v,
    output  [Z-1:0] o_z_d,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
localparam  X   = A0 + A1 + A2 + A3 + A4 + A5 + A6 + A7;
localparam  Y   = A8 + A9 + AA + AB + AC + AD + AE + AF;

wire            x0_v;
wire    [X-1:0] x0_d;
wire            x0_r;

wire            x1_v;
wire    [Y-1:0] x1_d;
wire            x1_r;

cory_pack8 #(.A0(A0), .A1(A1), .A2(A2), .A3(A3), .A4(A4), .A5(A5), .A6(A6), .A7(A7)) u_pack_low (
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
    .i_a4_v     (i_a4_v),
    .i_a4_d     (i_a4_d),
    .o_a4_r     (o_a4_r),
    .i_a5_v     (i_a5_v),
    .i_a5_d     (i_a5_d),
    .o_a5_r     (o_a5_r),
    .i_a6_v     (i_a6_v),
    .i_a6_d     (i_a6_d),
    .o_a6_r     (o_a6_r),
    .i_a7_v     (i_a7_v),
    .i_a7_d     (i_a7_d),
    .o_a7_r     (o_a7_r),
    .o_z_v      (x0_v),
    .o_z_d      (x0_d),
    .i_z_r      (x0_r),
    .reset_n    (reset_n)
);

cory_pack8 #(.A0(A8), .A1(A9), .A2(AA), .A3(AB), .A4(AC), .A5(AD), .A6(AE), .A7(AF)) u_pack_high (
    .clk        (clk),
    .i_a0_v     (i_a8_v),
    .i_a0_d     (i_a8_d),
    .o_a0_r     (o_a8_r),
    .i_a1_v     (i_a9_v),
    .i_a1_d     (i_a9_d),
    .o_a1_r     (o_a9_r),
    .i_a2_v     (i_aa_v),
    .i_a2_d     (i_aa_d),
    .o_a2_r     (o_aa_r),
    .i_a3_v     (i_ab_v),
    .i_a3_d     (i_ab_d),
    .o_a3_r     (o_ab_r),
    .i_a4_v     (i_ac_v),
    .i_a4_d     (i_ac_d),
    .o_a4_r     (o_ac_r),
    .i_a5_v     (i_ad_v),
    .i_a5_d     (i_ad_d),
    .o_a5_r     (o_ad_r),
    .i_a6_v     (i_ae_v),
    .i_a6_d     (i_ae_d),
    .o_a6_r     (o_ae_r),
    .i_a7_v     (i_af_v),
    .i_a7_d     (i_af_d),
    .o_a7_r     (o_af_r),
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
