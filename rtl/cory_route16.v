//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_ROUTE16
    `define CORY_ROUTE16

//------------------------------------------------------------------------------
//  route ax ot zx, zx selects one of ax
//------------------------------------------------------------------------------
module cory_route16 # (
    parameter   N       = 8,
    parameter   S       = 4,                    // do not touch
    parameter   Q       = 0,                    // output queue
    parameter   QS      = 0                     // must be static selector when 0
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
    input           i_a8_v,
    input   [N-1:0] i_a8_d,
    output          o_a8_r,
    input           i_a9_v,
    input   [N-1:0] i_a9_d,
    output          o_a9_r,
    input           i_aa_v,
    input   [N-1:0] i_aa_d,
    output          o_aa_r,
    input           i_ab_v,
    input   [N-1:0] i_ab_d,
    output          o_ab_r,
    input           i_ac_v,
    input   [N-1:0] i_ac_d,
    output          o_ac_r,
    input           i_ad_v,
    input   [N-1:0] i_ad_d,
    output          o_ad_r,
    input           i_ae_v,
    input   [N-1:0] i_ae_d,
    output          o_ae_r,
    input           i_af_v,
    input   [N-1:0] i_af_d,
    output          o_af_r,

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
    output          o_z4_v,
    output  [N-1:0] o_z4_d,
    input           i_z4_r,
    output          o_z5_v,
    output  [N-1:0] o_z5_d,
    input           i_z5_r,
    output          o_z6_v,
    output  [N-1:0] o_z6_d,
    input           i_z6_r,
    output          o_z7_v,
    output  [N-1:0] o_z7_d,
    input           i_z7_r,
    output          o_z8_v,
    output  [N-1:0] o_z8_d,
    input           i_z8_r,
    output          o_z9_v,
    output  [N-1:0] o_z9_d,
    input           i_z9_r,
    output          o_za_v,
    output  [N-1:0] o_za_d,
    input           i_za_r,
    output          o_zb_v,
    output  [N-1:0] o_zb_d,
    input           i_zb_r,
    output          o_zc_v,
    output  [N-1:0] o_zc_d,
    input           i_zc_r,
    output          o_zd_v,
    output  [N-1:0] o_zd_d,
    input           i_zd_r,
    output          o_ze_v,
    output  [N-1:0] o_ze_d,
    input           i_ze_r,
    output          o_zf_v,
    output  [N-1:0] o_zf_d,
    input           i_zf_r,

    input   [S-1:0] i_z0_s,
    input   [S-1:0] i_z1_s,
    input   [S-1:0] i_z2_s,
    input   [S-1:0] i_z3_s,
    input   [S-1:0] i_z4_s,
    input   [S-1:0] i_z5_s,
    input   [S-1:0] i_z6_s,
    input   [S-1:0] i_z7_s,
    input   [S-1:0] i_z8_s,
    input   [S-1:0] i_z9_s,
    input   [S-1:0] i_za_s,
    input   [S-1:0] i_zb_s,
    input   [S-1:0] i_zc_s,
    input   [S-1:0] i_zd_s,
    input   [S-1:0] i_ze_s,
    input   [S-1:0] i_zf_s,

    input           reset_n
);

//------------------------------------------------------------------------------
localparam  RATIO   = 2**S;

wire    [S-1:0] z0_s;
wire    [S-1:0] z1_s;
wire    [S-1:0] z2_s;
wire    [S-1:0] z3_s;
wire    [S-1:0] z4_s;
wire    [S-1:0] z5_s;
wire    [S-1:0] z6_s;
wire    [S-1:0] z7_s;
wire    [S-1:0] z8_s;
wire    [S-1:0] z9_s;
wire    [S-1:0] za_s;
wire    [S-1:0] zb_s;
wire    [S-1:0] zc_s;
wire    [S-1:0] zd_s;
wire    [S-1:0] ze_s;
wire    [S-1:0] zf_s;

generate
begin : g_static
    case (QS)
    1: begin
        wire    no_valid    =
                    (!i_a0_v) & (!i_a1_v) & (!i_a2_v) & (!i_a3_v) & (!i_a4_v) & (!i_a5_v) & (!i_a6_v) & (!i_a7_v) &
                    (!i_a8_v) & (!i_a9_v) & (!i_aa_v) & (!i_ab_v) & (!i_ac_v) & (!i_ad_v) & (!i_ae_v) & (!i_af_v) &
                    (!o_z0_v) & (!o_z1_v) & (!o_z2_v) & (!o_z3_v) & (!o_z4_v) & (!o_z5_v) & (!o_z6_v) & (!o_z7_v) &
                    (!o_z8_v) & (!o_z9_v) & (!o_za_v) & (!o_zb_v) & (!o_zc_v) & (!o_zd_v) & (!o_ze_v) & (!o_zf_v);

        reg     [S-1:0] z0_s_reg;
        reg     [S-1:0] z1_s_reg;
        reg     [S-1:0] z2_s_reg;
        reg     [S-1:0] z3_s_reg;
        reg     [S-1:0] z4_s_reg;
        reg     [S-1:0] z5_s_reg;
        reg     [S-1:0] z6_s_reg;
        reg     [S-1:0] z7_s_reg;
        reg     [S-1:0] z8_s_reg;
        reg     [S-1:0] z9_s_reg;
        reg     [S-1:0] za_s_reg;
        reg     [S-1:0] zb_s_reg;
        reg     [S-1:0] zc_s_reg;
        reg     [S-1:0] zd_s_reg;
        reg     [S-1:0] ze_s_reg;
        reg     [S-1:0] zf_s_reg;

        always @(posedge clk or negedge reset_n)
            if (!reset_n) begin
                z0_s_reg    <= 0;
                z1_s_reg    <= 0;
                z2_s_reg    <= 0;
                z3_s_reg    <= 0;
                z4_s_reg    <= 0;
                z5_s_reg    <= 0;
                z6_s_reg    <= 0;
                z7_s_reg    <= 0;
                z8_s_reg    <= 0;
                z9_s_reg    <= 0;
                za_s_reg    <= 0;
                zb_s_reg    <= 0;
                zc_s_reg    <= 0;
                zd_s_reg    <= 0;
                ze_s_reg    <= 0;
                zf_s_reg    <= 0;
            end
            else if (no_valid) begin
                z0_s_reg    <= i_z0_s;
                z1_s_reg    <= i_z1_s;
                z2_s_reg    <= i_z2_s;
                z3_s_reg    <= i_z3_s;
                z4_s_reg    <= i_z4_s;
                z5_s_reg    <= i_z5_s;
                z6_s_reg    <= i_z6_s;
                z7_s_reg    <= i_z7_s;
                z8_s_reg    <= i_z8_s;
                z9_s_reg    <= i_z9_s;
                za_s_reg    <= i_za_s;
                zb_s_reg    <= i_zb_s;
                zc_s_reg    <= i_zc_s;
                zd_s_reg    <= i_zd_s;
                ze_s_reg    <= i_ze_s;
                zf_s_reg    <= i_zf_s;
            end

        assign  z0_s    = z0_s_reg;
        assign  z1_s    = z1_s_reg;
        assign  z2_s    = z2_s_reg;
        assign  z3_s    = z3_s_reg;
        assign  z4_s    = z4_s_reg;
        assign  z5_s    = z5_s_reg;
        assign  z6_s    = z6_s_reg;
        assign  z7_s    = z7_s_reg;
        assign  z8_s    = z8_s_reg;
        assign  z9_s    = z9_s_reg;
        assign  za_s    = za_s_reg;
        assign  zb_s    = zb_s_reg;
        assign  zc_s    = zc_s_reg;
        assign  zd_s    = zd_s_reg;
        assign  ze_s    = ze_s_reg;
        assign  zf_s    = zf_s_reg;
    end
    default: begin
        assign  z0_s    = i_z0_s;
        assign  z1_s    = i_z1_s;
        assign  z2_s    = i_z2_s;
        assign  z3_s    = i_z3_s;
        assign  z4_s    = i_z4_s;
        assign  z5_s    = i_z5_s;
        assign  z6_s    = i_z6_s;
        assign  z7_s    = i_z7_s;
        assign  z8_s    = i_z8_s;
        assign  z9_s    = i_z9_s;
        assign  za_s    = i_za_s;
        assign  zb_s    = i_zb_s;
        assign  zc_s    = i_zc_s;
        assign  zd_s    = i_zd_s;
        assign  ze_s    = i_ze_s;
        assign  zf_s    = i_zf_s;
    end
    endcase
end
endgenerate

wire    [S-1:0] a0_s    = z0_s == 0 ? 0 : z1_s == 0 ? 1 : z2_s == 0 ? 2 : z3_s == 0 ? 3 : z4_s == 0 ? 4 : z5_s == 0 ? 5 : z6_s == 0 ? 6 : z7_s == 0 ? 7 :
                          z8_s == 0 ? 8 : z9_s == 0 ? 9 : za_s == 0 ? 10: zb_s == 0 ? 11: zc_s == 0 ? 12: zd_s == 0 ? 13: ze_s == 0 ? 14: zf_s == 0 ? 15: {S{1'bx}};
wire    [S-1:0] a1_s    = z0_s == 1 ? 0 : z1_s == 1 ? 1 : z2_s == 1 ? 2 : z3_s == 1 ? 3 : z4_s == 1 ? 4 : z5_s == 1 ? 5 : z6_s == 1 ? 6 : z7_s == 1 ? 7 :
                          z8_s == 1 ? 8 : z9_s == 1 ? 9 : za_s == 1 ? 10: zb_s == 1 ? 11: zc_s == 1 ? 12: zd_s == 1 ? 13: ze_s == 1 ? 14: zf_s == 1 ? 15: {S{1'bx}};
wire    [S-1:0] a2_s    = z0_s == 2 ? 0 : z1_s == 2 ? 1 : z2_s == 2 ? 2 : z3_s == 2 ? 3 : z4_s == 2 ? 4 : z5_s == 2 ? 5 : z6_s == 2 ? 6 : z7_s == 2 ? 7 :
                          z8_s == 2 ? 8 : z9_s == 2 ? 9 : za_s == 2 ? 10: zb_s == 2 ? 11: zc_s == 2 ? 12: zd_s == 2 ? 13: ze_s == 2 ? 14: zf_s == 2 ? 15: {S{1'bx}};
wire    [S-1:0] a3_s    = z0_s == 3 ? 0 : z1_s == 3 ? 1 : z2_s == 3 ? 2 : z3_s == 3 ? 3 : z4_s == 3 ? 4 : z5_s == 3 ? 5 : z6_s == 3 ? 6 : z7_s == 3 ? 7 :
                          z8_s == 3 ? 8 : z9_s == 3 ? 9 : za_s == 3 ? 10: zb_s == 3 ? 11: zc_s == 3 ? 12: zd_s == 3 ? 13: ze_s == 3 ? 14: zf_s == 3 ? 15: {S{1'bx}};
wire    [S-1:0] a4_s    = z0_s == 4 ? 0 : z1_s == 4 ? 1 : z2_s == 4 ? 2 : z3_s == 4 ? 3 : z4_s == 4 ? 4 : z5_s == 4 ? 5 : z6_s == 4 ? 6 : z7_s == 4 ? 7 :
                          z8_s == 4 ? 8 : z9_s == 4 ? 9 : za_s == 4 ? 10: zb_s == 4 ? 11: zc_s == 4 ? 12: zd_s == 4 ? 13: ze_s == 4 ? 14: zf_s == 4 ? 15: {S{1'bx}};
wire    [S-1:0] a5_s    = z0_s == 5 ? 0 : z1_s == 5 ? 1 : z2_s == 5 ? 2 : z3_s == 5 ? 3 : z4_s == 5 ? 4 : z5_s == 5 ? 5 : z6_s == 5 ? 6 : z7_s == 5 ? 7 :
                          z8_s == 5 ? 8 : z9_s == 5 ? 9 : za_s == 5 ? 10: zb_s == 5 ? 11: zc_s == 5 ? 12: zd_s == 5 ? 13: ze_s == 5 ? 14: zf_s == 5 ? 15: {S{1'bx}};
wire    [S-1:0] a6_s    = z0_s == 6 ? 0 : z1_s == 6 ? 1 : z2_s == 6 ? 2 : z3_s == 6 ? 3 : z4_s == 6 ? 4 : z5_s == 6 ? 5 : z6_s == 6 ? 6 : z7_s == 6 ? 7 :
                          z8_s == 6 ? 8 : z9_s == 6 ? 9 : za_s == 6 ? 10: zb_s == 6 ? 11: zc_s == 6 ? 12: zd_s == 6 ? 13: ze_s == 6 ? 14: zf_s == 6 ? 15: {S{1'bx}};
wire    [S-1:0] a7_s    = z0_s == 7 ? 0 : z1_s == 7 ? 1 : z2_s == 7 ? 2 : z3_s == 7 ? 3 : z4_s == 7 ? 4 : z5_s == 7 ? 5 : z6_s == 7 ? 6 : z7_s == 7 ? 7 :
                          z8_s == 7 ? 8 : z9_s == 7 ? 9 : za_s == 7 ? 10: zb_s == 7 ? 11: zc_s == 7 ? 12: zd_s == 7 ? 13: ze_s == 7 ? 14: zf_s == 7 ? 15: {S{1'bx}};
wire    [S-1:0] a8_s    = z0_s == 8 ? 0 : z1_s == 8 ? 1 : z2_s == 8 ? 2 : z3_s == 8 ? 3 : z4_s == 8 ? 4 : z5_s == 8 ? 5 : z6_s == 8 ? 6 : z7_s == 8 ? 7 :
                          z8_s == 8 ? 8 : z9_s == 8 ? 9 : za_s == 8 ? 10: zb_s == 8 ? 11: zc_s == 8 ? 12: zd_s == 8 ? 13: ze_s == 8 ? 14: zf_s == 8 ? 15: {S{1'bx}};
wire    [S-1:0] a9_s    = z0_s == 9 ? 0 : z1_s == 9 ? 1 : z2_s == 9 ? 2 : z3_s == 9 ? 3 : z4_s == 9 ? 4 : z5_s == 9 ? 5 : z6_s == 9 ? 6 : z7_s == 9 ? 7 :
                          z8_s == 9 ? 8 : z9_s == 9 ? 9 : za_s == 9 ? 10: zb_s == 9 ? 11: zc_s == 9 ? 12: zd_s == 9 ? 13: ze_s == 9 ? 14: zf_s == 9 ? 15: {S{1'bx}};
wire    [S-1:0] aa_s    = z0_s == 10? 0 : z1_s == 10? 1 : z2_s == 10? 2 : z3_s == 10? 3 : z4_s == 10? 4 : z5_s == 10? 5 : z6_s == 10? 6 : z7_s == 10? 7 :
                          z8_s == 10? 8 : z9_s == 10? 9 : za_s == 10? 10: zb_s == 10? 11: zc_s == 10? 12: zd_s == 10? 13: ze_s == 10? 14: zf_s == 10? 15: {S{1'bx}};
wire    [S-1:0] ab_s    = z0_s == 11? 0 : z1_s == 11? 1 : z2_s == 11? 2 : z3_s == 11? 3 : z4_s == 11? 4 : z5_s == 11? 5 : z6_s == 11? 6 : z7_s == 11? 7 :
                          z8_s == 11? 8 : z9_s == 11? 9 : za_s == 11? 10: zb_s == 11? 11: zc_s == 11? 12: zd_s == 11? 13: ze_s == 11? 14: zf_s == 11? 15: {S{1'bx}};
wire    [S-1:0] ac_s    = z0_s == 12? 0 : z1_s == 12? 1 : z2_s == 12? 2 : z3_s == 12? 3 : z4_s == 12? 4 : z5_s == 12? 5 : z6_s == 12? 6 : z7_s == 12? 7 :
                          z8_s == 12? 8 : z9_s == 12? 9 : za_s == 12? 10: zb_s == 12? 11: zc_s == 12? 12: zd_s == 12? 13: ze_s == 12? 14: zf_s == 12? 15: {S{1'bx}};
wire    [S-1:0] ad_s    = z0_s == 13? 0 : z1_s == 13? 1 : z2_s == 13? 2 : z3_s == 13? 3 : z4_s == 13? 4 : z5_s == 13? 5 : z6_s == 13? 6 : z7_s == 13? 7 :
                          z8_s == 13? 8 : z9_s == 13? 9 : za_s == 13? 10: zb_s == 13? 11: zc_s == 13? 12: zd_s == 13? 13: ze_s == 13? 14: zf_s == 13? 15: {S{1'bx}};
wire    [S-1:0] ae_s    = z0_s == 14? 0 : z1_s == 14? 1 : z2_s == 14? 2 : z3_s == 14? 3 : z4_s == 14? 4 : z5_s == 14? 5 : z6_s == 14? 6 : z7_s == 14? 7 :
                          z8_s == 14? 8 : z9_s == 14? 9 : za_s == 14? 10: zb_s == 14? 11: zc_s == 14? 12: zd_s == 14? 13: ze_s == 14? 14: zf_s == 14? 15: {S{1'bx}};
wire    [S-1:0] af_s    = z0_s == 15? 0 : z1_s == 15? 1 : z2_s == 15? 2 : z3_s == 15? 3 : z4_s == 15? 4 : z5_s == 15? 5 : z6_s == 15? 6 : z7_s == 15? 7 :
                          z8_s == 15? 8 : z9_s == 15? 9 : za_s == 15? 10: zb_s == 15? 11: zc_s == 15? 12: zd_s == 15? 13: ze_s == 15? 14: zf_s == 15? 15: {S{1'bx}};

//------------------------------------------------------------------------------
wire            x_a0_v[0:RATIO-1];
wire    [N-1:0] x_a0_d[0:RATIO-1];
wire            x_a0_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_a0 (
    .clk            (clk),
    .i_a_v          (i_a0_v),
    .i_a_d          (i_a0_d),
    .o_a_r          (o_a0_r),
    .i_s_v          (1'b1),
    .i_s_d          (a0_s),
    .o_s_r          (),
    .o_z0_v         (x_a0_v[0]),
    .o_z0_d         (x_a0_d[0]),
    .i_z0_r         (x_a0_r[0]),
    .o_z1_v         (x_a0_v[1]),
    .o_z1_d         (x_a0_d[1]),
    .i_z1_r         (x_a0_r[1]),
    .o_z2_v         (x_a0_v[2]),
    .o_z2_d         (x_a0_d[2]),
    .i_z2_r         (x_a0_r[2]),
    .o_z3_v         (x_a0_v[3]),
    .o_z3_d         (x_a0_d[3]),
    .i_z3_r         (x_a0_r[3]),
    .o_z4_v         (x_a0_v[4]),
    .o_z4_d         (x_a0_d[4]),
    .i_z4_r         (x_a0_r[4]),
    .o_z5_v         (x_a0_v[5]),
    .o_z5_d         (x_a0_d[5]),
    .i_z5_r         (x_a0_r[5]),
    .o_z6_v         (x_a0_v[6]),
    .o_z6_d         (x_a0_d[6]),
    .i_z6_r         (x_a0_r[6]),
    .o_z7_v         (x_a0_v[7]),
    .o_z7_d         (x_a0_d[7]),
    .i_z7_r         (x_a0_r[7]),
    .o_z8_v         (x_a0_v[8]),
    .o_z8_d         (x_a0_d[8]),
    .i_z8_r         (x_a0_r[8]),
    .o_z9_v         (x_a0_v[9]),
    .o_z9_d         (x_a0_d[9]),
    .i_z9_r         (x_a0_r[9]),
    .o_za_v         (x_a0_v[10]),
    .o_za_d         (x_a0_d[10]),
    .i_za_r         (x_a0_r[10]),
    .o_zb_v         (x_a0_v[11]),
    .o_zb_d         (x_a0_d[11]),
    .i_zb_r         (x_a0_r[11]),
    .o_zc_v         (x_a0_v[12]),
    .o_zc_d         (x_a0_d[12]),
    .i_zc_r         (x_a0_r[12]),
    .o_zd_v         (x_a0_v[13]),
    .o_zd_d         (x_a0_d[13]),
    .i_zd_r         (x_a0_r[13]),
    .o_ze_v         (x_a0_v[14]),
    .o_ze_d         (x_a0_d[14]),
    .i_ze_r         (x_a0_r[14]),
    .o_zf_v         (x_a0_v[15]),
    .o_zf_d         (x_a0_d[15]),
    .i_zf_r         (x_a0_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a1_v[0:RATIO-1];
wire    [N-1:0] x_a1_d[0:RATIO-1];
wire            x_a1_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_a1 (
    .clk            (clk),
    .i_a_v          (i_a1_v),
    .i_a_d          (i_a1_d),
    .o_a_r          (o_a1_r),
    .i_s_v          (1'b1),
    .i_s_d          (a1_s),
    .o_s_r          (),
    .o_z0_v         (x_a1_v[0]),
    .o_z0_d         (x_a1_d[0]),
    .i_z0_r         (x_a1_r[0]),
    .o_z1_v         (x_a1_v[1]),
    .o_z1_d         (x_a1_d[1]),
    .i_z1_r         (x_a1_r[1]),
    .o_z2_v         (x_a1_v[2]),
    .o_z2_d         (x_a1_d[2]),
    .i_z2_r         (x_a1_r[2]),
    .o_z3_v         (x_a1_v[3]),
    .o_z3_d         (x_a1_d[3]),
    .i_z3_r         (x_a1_r[3]),
    .o_z4_v         (x_a1_v[4]),
    .o_z4_d         (x_a1_d[4]),
    .i_z4_r         (x_a1_r[4]),
    .o_z5_v         (x_a1_v[5]),
    .o_z5_d         (x_a1_d[5]),
    .i_z5_r         (x_a1_r[5]),
    .o_z6_v         (x_a1_v[6]),
    .o_z6_d         (x_a1_d[6]),
    .i_z6_r         (x_a1_r[6]),
    .o_z7_v         (x_a1_v[7]),
    .o_z7_d         (x_a1_d[7]),
    .i_z7_r         (x_a1_r[7]),
    .o_z8_v         (x_a1_v[8]),
    .o_z8_d         (x_a1_d[8]),
    .i_z8_r         (x_a1_r[8]),
    .o_z9_v         (x_a1_v[9]),
    .o_z9_d         (x_a1_d[9]),
    .i_z9_r         (x_a1_r[9]),
    .o_za_v         (x_a1_v[10]),
    .o_za_d         (x_a1_d[10]),
    .i_za_r         (x_a1_r[10]),
    .o_zb_v         (x_a1_v[11]),
    .o_zb_d         (x_a1_d[11]),
    .i_zb_r         (x_a1_r[11]),
    .o_zc_v         (x_a1_v[12]),
    .o_zc_d         (x_a1_d[12]),
    .i_zc_r         (x_a1_r[12]),
    .o_zd_v         (x_a1_v[13]),
    .o_zd_d         (x_a1_d[13]),
    .i_zd_r         (x_a1_r[13]),
    .o_ze_v         (x_a1_v[14]),
    .o_ze_d         (x_a1_d[14]),
    .i_ze_r         (x_a1_r[14]),
    .o_zf_v         (x_a1_v[15]),
    .o_zf_d         (x_a1_d[15]),
    .i_zf_r         (x_a1_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a2_v[0:RATIO-1];
wire    [N-1:0] x_a2_d[0:RATIO-1];
wire            x_a2_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_a2 (
    .clk            (clk),
    .i_a_v          (i_a2_v),
    .i_a_d          (i_a2_d),
    .o_a_r          (o_a2_r),
    .i_s_v          (1'b1),
    .i_s_d          (a2_s),
    .o_s_r          (),
    .o_z0_v         (x_a2_v[0]),
    .o_z0_d         (x_a2_d[0]),
    .i_z0_r         (x_a2_r[0]),
    .o_z1_v         (x_a2_v[1]),
    .o_z1_d         (x_a2_d[1]),
    .i_z1_r         (x_a2_r[1]),
    .o_z2_v         (x_a2_v[2]),
    .o_z2_d         (x_a2_d[2]),
    .i_z2_r         (x_a2_r[2]),
    .o_z3_v         (x_a2_v[3]),
    .o_z3_d         (x_a2_d[3]),
    .i_z3_r         (x_a2_r[3]),
    .o_z4_v         (x_a2_v[4]),
    .o_z4_d         (x_a2_d[4]),
    .i_z4_r         (x_a2_r[4]),
    .o_z5_v         (x_a2_v[5]),
    .o_z5_d         (x_a2_d[5]),
    .i_z5_r         (x_a2_r[5]),
    .o_z6_v         (x_a2_v[6]),
    .o_z6_d         (x_a2_d[6]),
    .i_z6_r         (x_a2_r[6]),
    .o_z7_v         (x_a2_v[7]),
    .o_z7_d         (x_a2_d[7]),
    .i_z7_r         (x_a2_r[7]),
    .o_z8_v         (x_a2_v[8]),
    .o_z8_d         (x_a2_d[8]),
    .i_z8_r         (x_a2_r[8]),
    .o_z9_v         (x_a2_v[9]),
    .o_z9_d         (x_a2_d[9]),
    .i_z9_r         (x_a2_r[9]),
    .o_za_v         (x_a2_v[10]),
    .o_za_d         (x_a2_d[10]),
    .i_za_r         (x_a2_r[10]),
    .o_zb_v         (x_a2_v[11]),
    .o_zb_d         (x_a2_d[11]),
    .i_zb_r         (x_a2_r[11]),
    .o_zc_v         (x_a2_v[12]),
    .o_zc_d         (x_a2_d[12]),
    .i_zc_r         (x_a2_r[12]),
    .o_zd_v         (x_a2_v[13]),
    .o_zd_d         (x_a2_d[13]),
    .i_zd_r         (x_a2_r[13]),
    .o_ze_v         (x_a2_v[14]),
    .o_ze_d         (x_a2_d[14]),
    .i_ze_r         (x_a2_r[14]),
    .o_zf_v         (x_a2_v[15]),
    .o_zf_d         (x_a2_d[15]),
    .i_zf_r         (x_a2_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a3_v[0:RATIO-1];
wire    [N-1:0] x_a3_d[0:RATIO-1];
wire            x_a3_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_a3 (
    .clk            (clk),
    .i_a_v          (i_a3_v),
    .i_a_d          (i_a3_d),
    .o_a_r          (o_a3_r),
    .i_s_v          (1'b1),
    .i_s_d          (a3_s),
    .o_s_r          (),
    .o_z0_v         (x_a3_v[0]),
    .o_z0_d         (x_a3_d[0]),
    .i_z0_r         (x_a3_r[0]),
    .o_z1_v         (x_a3_v[1]),
    .o_z1_d         (x_a3_d[1]),
    .i_z1_r         (x_a3_r[1]),
    .o_z2_v         (x_a3_v[2]),
    .o_z2_d         (x_a3_d[2]),
    .i_z2_r         (x_a3_r[2]),
    .o_z3_v         (x_a3_v[3]),
    .o_z3_d         (x_a3_d[3]),
    .i_z3_r         (x_a3_r[3]),
    .o_z4_v         (x_a3_v[4]),
    .o_z4_d         (x_a3_d[4]),
    .i_z4_r         (x_a3_r[4]),
    .o_z5_v         (x_a3_v[5]),
    .o_z5_d         (x_a3_d[5]),
    .i_z5_r         (x_a3_r[5]),
    .o_z6_v         (x_a3_v[6]),
    .o_z6_d         (x_a3_d[6]),
    .i_z6_r         (x_a3_r[6]),
    .o_z7_v         (x_a3_v[7]),
    .o_z7_d         (x_a3_d[7]),
    .i_z7_r         (x_a3_r[7]),
    .o_z8_v         (x_a3_v[8]),
    .o_z8_d         (x_a3_d[8]),
    .i_z8_r         (x_a3_r[8]),
    .o_z9_v         (x_a3_v[9]),
    .o_z9_d         (x_a3_d[9]),
    .i_z9_r         (x_a3_r[9]),
    .o_za_v         (x_a3_v[10]),
    .o_za_d         (x_a3_d[10]),
    .i_za_r         (x_a3_r[10]),
    .o_zb_v         (x_a3_v[11]),
    .o_zb_d         (x_a3_d[11]),
    .i_zb_r         (x_a3_r[11]),
    .o_zc_v         (x_a3_v[12]),
    .o_zc_d         (x_a3_d[12]),
    .i_zc_r         (x_a3_r[12]),
    .o_zd_v         (x_a3_v[13]),
    .o_zd_d         (x_a3_d[13]),
    .i_zd_r         (x_a3_r[13]),
    .o_ze_v         (x_a3_v[14]),
    .o_ze_d         (x_a3_d[14]),
    .i_ze_r         (x_a3_r[14]),
    .o_zf_v         (x_a3_v[15]),
    .o_zf_d         (x_a3_d[15]),
    .i_zf_r         (x_a3_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a4_v[0:RATIO-1];
wire    [N-1:0] x_a4_d[0:RATIO-1];
wire            x_a4_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_a4 (
    .clk            (clk),
    .i_a_v          (i_a4_v),
    .i_a_d          (i_a4_d),
    .o_a_r          (o_a4_r),
    .i_s_v          (1'b1),
    .i_s_d          (a4_s),
    .o_s_r          (),
    .o_z0_v         (x_a4_v[0]),
    .o_z0_d         (x_a4_d[0]),
    .i_z0_r         (x_a4_r[0]),
    .o_z1_v         (x_a4_v[1]),
    .o_z1_d         (x_a4_d[1]),
    .i_z1_r         (x_a4_r[1]),
    .o_z2_v         (x_a4_v[2]),
    .o_z2_d         (x_a4_d[2]),
    .i_z2_r         (x_a4_r[2]),
    .o_z3_v         (x_a4_v[3]),
    .o_z3_d         (x_a4_d[3]),
    .i_z3_r         (x_a4_r[3]),
    .o_z4_v         (x_a4_v[4]),
    .o_z4_d         (x_a4_d[4]),
    .i_z4_r         (x_a4_r[4]),
    .o_z5_v         (x_a4_v[5]),
    .o_z5_d         (x_a4_d[5]),
    .i_z5_r         (x_a4_r[5]),
    .o_z6_v         (x_a4_v[6]),
    .o_z6_d         (x_a4_d[6]),
    .i_z6_r         (x_a4_r[6]),
    .o_z7_v         (x_a4_v[7]),
    .o_z7_d         (x_a4_d[7]),
    .i_z7_r         (x_a4_r[7]),
    .o_z8_v         (x_a4_v[8]),
    .o_z8_d         (x_a4_d[8]),
    .i_z8_r         (x_a4_r[8]),
    .o_z9_v         (x_a4_v[9]),
    .o_z9_d         (x_a4_d[9]),
    .i_z9_r         (x_a4_r[9]),
    .o_za_v         (x_a4_v[10]),
    .o_za_d         (x_a4_d[10]),
    .i_za_r         (x_a4_r[10]),
    .o_zb_v         (x_a4_v[11]),
    .o_zb_d         (x_a4_d[11]),
    .i_zb_r         (x_a4_r[11]),
    .o_zc_v         (x_a4_v[12]),
    .o_zc_d         (x_a4_d[12]),
    .i_zc_r         (x_a4_r[12]),
    .o_zd_v         (x_a4_v[13]),
    .o_zd_d         (x_a4_d[13]),
    .i_zd_r         (x_a4_r[13]),
    .o_ze_v         (x_a4_v[14]),
    .o_ze_d         (x_a4_d[14]),
    .i_ze_r         (x_a4_r[14]),
    .o_zf_v         (x_a4_v[15]),
    .o_zf_d         (x_a4_d[15]),
    .i_zf_r         (x_a4_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a5_v[0:RATIO-1];
wire    [N-1:0] x_a5_d[0:RATIO-1];
wire            x_a5_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_a5 (
    .clk            (clk),
    .i_a_v          (i_a5_v),
    .i_a_d          (i_a5_d),
    .o_a_r          (o_a5_r),
    .i_s_v          (1'b1),
    .i_s_d          (a5_s),
    .o_s_r          (),
    .o_z0_v         (x_a5_v[0]),
    .o_z0_d         (x_a5_d[0]),
    .i_z0_r         (x_a5_r[0]),
    .o_z1_v         (x_a5_v[1]),
    .o_z1_d         (x_a5_d[1]),
    .i_z1_r         (x_a5_r[1]),
    .o_z2_v         (x_a5_v[2]),
    .o_z2_d         (x_a5_d[2]),
    .i_z2_r         (x_a5_r[2]),
    .o_z3_v         (x_a5_v[3]),
    .o_z3_d         (x_a5_d[3]),
    .i_z3_r         (x_a5_r[3]),
    .o_z4_v         (x_a5_v[4]),
    .o_z4_d         (x_a5_d[4]),
    .i_z4_r         (x_a5_r[4]),
    .o_z5_v         (x_a5_v[5]),
    .o_z5_d         (x_a5_d[5]),
    .i_z5_r         (x_a5_r[5]),
    .o_z6_v         (x_a5_v[6]),
    .o_z6_d         (x_a5_d[6]),
    .i_z6_r         (x_a5_r[6]),
    .o_z7_v         (x_a5_v[7]),
    .o_z7_d         (x_a5_d[7]),
    .i_z7_r         (x_a5_r[7]),
    .o_z8_v         (x_a5_v[8]),
    .o_z8_d         (x_a5_d[8]),
    .i_z8_r         (x_a5_r[8]),
    .o_z9_v         (x_a5_v[9]),
    .o_z9_d         (x_a5_d[9]),
    .i_z9_r         (x_a5_r[9]),
    .o_za_v         (x_a5_v[10]),
    .o_za_d         (x_a5_d[10]),
    .i_za_r         (x_a5_r[10]),
    .o_zb_v         (x_a5_v[11]),
    .o_zb_d         (x_a5_d[11]),
    .i_zb_r         (x_a5_r[11]),
    .o_zc_v         (x_a5_v[12]),
    .o_zc_d         (x_a5_d[12]),
    .i_zc_r         (x_a5_r[12]),
    .o_zd_v         (x_a5_v[13]),
    .o_zd_d         (x_a5_d[13]),
    .i_zd_r         (x_a5_r[13]),
    .o_ze_v         (x_a5_v[14]),
    .o_ze_d         (x_a5_d[14]),
    .i_ze_r         (x_a5_r[14]),
    .o_zf_v         (x_a5_v[15]),
    .o_zf_d         (x_a5_d[15]),
    .i_zf_r         (x_a5_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a6_v[0:RATIO-1];
wire    [N-1:0] x_a6_d[0:RATIO-1];
wire            x_a6_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_a6 (
    .clk            (clk),
    .i_a_v          (i_a6_v),
    .i_a_d          (i_a6_d),
    .o_a_r          (o_a6_r),
    .i_s_v          (1'b1),
    .i_s_d          (a6_s),
    .o_s_r          (),
    .o_z0_v         (x_a6_v[0]),
    .o_z0_d         (x_a6_d[0]),
    .i_z0_r         (x_a6_r[0]),
    .o_z1_v         (x_a6_v[1]),
    .o_z1_d         (x_a6_d[1]),
    .i_z1_r         (x_a6_r[1]),
    .o_z2_v         (x_a6_v[2]),
    .o_z2_d         (x_a6_d[2]),
    .i_z2_r         (x_a6_r[2]),
    .o_z3_v         (x_a6_v[3]),
    .o_z3_d         (x_a6_d[3]),
    .i_z3_r         (x_a6_r[3]),
    .o_z4_v         (x_a6_v[4]),
    .o_z4_d         (x_a6_d[4]),
    .i_z4_r         (x_a6_r[4]),
    .o_z5_v         (x_a6_v[5]),
    .o_z5_d         (x_a6_d[5]),
    .i_z5_r         (x_a6_r[5]),
    .o_z6_v         (x_a6_v[6]),
    .o_z6_d         (x_a6_d[6]),
    .i_z6_r         (x_a6_r[6]),
    .o_z7_v         (x_a6_v[7]),
    .o_z7_d         (x_a6_d[7]),
    .i_z7_r         (x_a6_r[7]),
    .o_z8_v         (x_a6_v[8]),
    .o_z8_d         (x_a6_d[8]),
    .i_z8_r         (x_a6_r[8]),
    .o_z9_v         (x_a6_v[9]),
    .o_z9_d         (x_a6_d[9]),
    .i_z9_r         (x_a6_r[9]),
    .o_za_v         (x_a6_v[10]),
    .o_za_d         (x_a6_d[10]),
    .i_za_r         (x_a6_r[10]),
    .o_zb_v         (x_a6_v[11]),
    .o_zb_d         (x_a6_d[11]),
    .i_zb_r         (x_a6_r[11]),
    .o_zc_v         (x_a6_v[12]),
    .o_zc_d         (x_a6_d[12]),
    .i_zc_r         (x_a6_r[12]),
    .o_zd_v         (x_a6_v[13]),
    .o_zd_d         (x_a6_d[13]),
    .i_zd_r         (x_a6_r[13]),
    .o_ze_v         (x_a6_v[14]),
    .o_ze_d         (x_a6_d[14]),
    .i_ze_r         (x_a6_r[14]),
    .o_zf_v         (x_a6_v[15]),
    .o_zf_d         (x_a6_d[15]),
    .i_zf_r         (x_a6_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a7_v[0:RATIO-1];
wire    [N-1:0] x_a7_d[0:RATIO-1];
wire            x_a7_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_a7 (
    .clk            (clk),
    .i_a_v          (i_a7_v),
    .i_a_d          (i_a7_d),
    .o_a_r          (o_a7_r),
    .i_s_v          (1'b1),
    .i_s_d          (a7_s),
    .o_s_r          (),
    .o_z0_v         (x_a7_v[0]),
    .o_z0_d         (x_a7_d[0]),
    .i_z0_r         (x_a7_r[0]),
    .o_z1_v         (x_a7_v[1]),
    .o_z1_d         (x_a7_d[1]),
    .i_z1_r         (x_a7_r[1]),
    .o_z2_v         (x_a7_v[2]),
    .o_z2_d         (x_a7_d[2]),
    .i_z2_r         (x_a7_r[2]),
    .o_z3_v         (x_a7_v[3]),
    .o_z3_d         (x_a7_d[3]),
    .i_z3_r         (x_a7_r[3]),
    .o_z4_v         (x_a7_v[4]),
    .o_z4_d         (x_a7_d[4]),
    .i_z4_r         (x_a7_r[4]),
    .o_z5_v         (x_a7_v[5]),
    .o_z5_d         (x_a7_d[5]),
    .i_z5_r         (x_a7_r[5]),
    .o_z6_v         (x_a7_v[6]),
    .o_z6_d         (x_a7_d[6]),
    .i_z6_r         (x_a7_r[6]),
    .o_z7_v         (x_a7_v[7]),
    .o_z7_d         (x_a7_d[7]),
    .i_z7_r         (x_a7_r[7]),
    .o_z8_v         (x_a7_v[8]),
    .o_z8_d         (x_a7_d[8]),
    .i_z8_r         (x_a7_r[8]),
    .o_z9_v         (x_a7_v[9]),
    .o_z9_d         (x_a7_d[9]),
    .i_z9_r         (x_a7_r[9]),
    .o_za_v         (x_a7_v[10]),
    .o_za_d         (x_a7_d[10]),
    .i_za_r         (x_a7_r[10]),
    .o_zb_v         (x_a7_v[11]),
    .o_zb_d         (x_a7_d[11]),
    .i_zb_r         (x_a7_r[11]),
    .o_zc_v         (x_a7_v[12]),
    .o_zc_d         (x_a7_d[12]),
    .i_zc_r         (x_a7_r[12]),
    .o_zd_v         (x_a7_v[13]),
    .o_zd_d         (x_a7_d[13]),
    .i_zd_r         (x_a7_r[13]),
    .o_ze_v         (x_a7_v[14]),
    .o_ze_d         (x_a7_d[14]),
    .i_ze_r         (x_a7_r[14]),
    .o_zf_v         (x_a7_v[15]),
    .o_zf_d         (x_a7_d[15]),
    .i_zf_r         (x_a7_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a8_v[0:RATIO-1];
wire    [N-1:0] x_a8_d[0:RATIO-1];
wire            x_a8_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_a8 (
    .clk            (clk),
    .i_a_v          (i_a8_v),
    .i_a_d          (i_a8_d),
    .o_a_r          (o_a8_r),
    .i_s_v          (1'b1),
    .i_s_d          (a8_s),
    .o_s_r          (),
    .o_z0_v         (x_a8_v[0]),
    .o_z0_d         (x_a8_d[0]),
    .i_z0_r         (x_a8_r[0]),
    .o_z1_v         (x_a8_v[1]),
    .o_z1_d         (x_a8_d[1]),
    .i_z1_r         (x_a8_r[1]),
    .o_z2_v         (x_a8_v[2]),
    .o_z2_d         (x_a8_d[2]),
    .i_z2_r         (x_a8_r[2]),
    .o_z3_v         (x_a8_v[3]),
    .o_z3_d         (x_a8_d[3]),
    .i_z3_r         (x_a8_r[3]),
    .o_z4_v         (x_a8_v[4]),
    .o_z4_d         (x_a8_d[4]),
    .i_z4_r         (x_a8_r[4]),
    .o_z5_v         (x_a8_v[5]),
    .o_z5_d         (x_a8_d[5]),
    .i_z5_r         (x_a8_r[5]),
    .o_z6_v         (x_a8_v[6]),
    .o_z6_d         (x_a8_d[6]),
    .i_z6_r         (x_a8_r[6]),
    .o_z7_v         (x_a8_v[7]),
    .o_z7_d         (x_a8_d[7]),
    .i_z7_r         (x_a8_r[7]),
    .o_z8_v         (x_a8_v[8]),
    .o_z8_d         (x_a8_d[8]),
    .i_z8_r         (x_a8_r[8]),
    .o_z9_v         (x_a8_v[9]),
    .o_z9_d         (x_a8_d[9]),
    .i_z9_r         (x_a8_r[9]),
    .o_za_v         (x_a8_v[10]),
    .o_za_d         (x_a8_d[10]),
    .i_za_r         (x_a8_r[10]),
    .o_zb_v         (x_a8_v[11]),
    .o_zb_d         (x_a8_d[11]),
    .i_zb_r         (x_a8_r[11]),
    .o_zc_v         (x_a8_v[12]),
    .o_zc_d         (x_a8_d[12]),
    .i_zc_r         (x_a8_r[12]),
    .o_zd_v         (x_a8_v[13]),
    .o_zd_d         (x_a8_d[13]),
    .i_zd_r         (x_a8_r[13]),
    .o_ze_v         (x_a8_v[14]),
    .o_ze_d         (x_a8_d[14]),
    .i_ze_r         (x_a8_r[14]),
    .o_zf_v         (x_a8_v[15]),
    .o_zf_d         (x_a8_d[15]),
    .i_zf_r         (x_a8_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a9_v[0:RATIO-1];
wire    [N-1:0] x_a9_d[0:RATIO-1];
wire            x_a9_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_a9 (
    .clk            (clk),
    .i_a_v          (i_a9_v),
    .i_a_d          (i_a9_d),
    .o_a_r          (o_a9_r),
    .i_s_v          (1'b1),
    .i_s_d          (a9_s),
    .o_s_r          (),
    .o_z0_v         (x_a9_v[0]),
    .o_z0_d         (x_a9_d[0]),
    .i_z0_r         (x_a9_r[0]),
    .o_z1_v         (x_a9_v[1]),
    .o_z1_d         (x_a9_d[1]),
    .i_z1_r         (x_a9_r[1]),
    .o_z2_v         (x_a9_v[2]),
    .o_z2_d         (x_a9_d[2]),
    .i_z2_r         (x_a9_r[2]),
    .o_z3_v         (x_a9_v[3]),
    .o_z3_d         (x_a9_d[3]),
    .i_z3_r         (x_a9_r[3]),
    .o_z4_v         (x_a9_v[4]),
    .o_z4_d         (x_a9_d[4]),
    .i_z4_r         (x_a9_r[4]),
    .o_z5_v         (x_a9_v[5]),
    .o_z5_d         (x_a9_d[5]),
    .i_z5_r         (x_a9_r[5]),
    .o_z6_v         (x_a9_v[6]),
    .o_z6_d         (x_a9_d[6]),
    .i_z6_r         (x_a9_r[6]),
    .o_z7_v         (x_a9_v[7]),
    .o_z7_d         (x_a9_d[7]),
    .i_z7_r         (x_a9_r[7]),
    .o_z8_v         (x_a9_v[8]),
    .o_z8_d         (x_a9_d[8]),
    .i_z8_r         (x_a9_r[8]),
    .o_z9_v         (x_a9_v[9]),
    .o_z9_d         (x_a9_d[9]),
    .i_z9_r         (x_a9_r[9]),
    .o_za_v         (x_a9_v[10]),
    .o_za_d         (x_a9_d[10]),
    .i_za_r         (x_a9_r[10]),
    .o_zb_v         (x_a9_v[11]),
    .o_zb_d         (x_a9_d[11]),
    .i_zb_r         (x_a9_r[11]),
    .o_zc_v         (x_a9_v[12]),
    .o_zc_d         (x_a9_d[12]),
    .i_zc_r         (x_a9_r[12]),
    .o_zd_v         (x_a9_v[13]),
    .o_zd_d         (x_a9_d[13]),
    .i_zd_r         (x_a9_r[13]),
    .o_ze_v         (x_a9_v[14]),
    .o_ze_d         (x_a9_d[14]),
    .i_ze_r         (x_a9_r[14]),
    .o_zf_v         (x_a9_v[15]),
    .o_zf_d         (x_a9_d[15]),
    .i_zf_r         (x_a9_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_aa_v[0:RATIO-1];
wire    [N-1:0] x_aa_d[0:RATIO-1];
wire            x_aa_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_aa (
    .clk            (clk),
    .i_a_v          (i_aa_v),
    .i_a_d          (i_aa_d),
    .o_a_r          (o_aa_r),
    .i_s_v          (1'b1),
    .i_s_d          (aa_s),
    .o_s_r          (),
    .o_z0_v         (x_aa_v[0]),
    .o_z0_d         (x_aa_d[0]),
    .i_z0_r         (x_aa_r[0]),
    .o_z1_v         (x_aa_v[1]),
    .o_z1_d         (x_aa_d[1]),
    .i_z1_r         (x_aa_r[1]),
    .o_z2_v         (x_aa_v[2]),
    .o_z2_d         (x_aa_d[2]),
    .i_z2_r         (x_aa_r[2]),
    .o_z3_v         (x_aa_v[3]),
    .o_z3_d         (x_aa_d[3]),
    .i_z3_r         (x_aa_r[3]),
    .o_z4_v         (x_aa_v[4]),
    .o_z4_d         (x_aa_d[4]),
    .i_z4_r         (x_aa_r[4]),
    .o_z5_v         (x_aa_v[5]),
    .o_z5_d         (x_aa_d[5]),
    .i_z5_r         (x_aa_r[5]),
    .o_z6_v         (x_aa_v[6]),
    .o_z6_d         (x_aa_d[6]),
    .i_z6_r         (x_aa_r[6]),
    .o_z7_v         (x_aa_v[7]),
    .o_z7_d         (x_aa_d[7]),
    .i_z7_r         (x_aa_r[7]),
    .o_z8_v         (x_aa_v[8]),
    .o_z8_d         (x_aa_d[8]),
    .i_z8_r         (x_aa_r[8]),
    .o_z9_v         (x_aa_v[9]),
    .o_z9_d         (x_aa_d[9]),
    .i_z9_r         (x_aa_r[9]),
    .o_za_v         (x_aa_v[10]),
    .o_za_d         (x_aa_d[10]),
    .i_za_r         (x_aa_r[10]),
    .o_zb_v         (x_aa_v[11]),
    .o_zb_d         (x_aa_d[11]),
    .i_zb_r         (x_aa_r[11]),
    .o_zc_v         (x_aa_v[12]),
    .o_zc_d         (x_aa_d[12]),
    .i_zc_r         (x_aa_r[12]),
    .o_zd_v         (x_aa_v[13]),
    .o_zd_d         (x_aa_d[13]),
    .i_zd_r         (x_aa_r[13]),
    .o_ze_v         (x_aa_v[14]),
    .o_ze_d         (x_aa_d[14]),
    .i_ze_r         (x_aa_r[14]),
    .o_zf_v         (x_aa_v[15]),
    .o_zf_d         (x_aa_d[15]),
    .i_zf_r         (x_aa_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_ab_v[0:RATIO-1];
wire    [N-1:0] x_ab_d[0:RATIO-1];
wire            x_ab_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_ab (
    .clk            (clk),
    .i_a_v          (i_ab_v),
    .i_a_d          (i_ab_d),
    .o_a_r          (o_ab_r),
    .i_s_v          (1'b1),
    .i_s_d          (ab_s),
    .o_s_r          (),
    .o_z0_v         (x_ab_v[0]),
    .o_z0_d         (x_ab_d[0]),
    .i_z0_r         (x_ab_r[0]),
    .o_z1_v         (x_ab_v[1]),
    .o_z1_d         (x_ab_d[1]),
    .i_z1_r         (x_ab_r[1]),
    .o_z2_v         (x_ab_v[2]),
    .o_z2_d         (x_ab_d[2]),
    .i_z2_r         (x_ab_r[2]),
    .o_z3_v         (x_ab_v[3]),
    .o_z3_d         (x_ab_d[3]),
    .i_z3_r         (x_ab_r[3]),
    .o_z4_v         (x_ab_v[4]),
    .o_z4_d         (x_ab_d[4]),
    .i_z4_r         (x_ab_r[4]),
    .o_z5_v         (x_ab_v[5]),
    .o_z5_d         (x_ab_d[5]),
    .i_z5_r         (x_ab_r[5]),
    .o_z6_v         (x_ab_v[6]),
    .o_z6_d         (x_ab_d[6]),
    .i_z6_r         (x_ab_r[6]),
    .o_z7_v         (x_ab_v[7]),
    .o_z7_d         (x_ab_d[7]),
    .i_z7_r         (x_ab_r[7]),
    .o_z8_v         (x_ab_v[8]),
    .o_z8_d         (x_ab_d[8]),
    .i_z8_r         (x_ab_r[8]),
    .o_z9_v         (x_ab_v[9]),
    .o_z9_d         (x_ab_d[9]),
    .i_z9_r         (x_ab_r[9]),
    .o_za_v         (x_ab_v[10]),
    .o_za_d         (x_ab_d[10]),
    .i_za_r         (x_ab_r[10]),
    .o_zb_v         (x_ab_v[11]),
    .o_zb_d         (x_ab_d[11]),
    .i_zb_r         (x_ab_r[11]),
    .o_zc_v         (x_ab_v[12]),
    .o_zc_d         (x_ab_d[12]),
    .i_zc_r         (x_ab_r[12]),
    .o_zd_v         (x_ab_v[13]),
    .o_zd_d         (x_ab_d[13]),
    .i_zd_r         (x_ab_r[13]),
    .o_ze_v         (x_ab_v[14]),
    .o_ze_d         (x_ab_d[14]),
    .i_ze_r         (x_ab_r[14]),
    .o_zf_v         (x_ab_v[15]),
    .o_zf_d         (x_ab_d[15]),
    .i_zf_r         (x_ab_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_ac_v[0:RATIO-1];
wire    [N-1:0] x_ac_d[0:RATIO-1];
wire            x_ac_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_ac (
    .clk            (clk),
    .i_a_v          (i_ac_v),
    .i_a_d          (i_ac_d),
    .o_a_r          (o_ac_r),
    .i_s_v          (1'b1),
    .i_s_d          (ac_s),
    .o_s_r          (),
    .o_z0_v         (x_ac_v[0]),
    .o_z0_d         (x_ac_d[0]),
    .i_z0_r         (x_ac_r[0]),
    .o_z1_v         (x_ac_v[1]),
    .o_z1_d         (x_ac_d[1]),
    .i_z1_r         (x_ac_r[1]),
    .o_z2_v         (x_ac_v[2]),
    .o_z2_d         (x_ac_d[2]),
    .i_z2_r         (x_ac_r[2]),
    .o_z3_v         (x_ac_v[3]),
    .o_z3_d         (x_ac_d[3]),
    .i_z3_r         (x_ac_r[3]),
    .o_z4_v         (x_ac_v[4]),
    .o_z4_d         (x_ac_d[4]),
    .i_z4_r         (x_ac_r[4]),
    .o_z5_v         (x_ac_v[5]),
    .o_z5_d         (x_ac_d[5]),
    .i_z5_r         (x_ac_r[5]),
    .o_z6_v         (x_ac_v[6]),
    .o_z6_d         (x_ac_d[6]),
    .i_z6_r         (x_ac_r[6]),
    .o_z7_v         (x_ac_v[7]),
    .o_z7_d         (x_ac_d[7]),
    .i_z7_r         (x_ac_r[7]),
    .o_z8_v         (x_ac_v[8]),
    .o_z8_d         (x_ac_d[8]),
    .i_z8_r         (x_ac_r[8]),
    .o_z9_v         (x_ac_v[9]),
    .o_z9_d         (x_ac_d[9]),
    .i_z9_r         (x_ac_r[9]),
    .o_za_v         (x_ac_v[10]),
    .o_za_d         (x_ac_d[10]),
    .i_za_r         (x_ac_r[10]),
    .o_zb_v         (x_ac_v[11]),
    .o_zb_d         (x_ac_d[11]),
    .i_zb_r         (x_ac_r[11]),
    .o_zc_v         (x_ac_v[12]),
    .o_zc_d         (x_ac_d[12]),
    .i_zc_r         (x_ac_r[12]),
    .o_zd_v         (x_ac_v[13]),
    .o_zd_d         (x_ac_d[13]),
    .i_zd_r         (x_ac_r[13]),
    .o_ze_v         (x_ac_v[14]),
    .o_ze_d         (x_ac_d[14]),
    .i_ze_r         (x_ac_r[14]),
    .o_zf_v         (x_ac_v[15]),
    .o_zf_d         (x_ac_d[15]),
    .i_zf_r         (x_ac_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_ad_v[0:RATIO-1];
wire    [N-1:0] x_ad_d[0:RATIO-1];
wire            x_ad_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_ad (
    .clk            (clk),
    .i_a_v          (i_ad_v),
    .i_a_d          (i_ad_d),
    .o_a_r          (o_ad_r),
    .i_s_v          (1'b1),
    .i_s_d          (ad_s),
    .o_s_r          (),
    .o_z0_v         (x_ad_v[0]),
    .o_z0_d         (x_ad_d[0]),
    .i_z0_r         (x_ad_r[0]),
    .o_z1_v         (x_ad_v[1]),
    .o_z1_d         (x_ad_d[1]),
    .i_z1_r         (x_ad_r[1]),
    .o_z2_v         (x_ad_v[2]),
    .o_z2_d         (x_ad_d[2]),
    .i_z2_r         (x_ad_r[2]),
    .o_z3_v         (x_ad_v[3]),
    .o_z3_d         (x_ad_d[3]),
    .i_z3_r         (x_ad_r[3]),
    .o_z4_v         (x_ad_v[4]),
    .o_z4_d         (x_ad_d[4]),
    .i_z4_r         (x_ad_r[4]),
    .o_z5_v         (x_ad_v[5]),
    .o_z5_d         (x_ad_d[5]),
    .i_z5_r         (x_ad_r[5]),
    .o_z6_v         (x_ad_v[6]),
    .o_z6_d         (x_ad_d[6]),
    .i_z6_r         (x_ad_r[6]),
    .o_z7_v         (x_ad_v[7]),
    .o_z7_d         (x_ad_d[7]),
    .i_z7_r         (x_ad_r[7]),
    .o_z8_v         (x_ad_v[8]),
    .o_z8_d         (x_ad_d[8]),
    .i_z8_r         (x_ad_r[8]),
    .o_z9_v         (x_ad_v[9]),
    .o_z9_d         (x_ad_d[9]),
    .i_z9_r         (x_ad_r[9]),
    .o_za_v         (x_ad_v[10]),
    .o_za_d         (x_ad_d[10]),
    .i_za_r         (x_ad_r[10]),
    .o_zb_v         (x_ad_v[11]),
    .o_zb_d         (x_ad_d[11]),
    .i_zb_r         (x_ad_r[11]),
    .o_zc_v         (x_ad_v[12]),
    .o_zc_d         (x_ad_d[12]),
    .i_zc_r         (x_ad_r[12]),
    .o_zd_v         (x_ad_v[13]),
    .o_zd_d         (x_ad_d[13]),
    .i_zd_r         (x_ad_r[13]),
    .o_ze_v         (x_ad_v[14]),
    .o_ze_d         (x_ad_d[14]),
    .i_ze_r         (x_ad_r[14]),
    .o_zf_v         (x_ad_v[15]),
    .o_zf_d         (x_ad_d[15]),
    .i_zf_r         (x_ad_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_ae_v[0:RATIO-1];
wire    [N-1:0] x_ae_d[0:RATIO-1];
wire            x_ae_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_ae (
    .clk            (clk),
    .i_a_v          (i_ae_v),
    .i_a_d          (i_ae_d),
    .o_a_r          (o_ae_r),
    .i_s_v          (1'b1),
    .i_s_d          (ae_s),
    .o_s_r          (),
    .o_z0_v         (x_ae_v[0]),
    .o_z0_d         (x_ae_d[0]),
    .i_z0_r         (x_ae_r[0]),
    .o_z1_v         (x_ae_v[1]),
    .o_z1_d         (x_ae_d[1]),
    .i_z1_r         (x_ae_r[1]),
    .o_z2_v         (x_ae_v[2]),
    .o_z2_d         (x_ae_d[2]),
    .i_z2_r         (x_ae_r[2]),
    .o_z3_v         (x_ae_v[3]),
    .o_z3_d         (x_ae_d[3]),
    .i_z3_r         (x_ae_r[3]),
    .o_z4_v         (x_ae_v[4]),
    .o_z4_d         (x_ae_d[4]),
    .i_z4_r         (x_ae_r[4]),
    .o_z5_v         (x_ae_v[5]),
    .o_z5_d         (x_ae_d[5]),
    .i_z5_r         (x_ae_r[5]),
    .o_z6_v         (x_ae_v[6]),
    .o_z6_d         (x_ae_d[6]),
    .i_z6_r         (x_ae_r[6]),
    .o_z7_v         (x_ae_v[7]),
    .o_z7_d         (x_ae_d[7]),
    .i_z7_r         (x_ae_r[7]),
    .o_z8_v         (x_ae_v[8]),
    .o_z8_d         (x_ae_d[8]),
    .i_z8_r         (x_ae_r[8]),
    .o_z9_v         (x_ae_v[9]),
    .o_z9_d         (x_ae_d[9]),
    .i_z9_r         (x_ae_r[9]),
    .o_za_v         (x_ae_v[10]),
    .o_za_d         (x_ae_d[10]),
    .i_za_r         (x_ae_r[10]),
    .o_zb_v         (x_ae_v[11]),
    .o_zb_d         (x_ae_d[11]),
    .i_zb_r         (x_ae_r[11]),
    .o_zc_v         (x_ae_v[12]),
    .o_zc_d         (x_ae_d[12]),
    .i_zc_r         (x_ae_r[12]),
    .o_zd_v         (x_ae_v[13]),
    .o_zd_d         (x_ae_d[13]),
    .i_zd_r         (x_ae_r[13]),
    .o_ze_v         (x_ae_v[14]),
    .o_ze_d         (x_ae_d[14]),
    .i_ze_r         (x_ae_r[14]),
    .o_zf_v         (x_ae_v[15]),
    .o_zf_d         (x_ae_d[15]),
    .i_zf_r         (x_ae_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_af_v[0:RATIO-1];
wire    [N-1:0] x_af_d[0:RATIO-1];
wire            x_af_r[0:RATIO-1];

cory_demux16 #(.N(N)) u_demux_af (
    .clk            (clk),
    .i_a_v          (i_af_v),
    .i_a_d          (i_af_d),
    .o_a_r          (o_af_r),
    .i_s_v          (1'b1),
    .i_s_d          (af_s),
    .o_s_r          (),
    .o_z0_v         (x_af_v[0]),
    .o_z0_d         (x_af_d[0]),
    .i_z0_r         (x_af_r[0]),
    .o_z1_v         (x_af_v[1]),
    .o_z1_d         (x_af_d[1]),
    .i_z1_r         (x_af_r[1]),
    .o_z2_v         (x_af_v[2]),
    .o_z2_d         (x_af_d[2]),
    .i_z2_r         (x_af_r[2]),
    .o_z3_v         (x_af_v[3]),
    .o_z3_d         (x_af_d[3]),
    .i_z3_r         (x_af_r[3]),
    .o_z4_v         (x_af_v[4]),
    .o_z4_d         (x_af_d[4]),
    .i_z4_r         (x_af_r[4]),
    .o_z5_v         (x_af_v[5]),
    .o_z5_d         (x_af_d[5]),
    .i_z5_r         (x_af_r[5]),
    .o_z6_v         (x_af_v[6]),
    .o_z6_d         (x_af_d[6]),
    .i_z6_r         (x_af_r[6]),
    .o_z7_v         (x_af_v[7]),
    .o_z7_d         (x_af_d[7]),
    .i_z7_r         (x_af_r[7]),
    .o_z8_v         (x_af_v[8]),
    .o_z8_d         (x_af_d[8]),
    .i_z8_r         (x_af_r[8]),
    .o_z9_v         (x_af_v[9]),
    .o_z9_d         (x_af_d[9]),
    .i_z9_r         (x_af_r[9]),
    .o_za_v         (x_af_v[10]),
    .o_za_d         (x_af_d[10]),
    .i_za_r         (x_af_r[10]),
    .o_zb_v         (x_af_v[11]),
    .o_zb_d         (x_af_d[11]),
    .i_zb_r         (x_af_r[11]),
    .o_zc_v         (x_af_v[12]),
    .o_zc_d         (x_af_d[12]),
    .i_zc_r         (x_af_r[12]),
    .o_zd_v         (x_af_v[13]),
    .o_zd_d         (x_af_d[13]),
    .i_zd_r         (x_af_r[13]),
    .o_ze_v         (x_af_v[14]),
    .o_ze_d         (x_af_d[14]),
    .i_ze_r         (x_af_r[14]),
    .o_zf_v         (x_af_v[15]),
    .o_zf_d         (x_af_d[15]),
    .i_zf_r         (x_af_r[15]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z0_v[0:RATIO-1];
wire    [N-1:0] x_z0_d[0:RATIO-1];
wire            x_z0_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_z0 (
    .clk            (clk),
    .i_a0_v         (x_z0_v[0]),
    .i_a0_d         (x_z0_d[0]),
    .o_a0_r         (x_z0_r[0]),
    .i_a1_v         (x_z0_v[1]),
    .i_a1_d         (x_z0_d[1]),
    .o_a1_r         (x_z0_r[1]),
    .i_a2_v         (x_z0_v[2]),
    .i_a2_d         (x_z0_d[2]),
    .o_a2_r         (x_z0_r[2]),
    .i_a3_v         (x_z0_v[3]),
    .i_a3_d         (x_z0_d[3]),
    .o_a3_r         (x_z0_r[3]),
    .i_a4_v         (x_z0_v[4]),
    .i_a4_d         (x_z0_d[4]),
    .o_a4_r         (x_z0_r[4]),
    .i_a5_v         (x_z0_v[5]),
    .i_a5_d         (x_z0_d[5]),
    .o_a5_r         (x_z0_r[5]),
    .i_a6_v         (x_z0_v[6]),
    .i_a6_d         (x_z0_d[6]),
    .o_a6_r         (x_z0_r[6]),
    .i_a7_v         (x_z0_v[7]),
    .i_a7_d         (x_z0_d[7]),
    .o_a7_r         (x_z0_r[7]),
    .i_a8_v         (x_z0_v[8]),
    .i_a8_d         (x_z0_d[8]),
    .o_a8_r         (x_z0_r[8]),
    .i_a9_v         (x_z0_v[9]),
    .i_a9_d         (x_z0_d[9]),
    .o_a9_r         (x_z0_r[9]),
    .i_aa_v         (x_z0_v[10]),
    .i_aa_d         (x_z0_d[10]),
    .o_aa_r         (x_z0_r[10]),
    .i_ab_v         (x_z0_v[11]),
    .i_ab_d         (x_z0_d[11]),
    .o_ab_r         (x_z0_r[11]),
    .i_ac_v         (x_z0_v[12]),
    .i_ac_d         (x_z0_d[12]),
    .o_ac_r         (x_z0_r[12]),
    .i_ad_v         (x_z0_v[13]),
    .i_ad_d         (x_z0_d[13]),
    .o_ad_r         (x_z0_r[13]),
    .i_ae_v         (x_z0_v[14]),
    .i_ae_d         (x_z0_d[14]),
    .o_ae_r         (x_z0_r[14]),
    .i_af_v         (x_z0_v[15]),
    .i_af_d         (x_z0_d[15]),
    .o_af_r         (x_z0_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (z0_s),
    .o_s_r          (),
    .o_z_v          (o_z0_v),
    .o_z_d          (o_z0_d),
    .i_z_r          (i_z0_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z1_v[0:RATIO-1];
wire    [N-1:0] x_z1_d[0:RATIO-1];
wire            x_z1_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_z1 (
    .clk            (clk),
    .i_a0_v         (x_z1_v[0]),
    .i_a0_d         (x_z1_d[0]),
    .o_a0_r         (x_z1_r[0]),
    .i_a1_v         (x_z1_v[1]),
    .i_a1_d         (x_z1_d[1]),
    .o_a1_r         (x_z1_r[1]),
    .i_a2_v         (x_z1_v[2]),
    .i_a2_d         (x_z1_d[2]),
    .o_a2_r         (x_z1_r[2]),
    .i_a3_v         (x_z1_v[3]),
    .i_a3_d         (x_z1_d[3]),
    .o_a3_r         (x_z1_r[3]),
    .i_a4_v         (x_z1_v[4]),
    .i_a4_d         (x_z1_d[4]),
    .o_a4_r         (x_z1_r[4]),
    .i_a5_v         (x_z1_v[5]),
    .i_a5_d         (x_z1_d[5]),
    .o_a5_r         (x_z1_r[5]),
    .i_a6_v         (x_z1_v[6]),
    .i_a6_d         (x_z1_d[6]),
    .o_a6_r         (x_z1_r[6]),
    .i_a7_v         (x_z1_v[7]),
    .i_a7_d         (x_z1_d[7]),
    .o_a7_r         (x_z1_r[7]),
    .i_a8_v         (x_z1_v[8]),
    .i_a8_d         (x_z1_d[8]),
    .o_a8_r         (x_z1_r[8]),
    .i_a9_v         (x_z1_v[9]),
    .i_a9_d         (x_z1_d[9]),
    .o_a9_r         (x_z1_r[9]),
    .i_aa_v         (x_z1_v[10]),
    .i_aa_d         (x_z1_d[10]),
    .o_aa_r         (x_z1_r[10]),
    .i_ab_v         (x_z1_v[11]),
    .i_ab_d         (x_z1_d[11]),
    .o_ab_r         (x_z1_r[11]),
    .i_ac_v         (x_z1_v[12]),
    .i_ac_d         (x_z1_d[12]),
    .o_ac_r         (x_z1_r[12]),
    .i_ad_v         (x_z1_v[13]),
    .i_ad_d         (x_z1_d[13]),
    .o_ad_r         (x_z1_r[13]),
    .i_ae_v         (x_z1_v[14]),
    .i_ae_d         (x_z1_d[14]),
    .o_ae_r         (x_z1_r[14]),
    .i_af_v         (x_z1_v[15]),
    .i_af_d         (x_z1_d[15]),
    .o_af_r         (x_z1_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (z1_s),
    .o_s_r          (),
    .o_z_v          (o_z1_v),
    .o_z_d          (o_z1_d),
    .i_z_r          (i_z1_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z2_v[0:RATIO-1];
wire    [N-1:0] x_z2_d[0:RATIO-1];
wire            x_z2_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_z2 (
    .clk            (clk),
    .i_a0_v         (x_z2_v[0]),
    .i_a0_d         (x_z2_d[0]),
    .o_a0_r         (x_z2_r[0]),
    .i_a1_v         (x_z2_v[1]),
    .i_a1_d         (x_z2_d[1]),
    .o_a1_r         (x_z2_r[1]),
    .i_a2_v         (x_z2_v[2]),
    .i_a2_d         (x_z2_d[2]),
    .o_a2_r         (x_z2_r[2]),
    .i_a3_v         (x_z2_v[3]),
    .i_a3_d         (x_z2_d[3]),
    .o_a3_r         (x_z2_r[3]),
    .i_a4_v         (x_z2_v[4]),
    .i_a4_d         (x_z2_d[4]),
    .o_a4_r         (x_z2_r[4]),
    .i_a5_v         (x_z2_v[5]),
    .i_a5_d         (x_z2_d[5]),
    .o_a5_r         (x_z2_r[5]),
    .i_a6_v         (x_z2_v[6]),
    .i_a6_d         (x_z2_d[6]),
    .o_a6_r         (x_z2_r[6]),
    .i_a7_v         (x_z2_v[7]),
    .i_a7_d         (x_z2_d[7]),
    .o_a7_r         (x_z2_r[7]),
    .i_a8_v         (x_z2_v[8]),
    .i_a8_d         (x_z2_d[8]),
    .o_a8_r         (x_z2_r[8]),
    .i_a9_v         (x_z2_v[9]),
    .i_a9_d         (x_z2_d[9]),
    .o_a9_r         (x_z2_r[9]),
    .i_aa_v         (x_z2_v[10]),
    .i_aa_d         (x_z2_d[10]),
    .o_aa_r         (x_z2_r[10]),
    .i_ab_v         (x_z2_v[11]),
    .i_ab_d         (x_z2_d[11]),
    .o_ab_r         (x_z2_r[11]),
    .i_ac_v         (x_z2_v[12]),
    .i_ac_d         (x_z2_d[12]),
    .o_ac_r         (x_z2_r[12]),
    .i_ad_v         (x_z2_v[13]),
    .i_ad_d         (x_z2_d[13]),
    .o_ad_r         (x_z2_r[13]),
    .i_ae_v         (x_z2_v[14]),
    .i_ae_d         (x_z2_d[14]),
    .o_ae_r         (x_z2_r[14]),
    .i_af_v         (x_z2_v[15]),
    .i_af_d         (x_z2_d[15]),
    .o_af_r         (x_z2_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (z2_s),
    .o_s_r          (),
    .o_z_v          (o_z2_v),
    .o_z_d          (o_z2_d),
    .i_z_r          (i_z2_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z3_v[0:RATIO-1];
wire    [N-1:0] x_z3_d[0:RATIO-1];
wire            x_z3_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_z3 (
    .clk            (clk),
    .i_a0_v         (x_z3_v[0]),
    .i_a0_d         (x_z3_d[0]),
    .o_a0_r         (x_z3_r[0]),
    .i_a1_v         (x_z3_v[1]),
    .i_a1_d         (x_z3_d[1]),
    .o_a1_r         (x_z3_r[1]),
    .i_a2_v         (x_z3_v[2]),
    .i_a2_d         (x_z3_d[2]),
    .o_a2_r         (x_z3_r[2]),
    .i_a3_v         (x_z3_v[3]),
    .i_a3_d         (x_z3_d[3]),
    .o_a3_r         (x_z3_r[3]),
    .i_a4_v         (x_z3_v[4]),
    .i_a4_d         (x_z3_d[4]),
    .o_a4_r         (x_z3_r[4]),
    .i_a5_v         (x_z3_v[5]),
    .i_a5_d         (x_z3_d[5]),
    .o_a5_r         (x_z3_r[5]),
    .i_a6_v         (x_z3_v[6]),
    .i_a6_d         (x_z3_d[6]),
    .o_a6_r         (x_z3_r[6]),
    .i_a7_v         (x_z3_v[7]),
    .i_a7_d         (x_z3_d[7]),
    .o_a7_r         (x_z3_r[7]),
    .i_a8_v         (x_z3_v[8]),
    .i_a8_d         (x_z3_d[8]),
    .o_a8_r         (x_z3_r[8]),
    .i_a9_v         (x_z3_v[9]),
    .i_a9_d         (x_z3_d[9]),
    .o_a9_r         (x_z3_r[9]),
    .i_aa_v         (x_z3_v[10]),
    .i_aa_d         (x_z3_d[10]),
    .o_aa_r         (x_z3_r[10]),
    .i_ab_v         (x_z3_v[11]),
    .i_ab_d         (x_z3_d[11]),
    .o_ab_r         (x_z3_r[11]),
    .i_ac_v         (x_z3_v[12]),
    .i_ac_d         (x_z3_d[12]),
    .o_ac_r         (x_z3_r[12]),
    .i_ad_v         (x_z3_v[13]),
    .i_ad_d         (x_z3_d[13]),
    .o_ad_r         (x_z3_r[13]),
    .i_ae_v         (x_z3_v[14]),
    .i_ae_d         (x_z3_d[14]),
    .o_ae_r         (x_z3_r[14]),
    .i_af_v         (x_z3_v[15]),
    .i_af_d         (x_z3_d[15]),
    .o_af_r         (x_z3_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (z3_s),
    .o_s_r          (),
    .o_z_v          (o_z3_v),
    .o_z_d          (o_z3_d),
    .i_z_r          (i_z3_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z4_v[0:RATIO-1];
wire    [N-1:0] x_z4_d[0:RATIO-1];
wire            x_z4_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_z4 (
    .clk            (clk),
    .i_a0_v         (x_z4_v[0]),
    .i_a0_d         (x_z4_d[0]),
    .o_a0_r         (x_z4_r[0]),
    .i_a1_v         (x_z4_v[1]),
    .i_a1_d         (x_z4_d[1]),
    .o_a1_r         (x_z4_r[1]),
    .i_a2_v         (x_z4_v[2]),
    .i_a2_d         (x_z4_d[2]),
    .o_a2_r         (x_z4_r[2]),
    .i_a3_v         (x_z4_v[3]),
    .i_a3_d         (x_z4_d[3]),
    .o_a3_r         (x_z4_r[3]),
    .i_a4_v         (x_z4_v[4]),
    .i_a4_d         (x_z4_d[4]),
    .o_a4_r         (x_z4_r[4]),
    .i_a5_v         (x_z4_v[5]),
    .i_a5_d         (x_z4_d[5]),
    .o_a5_r         (x_z4_r[5]),
    .i_a6_v         (x_z4_v[6]),
    .i_a6_d         (x_z4_d[6]),
    .o_a6_r         (x_z4_r[6]),
    .i_a7_v         (x_z4_v[7]),
    .i_a7_d         (x_z4_d[7]),
    .o_a7_r         (x_z4_r[7]),
    .i_a8_v         (x_z4_v[8]),
    .i_a8_d         (x_z4_d[8]),
    .o_a8_r         (x_z4_r[8]),
    .i_a9_v         (x_z4_v[9]),
    .i_a9_d         (x_z4_d[9]),
    .o_a9_r         (x_z4_r[9]),
    .i_aa_v         (x_z4_v[10]),
    .i_aa_d         (x_z4_d[10]),
    .o_aa_r         (x_z4_r[10]),
    .i_ab_v         (x_z4_v[11]),
    .i_ab_d         (x_z4_d[11]),
    .o_ab_r         (x_z4_r[11]),
    .i_ac_v         (x_z4_v[12]),
    .i_ac_d         (x_z4_d[12]),
    .o_ac_r         (x_z4_r[12]),
    .i_ad_v         (x_z4_v[13]),
    .i_ad_d         (x_z4_d[13]),
    .o_ad_r         (x_z4_r[13]),
    .i_ae_v         (x_z4_v[14]),
    .i_ae_d         (x_z4_d[14]),
    .o_ae_r         (x_z4_r[14]),
    .i_af_v         (x_z4_v[15]),
    .i_af_d         (x_z4_d[15]),
    .o_af_r         (x_z4_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (z4_s),
    .o_s_r          (),
    .o_z_v          (o_z4_v),
    .o_z_d          (o_z4_d),
    .i_z_r          (i_z4_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z5_v[0:RATIO-1];
wire    [N-1:0] x_z5_d[0:RATIO-1];
wire            x_z5_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_z5 (
    .clk            (clk),
    .i_a0_v         (x_z5_v[0]),
    .i_a0_d         (x_z5_d[0]),
    .o_a0_r         (x_z5_r[0]),
    .i_a1_v         (x_z5_v[1]),
    .i_a1_d         (x_z5_d[1]),
    .o_a1_r         (x_z5_r[1]),
    .i_a2_v         (x_z5_v[2]),
    .i_a2_d         (x_z5_d[2]),
    .o_a2_r         (x_z5_r[2]),
    .i_a3_v         (x_z5_v[3]),
    .i_a3_d         (x_z5_d[3]),
    .o_a3_r         (x_z5_r[3]),
    .i_a4_v         (x_z5_v[4]),
    .i_a4_d         (x_z5_d[4]),
    .o_a4_r         (x_z5_r[4]),
    .i_a5_v         (x_z5_v[5]),
    .i_a5_d         (x_z5_d[5]),
    .o_a5_r         (x_z5_r[5]),
    .i_a6_v         (x_z5_v[6]),
    .i_a6_d         (x_z5_d[6]),
    .o_a6_r         (x_z5_r[6]),
    .i_a7_v         (x_z5_v[7]),
    .i_a7_d         (x_z5_d[7]),
    .o_a7_r         (x_z5_r[7]),
    .i_a8_v         (x_z5_v[8]),
    .i_a8_d         (x_z5_d[8]),
    .o_a8_r         (x_z5_r[8]),
    .i_a9_v         (x_z5_v[9]),
    .i_a9_d         (x_z5_d[9]),
    .o_a9_r         (x_z5_r[9]),
    .i_aa_v         (x_z5_v[10]),
    .i_aa_d         (x_z5_d[10]),
    .o_aa_r         (x_z5_r[10]),
    .i_ab_v         (x_z5_v[11]),
    .i_ab_d         (x_z5_d[11]),
    .o_ab_r         (x_z5_r[11]),
    .i_ac_v         (x_z5_v[12]),
    .i_ac_d         (x_z5_d[12]),
    .o_ac_r         (x_z5_r[12]),
    .i_ad_v         (x_z5_v[13]),
    .i_ad_d         (x_z5_d[13]),
    .o_ad_r         (x_z5_r[13]),
    .i_ae_v         (x_z5_v[14]),
    .i_ae_d         (x_z5_d[14]),
    .o_ae_r         (x_z5_r[14]),
    .i_af_v         (x_z5_v[15]),
    .i_af_d         (x_z5_d[15]),
    .o_af_r         (x_z5_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (z5_s),
    .o_s_r          (),
    .o_z_v          (o_z5_v),
    .o_z_d          (o_z5_d),
    .i_z_r          (i_z5_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z6_v[0:RATIO-1];
wire    [N-1:0] x_z6_d[0:RATIO-1];
wire            x_z6_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_z6 (
    .clk            (clk),
    .i_a0_v         (x_z6_v[0]),
    .i_a0_d         (x_z6_d[0]),
    .o_a0_r         (x_z6_r[0]),
    .i_a1_v         (x_z6_v[1]),
    .i_a1_d         (x_z6_d[1]),
    .o_a1_r         (x_z6_r[1]),
    .i_a2_v         (x_z6_v[2]),
    .i_a2_d         (x_z6_d[2]),
    .o_a2_r         (x_z6_r[2]),
    .i_a3_v         (x_z6_v[3]),
    .i_a3_d         (x_z6_d[3]),
    .o_a3_r         (x_z6_r[3]),
    .i_a4_v         (x_z6_v[4]),
    .i_a4_d         (x_z6_d[4]),
    .o_a4_r         (x_z6_r[4]),
    .i_a5_v         (x_z6_v[5]),
    .i_a5_d         (x_z6_d[5]),
    .o_a5_r         (x_z6_r[5]),
    .i_a6_v         (x_z6_v[6]),
    .i_a6_d         (x_z6_d[6]),
    .o_a6_r         (x_z6_r[6]),
    .i_a7_v         (x_z6_v[7]),
    .i_a7_d         (x_z6_d[7]),
    .o_a7_r         (x_z6_r[7]),
    .i_a8_v         (x_z6_v[8]),
    .i_a8_d         (x_z6_d[8]),
    .o_a8_r         (x_z6_r[8]),
    .i_a9_v         (x_z6_v[9]),
    .i_a9_d         (x_z6_d[9]),
    .o_a9_r         (x_z6_r[9]),
    .i_aa_v         (x_z6_v[10]),
    .i_aa_d         (x_z6_d[10]),
    .o_aa_r         (x_z6_r[10]),
    .i_ab_v         (x_z6_v[11]),
    .i_ab_d         (x_z6_d[11]),
    .o_ab_r         (x_z6_r[11]),
    .i_ac_v         (x_z6_v[12]),
    .i_ac_d         (x_z6_d[12]),
    .o_ac_r         (x_z6_r[12]),
    .i_ad_v         (x_z6_v[13]),
    .i_ad_d         (x_z6_d[13]),
    .o_ad_r         (x_z6_r[13]),
    .i_ae_v         (x_z6_v[14]),
    .i_ae_d         (x_z6_d[14]),
    .o_ae_r         (x_z6_r[14]),
    .i_af_v         (x_z6_v[15]),
    .i_af_d         (x_z6_d[15]),
    .o_af_r         (x_z6_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (z6_s),
    .o_s_r          (),
    .o_z_v          (o_z6_v),
    .o_z_d          (o_z6_d),
    .i_z_r          (i_z6_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z7_v[0:RATIO-1];
wire    [N-1:0] x_z7_d[0:RATIO-1];
wire            x_z7_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_z7 (
    .clk            (clk),
    .i_a0_v         (x_z7_v[0]),
    .i_a0_d         (x_z7_d[0]),
    .o_a0_r         (x_z7_r[0]),
    .i_a1_v         (x_z7_v[1]),
    .i_a1_d         (x_z7_d[1]),
    .o_a1_r         (x_z7_r[1]),
    .i_a2_v         (x_z7_v[2]),
    .i_a2_d         (x_z7_d[2]),
    .o_a2_r         (x_z7_r[2]),
    .i_a3_v         (x_z7_v[3]),
    .i_a3_d         (x_z7_d[3]),
    .o_a3_r         (x_z7_r[3]),
    .i_a4_v         (x_z7_v[4]),
    .i_a4_d         (x_z7_d[4]),
    .o_a4_r         (x_z7_r[4]),
    .i_a5_v         (x_z7_v[5]),
    .i_a5_d         (x_z7_d[5]),
    .o_a5_r         (x_z7_r[5]),
    .i_a6_v         (x_z7_v[6]),
    .i_a6_d         (x_z7_d[6]),
    .o_a6_r         (x_z7_r[6]),
    .i_a7_v         (x_z7_v[7]),
    .i_a7_d         (x_z7_d[7]),
    .o_a7_r         (x_z7_r[7]),
    .i_a8_v         (x_z7_v[8]),
    .i_a8_d         (x_z7_d[8]),
    .o_a8_r         (x_z7_r[8]),
    .i_a9_v         (x_z7_v[9]),
    .i_a9_d         (x_z7_d[9]),
    .o_a9_r         (x_z7_r[9]),
    .i_aa_v         (x_z7_v[10]),
    .i_aa_d         (x_z7_d[10]),
    .o_aa_r         (x_z7_r[10]),
    .i_ab_v         (x_z7_v[11]),
    .i_ab_d         (x_z7_d[11]),
    .o_ab_r         (x_z7_r[11]),
    .i_ac_v         (x_z7_v[12]),
    .i_ac_d         (x_z7_d[12]),
    .o_ac_r         (x_z7_r[12]),
    .i_ad_v         (x_z7_v[13]),
    .i_ad_d         (x_z7_d[13]),
    .o_ad_r         (x_z7_r[13]),
    .i_ae_v         (x_z7_v[14]),
    .i_ae_d         (x_z7_d[14]),
    .o_ae_r         (x_z7_r[14]),
    .i_af_v         (x_z7_v[15]),
    .i_af_d         (x_z7_d[15]),
    .o_af_r         (x_z7_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (z7_s),
    .o_s_r          (),
    .o_z_v          (o_z7_v),
    .o_z_d          (o_z7_d),
    .i_z_r          (i_z7_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z8_v[0:RATIO-1];
wire    [N-1:0] x_z8_d[0:RATIO-1];
wire            x_z8_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_z8 (
    .clk            (clk),
    .i_a0_v         (x_z8_v[0]),
    .i_a0_d         (x_z8_d[0]),
    .o_a0_r         (x_z8_r[0]),
    .i_a1_v         (x_z8_v[1]),
    .i_a1_d         (x_z8_d[1]),
    .o_a1_r         (x_z8_r[1]),
    .i_a2_v         (x_z8_v[2]),
    .i_a2_d         (x_z8_d[2]),
    .o_a2_r         (x_z8_r[2]),
    .i_a3_v         (x_z8_v[3]),
    .i_a3_d         (x_z8_d[3]),
    .o_a3_r         (x_z8_r[3]),
    .i_a4_v         (x_z8_v[4]),
    .i_a4_d         (x_z8_d[4]),
    .o_a4_r         (x_z8_r[4]),
    .i_a5_v         (x_z8_v[5]),
    .i_a5_d         (x_z8_d[5]),
    .o_a5_r         (x_z8_r[5]),
    .i_a6_v         (x_z8_v[6]),
    .i_a6_d         (x_z8_d[6]),
    .o_a6_r         (x_z8_r[6]),
    .i_a7_v         (x_z8_v[7]),
    .i_a7_d         (x_z8_d[7]),
    .o_a7_r         (x_z8_r[7]),
    .i_a8_v         (x_z8_v[8]),
    .i_a8_d         (x_z8_d[8]),
    .o_a8_r         (x_z8_r[8]),
    .i_a9_v         (x_z8_v[9]),
    .i_a9_d         (x_z8_d[9]),
    .o_a9_r         (x_z8_r[9]),
    .i_aa_v         (x_z8_v[10]),
    .i_aa_d         (x_z8_d[10]),
    .o_aa_r         (x_z8_r[10]),
    .i_ab_v         (x_z8_v[11]),
    .i_ab_d         (x_z8_d[11]),
    .o_ab_r         (x_z8_r[11]),
    .i_ac_v         (x_z8_v[12]),
    .i_ac_d         (x_z8_d[12]),
    .o_ac_r         (x_z8_r[12]),
    .i_ad_v         (x_z8_v[13]),
    .i_ad_d         (x_z8_d[13]),
    .o_ad_r         (x_z8_r[13]),
    .i_ae_v         (x_z8_v[14]),
    .i_ae_d         (x_z8_d[14]),
    .o_ae_r         (x_z8_r[14]),
    .i_af_v         (x_z8_v[15]),
    .i_af_d         (x_z8_d[15]),
    .o_af_r         (x_z8_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (z8_s),
    .o_s_r          (),
    .o_z_v          (o_z8_v),
    .o_z_d          (o_z8_d),
    .i_z_r          (i_z8_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z9_v[0:RATIO-1];
wire    [N-1:0] x_z9_d[0:RATIO-1];
wire            x_z9_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_z9 (
    .clk            (clk),
    .i_a0_v         (x_z9_v[0]),
    .i_a0_d         (x_z9_d[0]),
    .o_a0_r         (x_z9_r[0]),
    .i_a1_v         (x_z9_v[1]),
    .i_a1_d         (x_z9_d[1]),
    .o_a1_r         (x_z9_r[1]),
    .i_a2_v         (x_z9_v[2]),
    .i_a2_d         (x_z9_d[2]),
    .o_a2_r         (x_z9_r[2]),
    .i_a3_v         (x_z9_v[3]),
    .i_a3_d         (x_z9_d[3]),
    .o_a3_r         (x_z9_r[3]),
    .i_a4_v         (x_z9_v[4]),
    .i_a4_d         (x_z9_d[4]),
    .o_a4_r         (x_z9_r[4]),
    .i_a5_v         (x_z9_v[5]),
    .i_a5_d         (x_z9_d[5]),
    .o_a5_r         (x_z9_r[5]),
    .i_a6_v         (x_z9_v[6]),
    .i_a6_d         (x_z9_d[6]),
    .o_a6_r         (x_z9_r[6]),
    .i_a7_v         (x_z9_v[7]),
    .i_a7_d         (x_z9_d[7]),
    .o_a7_r         (x_z9_r[7]),
    .i_a8_v         (x_z9_v[8]),
    .i_a8_d         (x_z9_d[8]),
    .o_a8_r         (x_z9_r[8]),
    .i_a9_v         (x_z9_v[9]),
    .i_a9_d         (x_z9_d[9]),
    .o_a9_r         (x_z9_r[9]),
    .i_aa_v         (x_z9_v[10]),
    .i_aa_d         (x_z9_d[10]),
    .o_aa_r         (x_z9_r[10]),
    .i_ab_v         (x_z9_v[11]),
    .i_ab_d         (x_z9_d[11]),
    .o_ab_r         (x_z9_r[11]),
    .i_ac_v         (x_z9_v[12]),
    .i_ac_d         (x_z9_d[12]),
    .o_ac_r         (x_z9_r[12]),
    .i_ad_v         (x_z9_v[13]),
    .i_ad_d         (x_z9_d[13]),
    .o_ad_r         (x_z9_r[13]),
    .i_ae_v         (x_z9_v[14]),
    .i_ae_d         (x_z9_d[14]),
    .o_ae_r         (x_z9_r[14]),
    .i_af_v         (x_z9_v[15]),
    .i_af_d         (x_z9_d[15]),
    .o_af_r         (x_z9_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (z9_s),
    .o_s_r          (),
    .o_z_v          (o_z9_v),
    .o_z_d          (o_z9_d),
    .i_z_r          (i_z9_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_za_v[0:RATIO-1];
wire    [N-1:0] x_za_d[0:RATIO-1];
wire            x_za_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_za (
    .clk            (clk),
    .i_a0_v         (x_za_v[0]),
    .i_a0_d         (x_za_d[0]),
    .o_a0_r         (x_za_r[0]),
    .i_a1_v         (x_za_v[1]),
    .i_a1_d         (x_za_d[1]),
    .o_a1_r         (x_za_r[1]),
    .i_a2_v         (x_za_v[2]),
    .i_a2_d         (x_za_d[2]),
    .o_a2_r         (x_za_r[2]),
    .i_a3_v         (x_za_v[3]),
    .i_a3_d         (x_za_d[3]),
    .o_a3_r         (x_za_r[3]),
    .i_a4_v         (x_za_v[4]),
    .i_a4_d         (x_za_d[4]),
    .o_a4_r         (x_za_r[4]),
    .i_a5_v         (x_za_v[5]),
    .i_a5_d         (x_za_d[5]),
    .o_a5_r         (x_za_r[5]),
    .i_a6_v         (x_za_v[6]),
    .i_a6_d         (x_za_d[6]),
    .o_a6_r         (x_za_r[6]),
    .i_a7_v         (x_za_v[7]),
    .i_a7_d         (x_za_d[7]),
    .o_a7_r         (x_za_r[7]),
    .i_a8_v         (x_za_v[8]),
    .i_a8_d         (x_za_d[8]),
    .o_a8_r         (x_za_r[8]),
    .i_a9_v         (x_za_v[9]),
    .i_a9_d         (x_za_d[9]),
    .o_a9_r         (x_za_r[9]),
    .i_aa_v         (x_za_v[10]),
    .i_aa_d         (x_za_d[10]),
    .o_aa_r         (x_za_r[10]),
    .i_ab_v         (x_za_v[11]),
    .i_ab_d         (x_za_d[11]),
    .o_ab_r         (x_za_r[11]),
    .i_ac_v         (x_za_v[12]),
    .i_ac_d         (x_za_d[12]),
    .o_ac_r         (x_za_r[12]),
    .i_ad_v         (x_za_v[13]),
    .i_ad_d         (x_za_d[13]),
    .o_ad_r         (x_za_r[13]),
    .i_ae_v         (x_za_v[14]),
    .i_ae_d         (x_za_d[14]),
    .o_ae_r         (x_za_r[14]),
    .i_af_v         (x_za_v[15]),
    .i_af_d         (x_za_d[15]),
    .o_af_r         (x_za_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (za_s),
    .o_s_r          (),
    .o_z_v          (o_za_v),
    .o_z_d          (o_za_d),
    .i_z_r          (i_za_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_zb_v[0:RATIO-1];
wire    [N-1:0] x_zb_d[0:RATIO-1];
wire            x_zb_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_zb (
    .clk            (clk),
    .i_a0_v         (x_zb_v[0]),
    .i_a0_d         (x_zb_d[0]),
    .o_a0_r         (x_zb_r[0]),
    .i_a1_v         (x_zb_v[1]),
    .i_a1_d         (x_zb_d[1]),
    .o_a1_r         (x_zb_r[1]),
    .i_a2_v         (x_zb_v[2]),
    .i_a2_d         (x_zb_d[2]),
    .o_a2_r         (x_zb_r[2]),
    .i_a3_v         (x_zb_v[3]),
    .i_a3_d         (x_zb_d[3]),
    .o_a3_r         (x_zb_r[3]),
    .i_a4_v         (x_zb_v[4]),
    .i_a4_d         (x_zb_d[4]),
    .o_a4_r         (x_zb_r[4]),
    .i_a5_v         (x_zb_v[5]),
    .i_a5_d         (x_zb_d[5]),
    .o_a5_r         (x_zb_r[5]),
    .i_a6_v         (x_zb_v[6]),
    .i_a6_d         (x_zb_d[6]),
    .o_a6_r         (x_zb_r[6]),
    .i_a7_v         (x_zb_v[7]),
    .i_a7_d         (x_zb_d[7]),
    .o_a7_r         (x_zb_r[7]),
    .i_a8_v         (x_zb_v[8]),
    .i_a8_d         (x_zb_d[8]),
    .o_a8_r         (x_zb_r[8]),
    .i_a9_v         (x_zb_v[9]),
    .i_a9_d         (x_zb_d[9]),
    .o_a9_r         (x_zb_r[9]),
    .i_aa_v         (x_zb_v[10]),
    .i_aa_d         (x_zb_d[10]),
    .o_aa_r         (x_zb_r[10]),
    .i_ab_v         (x_zb_v[11]),
    .i_ab_d         (x_zb_d[11]),
    .o_ab_r         (x_zb_r[11]),
    .i_ac_v         (x_zb_v[12]),
    .i_ac_d         (x_zb_d[12]),
    .o_ac_r         (x_zb_r[12]),
    .i_ad_v         (x_zb_v[13]),
    .i_ad_d         (x_zb_d[13]),
    .o_ad_r         (x_zb_r[13]),
    .i_ae_v         (x_zb_v[14]),
    .i_ae_d         (x_zb_d[14]),
    .o_ae_r         (x_zb_r[14]),
    .i_af_v         (x_zb_v[15]),
    .i_af_d         (x_zb_d[15]),
    .o_af_r         (x_zb_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (zb_s),
    .o_s_r          (),
    .o_z_v          (o_zb_v),
    .o_z_d          (o_zb_d),
    .i_z_r          (i_zb_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_zc_v[0:RATIO-1];
wire    [N-1:0] x_zc_d[0:RATIO-1];
wire            x_zc_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_zc (
    .clk            (clk),
    .i_a0_v         (x_zc_v[0]),
    .i_a0_d         (x_zc_d[0]),
    .o_a0_r         (x_zc_r[0]),
    .i_a1_v         (x_zc_v[1]),
    .i_a1_d         (x_zc_d[1]),
    .o_a1_r         (x_zc_r[1]),
    .i_a2_v         (x_zc_v[2]),
    .i_a2_d         (x_zc_d[2]),
    .o_a2_r         (x_zc_r[2]),
    .i_a3_v         (x_zc_v[3]),
    .i_a3_d         (x_zc_d[3]),
    .o_a3_r         (x_zc_r[3]),
    .i_a4_v         (x_zc_v[4]),
    .i_a4_d         (x_zc_d[4]),
    .o_a4_r         (x_zc_r[4]),
    .i_a5_v         (x_zc_v[5]),
    .i_a5_d         (x_zc_d[5]),
    .o_a5_r         (x_zc_r[5]),
    .i_a6_v         (x_zc_v[6]),
    .i_a6_d         (x_zc_d[6]),
    .o_a6_r         (x_zc_r[6]),
    .i_a7_v         (x_zc_v[7]),
    .i_a7_d         (x_zc_d[7]),
    .o_a7_r         (x_zc_r[7]),
    .i_a8_v         (x_zc_v[8]),
    .i_a8_d         (x_zc_d[8]),
    .o_a8_r         (x_zc_r[8]),
    .i_a9_v         (x_zc_v[9]),
    .i_a9_d         (x_zc_d[9]),
    .o_a9_r         (x_zc_r[9]),
    .i_aa_v         (x_zc_v[10]),
    .i_aa_d         (x_zc_d[10]),
    .o_aa_r         (x_zc_r[10]),
    .i_ab_v         (x_zc_v[11]),
    .i_ab_d         (x_zc_d[11]),
    .o_ab_r         (x_zc_r[11]),
    .i_ac_v         (x_zc_v[12]),
    .i_ac_d         (x_zc_d[12]),
    .o_ac_r         (x_zc_r[12]),
    .i_ad_v         (x_zc_v[13]),
    .i_ad_d         (x_zc_d[13]),
    .o_ad_r         (x_zc_r[13]),
    .i_ae_v         (x_zc_v[14]),
    .i_ae_d         (x_zc_d[14]),
    .o_ae_r         (x_zc_r[14]),
    .i_af_v         (x_zc_v[15]),
    .i_af_d         (x_zc_d[15]),
    .o_af_r         (x_zc_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (zc_s),
    .o_s_r          (),
    .o_z_v          (o_zc_v),
    .o_z_d          (o_zc_d),
    .i_z_r          (i_zc_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_zd_v[0:RATIO-1];
wire    [N-1:0] x_zd_d[0:RATIO-1];
wire            x_zd_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_zd (
    .clk            (clk),
    .i_a0_v         (x_zd_v[0]),
    .i_a0_d         (x_zd_d[0]),
    .o_a0_r         (x_zd_r[0]),
    .i_a1_v         (x_zd_v[1]),
    .i_a1_d         (x_zd_d[1]),
    .o_a1_r         (x_zd_r[1]),
    .i_a2_v         (x_zd_v[2]),
    .i_a2_d         (x_zd_d[2]),
    .o_a2_r         (x_zd_r[2]),
    .i_a3_v         (x_zd_v[3]),
    .i_a3_d         (x_zd_d[3]),
    .o_a3_r         (x_zd_r[3]),
    .i_a4_v         (x_zd_v[4]),
    .i_a4_d         (x_zd_d[4]),
    .o_a4_r         (x_zd_r[4]),
    .i_a5_v         (x_zd_v[5]),
    .i_a5_d         (x_zd_d[5]),
    .o_a5_r         (x_zd_r[5]),
    .i_a6_v         (x_zd_v[6]),
    .i_a6_d         (x_zd_d[6]),
    .o_a6_r         (x_zd_r[6]),
    .i_a7_v         (x_zd_v[7]),
    .i_a7_d         (x_zd_d[7]),
    .o_a7_r         (x_zd_r[7]),
    .i_a8_v         (x_zd_v[8]),
    .i_a8_d         (x_zd_d[8]),
    .o_a8_r         (x_zd_r[8]),
    .i_a9_v         (x_zd_v[9]),
    .i_a9_d         (x_zd_d[9]),
    .o_a9_r         (x_zd_r[9]),
    .i_aa_v         (x_zd_v[10]),
    .i_aa_d         (x_zd_d[10]),
    .o_aa_r         (x_zd_r[10]),
    .i_ab_v         (x_zd_v[11]),
    .i_ab_d         (x_zd_d[11]),
    .o_ab_r         (x_zd_r[11]),
    .i_ac_v         (x_zd_v[12]),
    .i_ac_d         (x_zd_d[12]),
    .o_ac_r         (x_zd_r[12]),
    .i_ad_v         (x_zd_v[13]),
    .i_ad_d         (x_zd_d[13]),
    .o_ad_r         (x_zd_r[13]),
    .i_ae_v         (x_zd_v[14]),
    .i_ae_d         (x_zd_d[14]),
    .o_ae_r         (x_zd_r[14]),
    .i_af_v         (x_zd_v[15]),
    .i_af_d         (x_zd_d[15]),
    .o_af_r         (x_zd_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (zd_s),
    .o_s_r          (),
    .o_z_v          (o_zd_v),
    .o_z_d          (o_zd_d),
    .i_z_r          (i_zd_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_ze_v[0:RATIO-1];
wire    [N-1:0] x_ze_d[0:RATIO-1];
wire            x_ze_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_ze (
    .clk            (clk),
    .i_a0_v         (x_ze_v[0]),
    .i_a0_d         (x_ze_d[0]),
    .o_a0_r         (x_ze_r[0]),
    .i_a1_v         (x_ze_v[1]),
    .i_a1_d         (x_ze_d[1]),
    .o_a1_r         (x_ze_r[1]),
    .i_a2_v         (x_ze_v[2]),
    .i_a2_d         (x_ze_d[2]),
    .o_a2_r         (x_ze_r[2]),
    .i_a3_v         (x_ze_v[3]),
    .i_a3_d         (x_ze_d[3]),
    .o_a3_r         (x_ze_r[3]),
    .i_a4_v         (x_ze_v[4]),
    .i_a4_d         (x_ze_d[4]),
    .o_a4_r         (x_ze_r[4]),
    .i_a5_v         (x_ze_v[5]),
    .i_a5_d         (x_ze_d[5]),
    .o_a5_r         (x_ze_r[5]),
    .i_a6_v         (x_ze_v[6]),
    .i_a6_d         (x_ze_d[6]),
    .o_a6_r         (x_ze_r[6]),
    .i_a7_v         (x_ze_v[7]),
    .i_a7_d         (x_ze_d[7]),
    .o_a7_r         (x_ze_r[7]),
    .i_a8_v         (x_ze_v[8]),
    .i_a8_d         (x_ze_d[8]),
    .o_a8_r         (x_ze_r[8]),
    .i_a9_v         (x_ze_v[9]),
    .i_a9_d         (x_ze_d[9]),
    .o_a9_r         (x_ze_r[9]),
    .i_aa_v         (x_ze_v[10]),
    .i_aa_d         (x_ze_d[10]),
    .o_aa_r         (x_ze_r[10]),
    .i_ab_v         (x_ze_v[11]),
    .i_ab_d         (x_ze_d[11]),
    .o_ab_r         (x_ze_r[11]),
    .i_ac_v         (x_ze_v[12]),
    .i_ac_d         (x_ze_d[12]),
    .o_ac_r         (x_ze_r[12]),
    .i_ad_v         (x_ze_v[13]),
    .i_ad_d         (x_ze_d[13]),
    .o_ad_r         (x_ze_r[13]),
    .i_ae_v         (x_ze_v[14]),
    .i_ae_d         (x_ze_d[14]),
    .o_ae_r         (x_ze_r[14]),
    .i_af_v         (x_ze_v[15]),
    .i_af_d         (x_ze_d[15]),
    .o_af_r         (x_ze_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (ze_s),
    .o_s_r          (),
    .o_z_v          (o_ze_v),
    .o_z_d          (o_ze_d),
    .i_z_r          (i_ze_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_zf_v[0:RATIO-1];
wire    [N-1:0] x_zf_d[0:RATIO-1];
wire            x_zf_r[0:RATIO-1];

cory_mux16 #(.N(N), .Q(Q)) u_mux_zf (
    .clk            (clk),
    .i_a0_v         (x_zf_v[0]),
    .i_a0_d         (x_zf_d[0]),
    .o_a0_r         (x_zf_r[0]),
    .i_a1_v         (x_zf_v[1]),
    .i_a1_d         (x_zf_d[1]),
    .o_a1_r         (x_zf_r[1]),
    .i_a2_v         (x_zf_v[2]),
    .i_a2_d         (x_zf_d[2]),
    .o_a2_r         (x_zf_r[2]),
    .i_a3_v         (x_zf_v[3]),
    .i_a3_d         (x_zf_d[3]),
    .o_a3_r         (x_zf_r[3]),
    .i_a4_v         (x_zf_v[4]),
    .i_a4_d         (x_zf_d[4]),
    .o_a4_r         (x_zf_r[4]),
    .i_a5_v         (x_zf_v[5]),
    .i_a5_d         (x_zf_d[5]),
    .o_a5_r         (x_zf_r[5]),
    .i_a6_v         (x_zf_v[6]),
    .i_a6_d         (x_zf_d[6]),
    .o_a6_r         (x_zf_r[6]),
    .i_a7_v         (x_zf_v[7]),
    .i_a7_d         (x_zf_d[7]),
    .o_a7_r         (x_zf_r[7]),
    .i_a8_v         (x_zf_v[8]),
    .i_a8_d         (x_zf_d[8]),
    .o_a8_r         (x_zf_r[8]),
    .i_a9_v         (x_zf_v[9]),
    .i_a9_d         (x_zf_d[9]),
    .o_a9_r         (x_zf_r[9]),
    .i_aa_v         (x_zf_v[10]),
    .i_aa_d         (x_zf_d[10]),
    .o_aa_r         (x_zf_r[10]),
    .i_ab_v         (x_zf_v[11]),
    .i_ab_d         (x_zf_d[11]),
    .o_ab_r         (x_zf_r[11]),
    .i_ac_v         (x_zf_v[12]),
    .i_ac_d         (x_zf_d[12]),
    .o_ac_r         (x_zf_r[12]),
    .i_ad_v         (x_zf_v[13]),
    .i_ad_d         (x_zf_d[13]),
    .o_ad_r         (x_zf_r[13]),
    .i_ae_v         (x_zf_v[14]),
    .i_ae_d         (x_zf_d[14]),
    .o_ae_r         (x_zf_r[14]),
    .i_af_v         (x_zf_v[15]),
    .i_af_d         (x_zf_d[15]),
    .o_af_r         (x_zf_r[15]),
    .i_s_v          (1'b1),
    .i_s_d          (zf_s),
    .o_s_r          (),
    .o_z_v          (o_zf_v),
    .o_z_d          (o_zf_d),
    .i_z_r          (i_zf_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
assign  x_z0_v [0]  = x_a0_v [0];
assign  x_z0_d [0]  = x_a0_d [0];
assign  x_a0_r [0]  = x_z0_r [0];

assign  x_z1_v [0]  = x_a0_v [1];
assign  x_z1_d [0]  = x_a0_d [1];
assign  x_a0_r [1]  = x_z1_r [0];

assign  x_z2_v [0]  = x_a0_v [2];
assign  x_z2_d [0]  = x_a0_d [2];
assign  x_a0_r [2]  = x_z2_r [0];

assign  x_z3_v [0]  = x_a0_v [3];
assign  x_z3_d [0]  = x_a0_d [3];
assign  x_a0_r [3]  = x_z3_r [0];

assign  x_z4_v [0]  = x_a0_v [4];
assign  x_z4_d [0]  = x_a0_d [4];
assign  x_a0_r [4]  = x_z4_r [0];

assign  x_z5_v [0]  = x_a0_v [5];
assign  x_z5_d [0]  = x_a0_d [5];
assign  x_a0_r [5]  = x_z5_r [0];

assign  x_z6_v [0]  = x_a0_v [6];
assign  x_z6_d [0]  = x_a0_d [6];
assign  x_a0_r [6]  = x_z6_r [0];

assign  x_z7_v [0]  = x_a0_v [7];
assign  x_z7_d [0]  = x_a0_d [7];
assign  x_a0_r [7]  = x_z7_r [0];

assign  x_z8_v [0]  = x_a0_v [8];
assign  x_z8_d [0]  = x_a0_d [8];
assign  x_a0_r [8]  = x_z8_r [0];

assign  x_z9_v [0]  = x_a0_v [9];
assign  x_z9_d [0]  = x_a0_d [9];
assign  x_a0_r [9]  = x_z9_r [0];

assign  x_za_v [0]  = x_a0_v [10];
assign  x_za_d [0]  = x_a0_d [10];
assign  x_a0_r [10] = x_za_r [0];

assign  x_zb_v [0]  = x_a0_v [11];
assign  x_zb_d [0]  = x_a0_d [11];
assign  x_a0_r [11] = x_zb_r [0];

assign  x_zc_v [0]  = x_a0_v [12];
assign  x_zc_d [0]  = x_a0_d [12];
assign  x_a0_r [12] = x_zc_r [0];

assign  x_zd_v [0]  = x_a0_v [13];
assign  x_zd_d [0]  = x_a0_d [13];
assign  x_a0_r [13] = x_zd_r [0];

assign  x_ze_v [0]  = x_a0_v [14];
assign  x_ze_d [0]  = x_a0_d [14];
assign  x_a0_r [14] = x_ze_r [0];

assign  x_zf_v [0]  = x_a0_v [15];
assign  x_zf_d [0]  = x_a0_d [15];
assign  x_a0_r [15] = x_zf_r [0];

//------------------------------------------------------------------------------
assign  x_z0_v [1]  = x_a1_v [0];
assign  x_z0_d [1]  = x_a1_d [0];
assign  x_a1_r [0]  = x_z0_r [1];

assign  x_z1_v [1]  = x_a1_v [1];
assign  x_z1_d [1]  = x_a1_d [1];
assign  x_a1_r [1]  = x_z1_r [1];

assign  x_z2_v [1]  = x_a1_v [2];
assign  x_z2_d [1]  = x_a1_d [2];
assign  x_a1_r [2]  = x_z2_r [1];

assign  x_z3_v [1]  = x_a1_v [3];
assign  x_z3_d [1]  = x_a1_d [3];
assign  x_a1_r [3]  = x_z3_r [1];

assign  x_z4_v [1]  = x_a1_v [4];
assign  x_z4_d [1]  = x_a1_d [4];
assign  x_a1_r [4]  = x_z4_r [1];

assign  x_z5_v [1]  = x_a1_v [5];
assign  x_z5_d [1]  = x_a1_d [5];
assign  x_a1_r [5]  = x_z5_r [1];

assign  x_z6_v [1]  = x_a1_v [6];
assign  x_z6_d [1]  = x_a1_d [6];
assign  x_a1_r [6]  = x_z6_r [1];

assign  x_z7_v [1]  = x_a1_v [7];
assign  x_z7_d [1]  = x_a1_d [7];
assign  x_a1_r [7]  = x_z7_r [1];

assign  x_z8_v [1]  = x_a1_v [8];
assign  x_z8_d [1]  = x_a1_d [8];
assign  x_a1_r [8]  = x_z8_r [1];

assign  x_z9_v [1]  = x_a1_v [9];
assign  x_z9_d [1]  = x_a1_d [9];
assign  x_a1_r [9]  = x_z9_r [1];

assign  x_za_v [1]  = x_a1_v [10];
assign  x_za_d [1]  = x_a1_d [10];
assign  x_a1_r [10] = x_za_r [1];

assign  x_zb_v [1]  = x_a1_v [11];
assign  x_zb_d [1]  = x_a1_d [11];
assign  x_a1_r [11] = x_zb_r [1];

assign  x_zc_v [1]  = x_a1_v [12];
assign  x_zc_d [1]  = x_a1_d [12];
assign  x_a1_r [12] = x_zc_r [1];

assign  x_zd_v [1]  = x_a1_v [13];
assign  x_zd_d [1]  = x_a1_d [13];
assign  x_a1_r [13] = x_zd_r [1];

assign  x_ze_v [1]  = x_a1_v [14];
assign  x_ze_d [1]  = x_a1_d [14];
assign  x_a1_r [14] = x_ze_r [1];

assign  x_zf_v [1]  = x_a1_v [15];
assign  x_zf_d [1]  = x_a1_d [15];
assign  x_a1_r [15] = x_zf_r [1];

//------------------------------------------------------------------------------
assign  x_z0_v [2]  = x_a2_v [0];
assign  x_z0_d [2]  = x_a2_d [0];
assign  x_a2_r [0]  = x_z0_r [2];

assign  x_z1_v [2]  = x_a2_v [1];
assign  x_z1_d [2]  = x_a2_d [1];
assign  x_a2_r [1]  = x_z1_r [2];

assign  x_z2_v [2]  = x_a2_v [2];
assign  x_z2_d [2]  = x_a2_d [2];
assign  x_a2_r [2]  = x_z2_r [2];

assign  x_z3_v [2]  = x_a2_v [3];
assign  x_z3_d [2]  = x_a2_d [3];
assign  x_a2_r [3]  = x_z3_r [2];

assign  x_z4_v [2]  = x_a2_v [4];
assign  x_z4_d [2]  = x_a2_d [4];
assign  x_a2_r [4]  = x_z4_r [2];

assign  x_z5_v [2]  = x_a2_v [5];
assign  x_z5_d [2]  = x_a2_d [5];
assign  x_a2_r [5]  = x_z5_r [2];

assign  x_z6_v [2]  = x_a2_v [6];
assign  x_z6_d [2]  = x_a2_d [6];
assign  x_a2_r [6]  = x_z6_r [2];

assign  x_z7_v [2]  = x_a2_v [7];
assign  x_z7_d [2]  = x_a2_d [7];
assign  x_a2_r [7]  = x_z7_r [2];

assign  x_z8_v [2]  = x_a2_v [8];
assign  x_z8_d [2]  = x_a2_d [8];
assign  x_a2_r [8]  = x_z8_r [2];

assign  x_z9_v [2]  = x_a2_v [9];
assign  x_z9_d [2]  = x_a2_d [9];
assign  x_a2_r [9]  = x_z9_r [2];

assign  x_za_v [2]  = x_a2_v [10];
assign  x_za_d [2]  = x_a2_d [10];
assign  x_a2_r [10] = x_za_r [2];

assign  x_zb_v [2]  = x_a2_v [11];
assign  x_zb_d [2]  = x_a2_d [11];
assign  x_a2_r [11] = x_zb_r [2];

assign  x_zc_v [2]  = x_a2_v [12];
assign  x_zc_d [2]  = x_a2_d [12];
assign  x_a2_r [12] = x_zc_r [2];

assign  x_zd_v [2]  = x_a2_v [13];
assign  x_zd_d [2]  = x_a2_d [13];
assign  x_a2_r [13] = x_zd_r [2];

assign  x_ze_v [2]  = x_a2_v [14];
assign  x_ze_d [2]  = x_a2_d [14];
assign  x_a2_r [14] = x_ze_r [2];

assign  x_zf_v [2]  = x_a2_v [15];
assign  x_zf_d [2]  = x_a2_d [15];
assign  x_a2_r [15] = x_zf_r [2];

//------------------------------------------------------------------------------
assign  x_z0_v [3]  = x_a3_v [0];
assign  x_z0_d [3]  = x_a3_d [0];
assign  x_a3_r [0]  = x_z0_r [3];

assign  x_z1_v [3]  = x_a3_v [1];
assign  x_z1_d [3]  = x_a3_d [1];
assign  x_a3_r [1]  = x_z1_r [3];

assign  x_z2_v [3]  = x_a3_v [2];
assign  x_z2_d [3]  = x_a3_d [2];
assign  x_a3_r [2]  = x_z2_r [3];

assign  x_z3_v [3]  = x_a3_v [3];
assign  x_z3_d [3]  = x_a3_d [3];
assign  x_a3_r [3]  = x_z3_r [3];

assign  x_z4_v [3]  = x_a3_v [4];
assign  x_z4_d [3]  = x_a3_d [4];
assign  x_a3_r [4]  = x_z4_r [3];

assign  x_z5_v [3]  = x_a3_v [5];
assign  x_z5_d [3]  = x_a3_d [5];
assign  x_a3_r [5]  = x_z5_r [3];

assign  x_z6_v [3]  = x_a3_v [6];
assign  x_z6_d [3]  = x_a3_d [6];
assign  x_a3_r [6]  = x_z6_r [3];

assign  x_z7_v [3]  = x_a3_v [7];
assign  x_z7_d [3]  = x_a3_d [7];
assign  x_a3_r [7]  = x_z7_r [3];

assign  x_z8_v [3]  = x_a3_v [8];
assign  x_z8_d [3]  = x_a3_d [8];
assign  x_a3_r [8]  = x_z8_r [3];

assign  x_z9_v [3]  = x_a3_v [9];
assign  x_z9_d [3]  = x_a3_d [9];
assign  x_a3_r [9]  = x_z9_r [3];

assign  x_za_v [3]  = x_a3_v [10];
assign  x_za_d [3]  = x_a3_d [10];
assign  x_a3_r [10] = x_za_r [3];

assign  x_zb_v [3]  = x_a3_v [11];
assign  x_zb_d [3]  = x_a3_d [11];
assign  x_a3_r [11] = x_zb_r [3];

assign  x_zc_v [3]  = x_a3_v [12];
assign  x_zc_d [3]  = x_a3_d [12];
assign  x_a3_r [12] = x_zc_r [3];

assign  x_zd_v [3]  = x_a3_v [13];
assign  x_zd_d [3]  = x_a3_d [13];
assign  x_a3_r [13] = x_zd_r [3];

assign  x_ze_v [3]  = x_a3_v [14];
assign  x_ze_d [3]  = x_a3_d [14];
assign  x_a3_r [14] = x_ze_r [3];

assign  x_zf_v [3]  = x_a3_v [15];
assign  x_zf_d [3]  = x_a3_d [15];
assign  x_a3_r [15]  = x_zf_r [3];

//------------------------------------------------------------------------------
assign  x_z0_v [4]  = x_a4_v [0];
assign  x_z0_d [4]  = x_a4_d [0];
assign  x_a4_r [0]  = x_z0_r [4];

assign  x_z1_v [4]  = x_a4_v [1];
assign  x_z1_d [4]  = x_a4_d [1];
assign  x_a4_r [1]  = x_z1_r [4];

assign  x_z2_v [4]  = x_a4_v [2];
assign  x_z2_d [4]  = x_a4_d [2];
assign  x_a4_r [2]  = x_z2_r [4];

assign  x_z3_v [4]  = x_a4_v [3];
assign  x_z3_d [4]  = x_a4_d [3];
assign  x_a4_r [3]  = x_z3_r [4];

assign  x_z4_v [4]  = x_a4_v [4];
assign  x_z4_d [4]  = x_a4_d [4];
assign  x_a4_r [4]  = x_z4_r [4];

assign  x_z5_v [4]  = x_a4_v [5];
assign  x_z5_d [4]  = x_a4_d [5];
assign  x_a4_r [5]  = x_z5_r [4];

assign  x_z6_v [4]  = x_a4_v [6];
assign  x_z6_d [4]  = x_a4_d [6];
assign  x_a4_r [6]  = x_z6_r [4];

assign  x_z7_v [4]  = x_a4_v [7];
assign  x_z7_d [4]  = x_a4_d [7];
assign  x_a4_r [7]  = x_z7_r [4];

assign  x_z8_v [4]  = x_a4_v [8];
assign  x_z8_d [4]  = x_a4_d [8];
assign  x_a4_r [8]  = x_z8_r [4];

assign  x_z9_v [4]  = x_a4_v [9];
assign  x_z9_d [4]  = x_a4_d [9];
assign  x_a4_r [9]  = x_z9_r [4];

assign  x_za_v [4]  = x_a4_v [10];
assign  x_za_d [4]  = x_a4_d [10];
assign  x_a4_r [10] = x_za_r [4];

assign  x_zb_v [4]  = x_a4_v [11];
assign  x_zb_d [4]  = x_a4_d [11];
assign  x_a4_r [11] = x_zb_r [4];

assign  x_zc_v [4]  = x_a4_v [12];
assign  x_zc_d [4]  = x_a4_d [12];
assign  x_a4_r [12]  = x_zc_r [4];

assign  x_zd_v [4]  = x_a4_v [13];
assign  x_zd_d [4]  = x_a4_d [13];
assign  x_a4_r [13] = x_zd_r [4];

assign  x_ze_v [4]  = x_a4_v [14];
assign  x_ze_d [4]  = x_a4_d [14];
assign  x_a4_r [14] = x_ze_r [4];

assign  x_zf_v [4]  = x_a4_v [15];
assign  x_zf_d [4]  = x_a4_d [15];
assign  x_a4_r [15] = x_zf_r [4];

//------------------------------------------------------------------------------
assign  x_z0_v [5]  = x_a5_v [0];
assign  x_z0_d [5]  = x_a5_d [0];
assign  x_a5_r [0]  = x_z0_r [5];

assign  x_z1_v [5]  = x_a5_v [1];
assign  x_z1_d [5]  = x_a5_d [1];
assign  x_a5_r [1]  = x_z1_r [5];

assign  x_z2_v [5]  = x_a5_v [2];
assign  x_z2_d [5]  = x_a5_d [2];
assign  x_a5_r [2]  = x_z2_r [5];

assign  x_z3_v [5]  = x_a5_v [3];
assign  x_z3_d [5]  = x_a5_d [3];
assign  x_a5_r [3]  = x_z3_r [5];

assign  x_z4_v [5]  = x_a5_v [4];
assign  x_z4_d [5]  = x_a5_d [4];
assign  x_a5_r [4]  = x_z4_r [5];

assign  x_z5_v [5]  = x_a5_v [5];
assign  x_z5_d [5]  = x_a5_d [5];
assign  x_a5_r [5]  = x_z5_r [5];

assign  x_z6_v [5]  = x_a5_v [6];
assign  x_z6_d [5]  = x_a5_d [6];
assign  x_a5_r [6]  = x_z6_r [5];

assign  x_z7_v [5]  = x_a5_v [7];
assign  x_z7_d [5]  = x_a5_d [7];
assign  x_a5_r [7]  = x_z7_r [5];

assign  x_z8_v [5]  = x_a5_v [8];
assign  x_z8_d [5]  = x_a5_d [8];
assign  x_a5_r [8]  = x_z8_r [5];

assign  x_z9_v [5]  = x_a5_v [9];
assign  x_z9_d [5]  = x_a5_d [9];
assign  x_a5_r [9]  = x_z9_r [5];

assign  x_za_v [5]  = x_a5_v [10];
assign  x_za_d [5]  = x_a5_d [10];
assign  x_a5_r [10] = x_za_r [5];

assign  x_zb_v [5]  = x_a5_v [11];
assign  x_zb_d [5]  = x_a5_d [11];
assign  x_a5_r [11] = x_zb_r [5];

assign  x_zc_v [5]  = x_a5_v [12];
assign  x_zc_d [5]  = x_a5_d [12];
assign  x_a5_r [12] = x_zc_r [5];

assign  x_zd_v [5]  = x_a5_v [13];
assign  x_zd_d [5]  = x_a5_d [13];
assign  x_a5_r [13] = x_zd_r [5];

assign  x_ze_v [5]  = x_a5_v [14];
assign  x_ze_d [5]  = x_a5_d [14];
assign  x_a5_r [14] = x_ze_r [5];

assign  x_zf_v [5]  = x_a5_v [15];
assign  x_zf_d [5]  = x_a5_d [15];
assign  x_a5_r [15] = x_zf_r [5];

//------------------------------------------------------------------------------
assign  x_z0_v [6]  = x_a6_v [0];
assign  x_z0_d [6]  = x_a6_d [0];
assign  x_a6_r [0]  = x_z0_r [6];

assign  x_z1_v [6]  = x_a6_v [1];
assign  x_z1_d [6]  = x_a6_d [1];
assign  x_a6_r [1]  = x_z1_r [6];

assign  x_z2_v [6]  = x_a6_v [2];
assign  x_z2_d [6]  = x_a6_d [2];
assign  x_a6_r [2]  = x_z2_r [6];

assign  x_z3_v [6]  = x_a6_v [3];
assign  x_z3_d [6]  = x_a6_d [3];
assign  x_a6_r [3]  = x_z3_r [6];

assign  x_z4_v [6]  = x_a6_v [4];
assign  x_z4_d [6]  = x_a6_d [4];
assign  x_a6_r [4]  = x_z4_r [6];

assign  x_z5_v [6]  = x_a6_v [5];
assign  x_z5_d [6]  = x_a6_d [5];
assign  x_a6_r [5]  = x_z5_r [6];

assign  x_z6_v [6]  = x_a6_v [6];
assign  x_z6_d [6]  = x_a6_d [6];
assign  x_a6_r [6]  = x_z6_r [6];

assign  x_z7_v [6]  = x_a6_v [7];
assign  x_z7_d [6]  = x_a6_d [7];
assign  x_a6_r [7]  = x_z7_r [6];

assign  x_z8_v [6]  = x_a6_v [8];
assign  x_z8_d [6]  = x_a6_d [8];
assign  x_a6_r [8]  = x_z8_r [6];

assign  x_z9_v [6]  = x_a6_v [9];
assign  x_z9_d [6]  = x_a6_d [9];
assign  x_a6_r [9]  = x_z9_r [6];

assign  x_za_v [6]  = x_a6_v [10];
assign  x_za_d [6]  = x_a6_d [10];
assign  x_a6_r [10] = x_za_r [6];

assign  x_zb_v [6]  = x_a6_v [11];
assign  x_zb_d [6]  = x_a6_d [11];
assign  x_a6_r [11] = x_zb_r [6];

assign  x_zc_v [6]  = x_a6_v [12];
assign  x_zc_d [6]  = x_a6_d [12];
assign  x_a6_r [12] = x_zc_r [6];

assign  x_zd_v [6]  = x_a6_v [13];
assign  x_zd_d [6]  = x_a6_d [13];
assign  x_a6_r [13] = x_zd_r [6];

assign  x_ze_v [6]  = x_a6_v [14];
assign  x_ze_d [6]  = x_a6_d [14];
assign  x_a6_r [14] = x_ze_r [6];

assign  x_zf_v [6]  = x_a6_v [15];
assign  x_zf_d [6]  = x_a6_d [15];
assign  x_a6_r [15] = x_zf_r [6];

//------------------------------------------------------------------------------
assign  x_z0_v [7]  = x_a7_v [0];
assign  x_z0_d [7]  = x_a7_d [0];
assign  x_a7_r [0]  = x_z0_r [7];

assign  x_z1_v [7]  = x_a7_v [1];
assign  x_z1_d [7]  = x_a7_d [1];
assign  x_a7_r [1]  = x_z1_r [7];

assign  x_z2_v [7]  = x_a7_v [2];
assign  x_z2_d [7]  = x_a7_d [2];
assign  x_a7_r [2]  = x_z2_r [7];

assign  x_z3_v [7]  = x_a7_v [3];
assign  x_z3_d [7]  = x_a7_d [3];
assign  x_a7_r [3]  = x_z3_r [7];

assign  x_z4_v [7]  = x_a7_v [4];
assign  x_z4_d [7]  = x_a7_d [4];
assign  x_a7_r [4]  = x_z4_r [7];

assign  x_z5_v [7]  = x_a7_v [5];
assign  x_z5_d [7]  = x_a7_d [5];
assign  x_a7_r [5]  = x_z5_r [7];

assign  x_z6_v [7]  = x_a7_v [6];
assign  x_z6_d [7]  = x_a7_d [6];
assign  x_a7_r [6]  = x_z6_r [7];

assign  x_z7_v [7]  = x_a7_v [7];
assign  x_z7_d [7]  = x_a7_d [7];
assign  x_a7_r [7]  = x_z7_r [7];

assign  x_z8_v [7]  = x_a7_v [8];
assign  x_z8_d [7]  = x_a7_d [8];
assign  x_a7_r [8]  = x_z8_r [7];

assign  x_z9_v [7]  = x_a7_v [9];
assign  x_z9_d [7]  = x_a7_d [9];
assign  x_a7_r [9]  = x_z9_r [7];

assign  x_za_v [7]  = x_a7_v [10];
assign  x_za_d [7]  = x_a7_d [10];
assign  x_a7_r [10] = x_za_r [7];

assign  x_zb_v [7]  = x_a7_v [11];
assign  x_zb_d [7]  = x_a7_d [11];
assign  x_a7_r [11] = x_zb_r [7];

assign  x_zc_v [7]  = x_a7_v [12];
assign  x_zc_d [7]  = x_a7_d [12];
assign  x_a7_r [12] = x_zc_r [7];

assign  x_zd_v [7]  = x_a7_v [13];
assign  x_zd_d [7]  = x_a7_d [13];
assign  x_a7_r [13] = x_zd_r [7];

assign  x_ze_v [7]  = x_a7_v [14];
assign  x_ze_d [7]  = x_a7_d [14];
assign  x_a7_r [14] = x_ze_r [7];

assign  x_zf_v [7]  = x_a7_v [15];
assign  x_zf_d [7]  = x_a7_d [15];
assign  x_a7_r [15] = x_zf_r [7];

//------------------------------------------------------------------------------
assign  x_z0_v [8]  = x_a8_v [0];
assign  x_z0_d [8]  = x_a8_d [0];
assign  x_a8_r [0]  = x_z0_r [8];

assign  x_z1_v [8]  = x_a8_v [1];
assign  x_z1_d [8]  = x_a8_d [1];
assign  x_a8_r [1]  = x_z1_r [8];

assign  x_z2_v [8]  = x_a8_v [2];
assign  x_z2_d [8]  = x_a8_d [2];
assign  x_a8_r [2]  = x_z2_r [8];

assign  x_z3_v [8]  = x_a8_v [3];
assign  x_z3_d [8]  = x_a8_d [3];
assign  x_a8_r [3]  = x_z3_r [8];

assign  x_z4_v [8]  = x_a8_v [4];
assign  x_z4_d [8]  = x_a8_d [4];
assign  x_a8_r [4]  = x_z4_r [8];

assign  x_z5_v [8]  = x_a8_v [5];
assign  x_z5_d [8]  = x_a8_d [5];
assign  x_a8_r [5]  = x_z5_r [8];

assign  x_z6_v [8]  = x_a8_v [6];
assign  x_z6_d [8]  = x_a8_d [6];
assign  x_a8_r [6]  = x_z6_r [8];

assign  x_z7_v [8]  = x_a8_v [7];
assign  x_z7_d [8]  = x_a8_d [7];
assign  x_a8_r [7]  = x_z7_r [8];

assign  x_z8_v [8]  = x_a8_v [8];
assign  x_z8_d [8]  = x_a8_d [8];
assign  x_a8_r [8]  = x_z8_r [8];

assign  x_z9_v [8]  = x_a8_v [9];
assign  x_z9_d [8]  = x_a8_d [9];
assign  x_a8_r [9]  = x_z9_r [8];

assign  x_za_v [8]  = x_a8_v [10];
assign  x_za_d [8]  = x_a8_d [10];
assign  x_a8_r [10] = x_za_r [8];

assign  x_zb_v [8]  = x_a8_v [11];
assign  x_zb_d [8]  = x_a8_d [11];
assign  x_a8_r [11] = x_zb_r [8];

assign  x_zc_v [8]  = x_a8_v [12];
assign  x_zc_d [8]  = x_a8_d [12];
assign  x_a8_r [12] = x_zc_r [8];

assign  x_zd_v [8]  = x_a8_v [13];
assign  x_zd_d [8]  = x_a8_d [13];
assign  x_a8_r [13] = x_zd_r [8];

assign  x_ze_v [8]  = x_a8_v [14];
assign  x_ze_d [8]  = x_a8_d [14];
assign  x_a8_r [14] = x_ze_r [8];

assign  x_zf_v [8]  = x_a8_v [15];
assign  x_zf_d [8]  = x_a8_d [15];
assign  x_a8_r [15] = x_zf_r [8];

//------------------------------------------------------------------------------
assign  x_z0_v [9]  = x_a9_v [0];
assign  x_z0_d [9]  = x_a9_d [0];
assign  x_a9_r [0]  = x_z0_r [9];

assign  x_z1_v [9]  = x_a9_v [1];
assign  x_z1_d [9]  = x_a9_d [1];
assign  x_a9_r [1]  = x_z1_r [9];

assign  x_z2_v [9]  = x_a9_v [2];
assign  x_z2_d [9]  = x_a9_d [2];
assign  x_a9_r [2]  = x_z2_r [9];

assign  x_z3_v [9]  = x_a9_v [3];
assign  x_z3_d [9]  = x_a9_d [3];
assign  x_a9_r [3]  = x_z3_r [9];

assign  x_z4_v [9]  = x_a9_v [4];
assign  x_z4_d [9]  = x_a9_d [4];
assign  x_a9_r [4]  = x_z4_r [9];

assign  x_z5_v [9]  = x_a9_v [5];
assign  x_z5_d [9]  = x_a9_d [5];
assign  x_a9_r [5]  = x_z5_r [9];

assign  x_z6_v [9]  = x_a9_v [6];
assign  x_z6_d [9]  = x_a9_d [6];
assign  x_a9_r [6]  = x_z6_r [9];

assign  x_z7_v [9]  = x_a9_v [7];
assign  x_z7_d [9]  = x_a9_d [7];
assign  x_a9_r [7]  = x_z7_r [9];

assign  x_z8_v [9]  = x_a9_v [8];
assign  x_z8_d [9]  = x_a9_d [8];
assign  x_a9_r [8]  = x_z8_r [9];

assign  x_z9_v [9]  = x_a9_v [9];
assign  x_z9_d [9]  = x_a9_d [9];
assign  x_a9_r [9]  = x_z9_r [9];

assign  x_za_v [9]  = x_a9_v [10];
assign  x_za_d [9]  = x_a9_d [10];
assign  x_a9_r [10] = x_za_r [9];

assign  x_zb_v [9]  = x_a9_v [11];
assign  x_zb_d [9]  = x_a9_d [11];
assign  x_a9_r [11] = x_zb_r [9];

assign  x_zc_v [9]  = x_a9_v [12];
assign  x_zc_d [9]  = x_a9_d [12];
assign  x_a9_r [12] = x_zc_r [9];

assign  x_zd_v [9]  = x_a9_v [13];
assign  x_zd_d [9]  = x_a9_d [13];
assign  x_a9_r [13] = x_zd_r [9];

assign  x_ze_v [9]  = x_a9_v [14];
assign  x_ze_d [9]  = x_a9_d [14];
assign  x_a9_r [14] = x_ze_r [9];

assign  x_zf_v [9]  = x_a9_v [15];
assign  x_zf_d [9]  = x_a9_d [15];
assign  x_a9_r [15] = x_zf_r [9];

//------------------------------------------------------------------------------
assign  x_z0_v [10] = x_aa_v [0];
assign  x_z0_d [10] = x_aa_d [0];
assign  x_aa_r [0]  = x_z0_r [10];

assign  x_z1_v [10] = x_aa_v [1];
assign  x_z1_d [10] = x_aa_d [1];
assign  x_aa_r [1]  = x_z1_r [10];

assign  x_z2_v [10] = x_aa_v [2];
assign  x_z2_d [10] = x_aa_d [2];
assign  x_aa_r [2]  = x_z2_r [10];

assign  x_z3_v [10] = x_aa_v [3];
assign  x_z3_d [10] = x_aa_d [3];
assign  x_aa_r [3]  = x_z3_r [10];

assign  x_z4_v [10] = x_aa_v [4];
assign  x_z4_d [10] = x_aa_d [4];
assign  x_aa_r [4]  = x_z4_r [10];

assign  x_z5_v [10] = x_aa_v [5];
assign  x_z5_d [10] = x_aa_d [5];
assign  x_aa_r [5]  = x_z5_r [10];

assign  x_z6_v [10] = x_aa_v [6];
assign  x_z6_d [10] = x_aa_d [6];
assign  x_aa_r [6]  = x_z6_r [10];

assign  x_z7_v [10] = x_aa_v [7];
assign  x_z7_d [10] = x_aa_d [7];
assign  x_aa_r [7]  = x_z7_r [10];

assign  x_z8_v [10] = x_aa_v [8];
assign  x_z8_d [10] = x_aa_d [8];
assign  x_aa_r [8]  = x_z8_r [10];

assign  x_z9_v [10] = x_aa_v [9];
assign  x_z9_d [10] = x_aa_d [9];
assign  x_aa_r [9]  = x_z9_r [10];

assign  x_za_v [10] = x_aa_v [10];
assign  x_za_d [10] = x_aa_d [10];
assign  x_aa_r [10] = x_za_r [10];

assign  x_zb_v [10] = x_aa_v [11];
assign  x_zb_d [10] = x_aa_d [11];
assign  x_aa_r [11] = x_zb_r [10];

assign  x_zc_v [10] = x_aa_v [12];
assign  x_zc_d [10] = x_aa_d [12];
assign  x_aa_r [12] = x_zc_r [10];

assign  x_zd_v [10] = x_aa_v [13];
assign  x_zd_d [10] = x_aa_d [13];
assign  x_aa_r [13] = x_zd_r [10];

assign  x_ze_v [10] = x_aa_v [14];
assign  x_ze_d [10] = x_aa_d [14];
assign  x_aa_r [14] = x_ze_r [10];

assign  x_zf_v [10] = x_aa_v [15];
assign  x_zf_d [10] = x_aa_d [15];
assign  x_aa_r [15] = x_zf_r [10];

//------------------------------------------------------------------------------
assign  x_z0_v [11] = x_ab_v [0];
assign  x_z0_d [11] = x_ab_d [0];
assign  x_ab_r [0]  = x_z0_r [11];

assign  x_z1_v [11] = x_ab_v [1];
assign  x_z1_d [11] = x_ab_d [1];
assign  x_ab_r [1]  = x_z1_r [11];

assign  x_z2_v [11] = x_ab_v [2];
assign  x_z2_d [11] = x_ab_d [2];
assign  x_ab_r [2]  = x_z2_r [11];

assign  x_z3_v [11] = x_ab_v [3];
assign  x_z3_d [11] = x_ab_d [3];
assign  x_ab_r [3]  = x_z3_r [11];

assign  x_z4_v [11] = x_ab_v [4];
assign  x_z4_d [11] = x_ab_d [4];
assign  x_ab_r [4]  = x_z4_r [11];

assign  x_z5_v [11] = x_ab_v [5];
assign  x_z5_d [11] = x_ab_d [5];
assign  x_ab_r [5]  = x_z5_r [11];

assign  x_z6_v [11] = x_ab_v [6];
assign  x_z6_d [11] = x_ab_d [6];
assign  x_ab_r [6]  = x_z6_r [11];

assign  x_z7_v [11] = x_ab_v [7];
assign  x_z7_d [11] = x_ab_d [7];
assign  x_ab_r [7]  = x_z7_r [11];

assign  x_z8_v [11] = x_ab_v [8];
assign  x_z8_d [11] = x_ab_d [8];
assign  x_ab_r [8]  = x_z8_r [11];

assign  x_z9_v [11] = x_ab_v [9];
assign  x_z9_d [11] = x_ab_d [9];
assign  x_ab_r [9]  = x_z9_r [11];

assign  x_za_v [11] = x_ab_v [10];
assign  x_za_d [11] = x_ab_d [10];
assign  x_ab_r [10] = x_za_r [11];

assign  x_zb_v [11] = x_ab_v [11];
assign  x_zb_d [11] = x_ab_d [11];
assign  x_ab_r [11] = x_zb_r [11];

assign  x_zc_v [11] = x_ab_v [12];
assign  x_zc_d [11] = x_ab_d [12];
assign  x_ab_r [12] = x_zc_r [11];

assign  x_zd_v [11] = x_ab_v [13];
assign  x_zd_d [11] = x_ab_d [13];
assign  x_ab_r [13] = x_zd_r [11];

assign  x_ze_v [11] = x_ab_v [14];
assign  x_ze_d [11] = x_ab_d [14];
assign  x_ab_r [14] = x_ze_r [11];

assign  x_zf_v [11] = x_ab_v [15];
assign  x_zf_d [11] = x_ab_d [15];
assign  x_ab_r [15] = x_zf_r [11];

//------------------------------------------------------------------------------
assign  x_z0_v [12] = x_ac_v [0];
assign  x_z0_d [12] = x_ac_d [0];
assign  x_ac_r [0]  = x_z0_r [12];

assign  x_z1_v [12] = x_ac_v [1];
assign  x_z1_d [12] = x_ac_d [1];
assign  x_ac_r [1]  = x_z1_r [12];

assign  x_z2_v [12] = x_ac_v [2];
assign  x_z2_d [12] = x_ac_d [2];
assign  x_ac_r [2]  = x_z2_r [12];

assign  x_z3_v [12] = x_ac_v [3];
assign  x_z3_d [12] = x_ac_d [3];
assign  x_ac_r [3]  = x_z3_r [12];

assign  x_z4_v [12] = x_ac_v [4];
assign  x_z4_d [12] = x_ac_d [4];
assign  x_ac_r [4]  = x_z4_r [12];

assign  x_z5_v [12] = x_ac_v [5];
assign  x_z5_d [12] = x_ac_d [5];
assign  x_ac_r [5]  = x_z5_r [12];

assign  x_z6_v [12] = x_ac_v [6];
assign  x_z6_d [12] = x_ac_d [6];
assign  x_ac_r [6]  = x_z6_r [12];

assign  x_z7_v [12] = x_ac_v [7];
assign  x_z7_d [12] = x_ac_d [7];
assign  x_ac_r [7]  = x_z7_r [12];

assign  x_z8_v [12] = x_ac_v [8];
assign  x_z8_d [12] = x_ac_d [8];
assign  x_ac_r [8]  = x_z8_r [12];

assign  x_z9_v [12] = x_ac_v [9];
assign  x_z9_d [12] = x_ac_d [9];
assign  x_ac_r [9]  = x_z9_r [12];

assign  x_za_v [12] = x_ac_v [10];
assign  x_za_d [12] = x_ac_d [10];
assign  x_ac_r [10] = x_za_r [12];

assign  x_zb_v [12] = x_ac_v [11];
assign  x_zb_d [12] = x_ac_d [11];
assign  x_ac_r [11] = x_zb_r [12];

assign  x_zc_v [12] = x_ac_v [12];
assign  x_zc_d [12] = x_ac_d [12];
assign  x_ac_r [12] = x_zc_r [12];

assign  x_zd_v [12] = x_ac_v [13];
assign  x_zd_d [12] = x_ac_d [13];
assign  x_ac_r [13] = x_zd_r [12];

assign  x_ze_v [12] = x_ac_v [14];
assign  x_ze_d [12] = x_ac_d [14];
assign  x_ac_r [14] = x_ze_r [12];

assign  x_zf_v [12] = x_ac_v [15];
assign  x_zf_d [12] = x_ac_d [15];
assign  x_ac_r [15] = x_zf_r [12];

//------------------------------------------------------------------------------
assign  x_z0_v [13] = x_ad_v [0];
assign  x_z0_d [13] = x_ad_d [0];
assign  x_ad_r [0]  = x_z0_r [13];

assign  x_z1_v [13] = x_ad_v [1];
assign  x_z1_d [13] = x_ad_d [1];
assign  x_ad_r [1]  = x_z1_r [13];

assign  x_z2_v [13] = x_ad_v [2];
assign  x_z2_d [13] = x_ad_d [2];
assign  x_ad_r [2]  = x_z2_r [13];

assign  x_z3_v [13] = x_ad_v [3];
assign  x_z3_d [13] = x_ad_d [3];
assign  x_ad_r [3]  = x_z3_r [13];

assign  x_z4_v [13] = x_ad_v [4];
assign  x_z4_d [13] = x_ad_d [4];
assign  x_ad_r [4]  = x_z4_r [13];

assign  x_z5_v [13] = x_ad_v [5];
assign  x_z5_d [13] = x_ad_d [5];
assign  x_ad_r [5]  = x_z5_r [13];

assign  x_z6_v [13] = x_ad_v [6];
assign  x_z6_d [13] = x_ad_d [6];
assign  x_ad_r [6]  = x_z6_r [13];

assign  x_z7_v [13] = x_ad_v [7];
assign  x_z7_d [13] = x_ad_d [7];
assign  x_ad_r [7]  = x_z7_r [13];

assign  x_z8_v [13] = x_ad_v [8];
assign  x_z8_d [13] = x_ad_d [8];
assign  x_ad_r [8]  = x_z8_r [13];

assign  x_z9_v [13] = x_ad_v [9];
assign  x_z9_d [13] = x_ad_d [9];
assign  x_ad_r [9]  = x_z9_r [13];

assign  x_za_v [13] = x_ad_v [10];
assign  x_za_d [13] = x_ad_d [10];
assign  x_ad_r [10] = x_za_r [13];

assign  x_zb_v [13] = x_ad_v [11];
assign  x_zb_d [13] = x_ad_d [11];
assign  x_ad_r [11] = x_zb_r [13];

assign  x_zc_v [13] = x_ad_v [12];
assign  x_zc_d [13] = x_ad_d [12];
assign  x_ad_r [12] = x_zc_r [13];

assign  x_zd_v [13] = x_ad_v [13];
assign  x_zd_d [13] = x_ad_d [13];
assign  x_ad_r [13] = x_zd_r [13];

assign  x_ze_v [13] = x_ad_v [14];
assign  x_ze_d [13] = x_ad_d [14];
assign  x_ad_r [14] = x_ze_r [13];

assign  x_zf_v [13] = x_ad_v [15];
assign  x_zf_d [13] = x_ad_d [15];
assign  x_ad_r [15] = x_zf_r [13];

//------------------------------------------------------------------------------
assign  x_z0_v [14] = x_ae_v [0];
assign  x_z0_d [14] = x_ae_d [0];
assign  x_ae_r [0]  = x_z0_r [14];

assign  x_z1_v [14] = x_ae_v [1];
assign  x_z1_d [14] = x_ae_d [1];
assign  x_ae_r [1]  = x_z1_r [14];

assign  x_z2_v [14] = x_ae_v [2];
assign  x_z2_d [14] = x_ae_d [2];
assign  x_ae_r [2]  = x_z2_r [14];

assign  x_z3_v [14] = x_ae_v [3];
assign  x_z3_d [14] = x_ae_d [3];
assign  x_ae_r [3]  = x_z3_r [14];

assign  x_z4_v [14] = x_ae_v [4];
assign  x_z4_d [14] = x_ae_d [4];
assign  x_ae_r [4]  = x_z4_r [14];

assign  x_z5_v [14] = x_ae_v [5];
assign  x_z5_d [14] = x_ae_d [5];
assign  x_ae_r [5]  = x_z5_r [14];

assign  x_z6_v [14] = x_ae_v [6];
assign  x_z6_d [14] = x_ae_d [6];
assign  x_ae_r [6]  = x_z6_r [14];

assign  x_z7_v [14] = x_ae_v [7];
assign  x_z7_d [14] = x_ae_d [7];
assign  x_ae_r [7]  = x_z7_r [14];

assign  x_z8_v [14] = x_ae_v [8];
assign  x_z8_d [14] = x_ae_d [8];
assign  x_ae_r [8]  = x_z8_r [14];

assign  x_z9_v [14] = x_ae_v [9];
assign  x_z9_d [14] = x_ae_d [9];
assign  x_ae_r [9]  = x_z9_r [14];

assign  x_za_v [14] = x_ae_v [10];
assign  x_za_d [14] = x_ae_d [10];
assign  x_ae_r [10] = x_za_r [14];

assign  x_zb_v [14] = x_ae_v [11];
assign  x_zb_d [14] = x_ae_d [11];
assign  x_ae_r [11] = x_zb_r [14];

assign  x_zc_v [14] = x_ae_v [12];
assign  x_zc_d [14] = x_ae_d [12];
assign  x_ae_r [12] = x_zc_r [14];

assign  x_zd_v [14] = x_ae_v [13];
assign  x_zd_d [14] = x_ae_d [13];
assign  x_ae_r [13] = x_zd_r [14];

assign  x_ze_v [14] = x_ae_v [14];
assign  x_ze_d [14] = x_ae_d [14];
assign  x_ae_r [14] = x_ze_r [14];

assign  x_zf_v [14] = x_ae_v [15];
assign  x_zf_d [14] = x_ae_d [15];
assign  x_ae_r [15] = x_zf_r [14];

//------------------------------------------------------------------------------
assign  x_z0_v [15] = x_af_v [0];
assign  x_z0_d [15] = x_af_d [0];
assign  x_af_r [0]  = x_z0_r [15];

assign  x_z1_v [15] = x_af_v [1];
assign  x_z1_d [15] = x_af_d [1];
assign  x_af_r [1]  = x_z1_r [15];

assign  x_z2_v [15] = x_af_v [2];
assign  x_z2_d [15] = x_af_d [2];
assign  x_af_r [2]  = x_z2_r [15];

assign  x_z3_v [15] = x_af_v [3];
assign  x_z3_d [15] = x_af_d [3];
assign  x_af_r [3]  = x_z3_r [15];

assign  x_z4_v [15] = x_af_v [4];
assign  x_z4_d [15] = x_af_d [4];
assign  x_af_r [4]  = x_z4_r [15];

assign  x_z5_v [15] = x_af_v [5];
assign  x_z5_d [15] = x_af_d [5];
assign  x_af_r [5]  = x_z5_r [15];

assign  x_z6_v [15] = x_af_v [6];
assign  x_z6_d [15] = x_af_d [6];
assign  x_af_r [6]  = x_z6_r [15];

assign  x_z7_v [15] = x_af_v [7];
assign  x_z7_d [15] = x_af_d [7];
assign  x_af_r [7]  = x_z7_r [15];

assign  x_z8_v [15] = x_af_v [8];
assign  x_z8_d [15] = x_af_d [8];
assign  x_af_r [8]  = x_z8_r [15];

assign  x_z9_v [15] = x_af_v [9];
assign  x_z9_d [15] = x_af_d [9];
assign  x_af_r [9]  = x_z9_r [15];

assign  x_za_v [15] = x_af_v [10];
assign  x_za_d [15] = x_af_d [10];
assign  x_af_r [10] = x_za_r [15];

assign  x_zb_v [15] = x_af_v [11];
assign  x_zb_d [15] = x_af_d [11];
assign  x_af_r [11] = x_zb_r [15];

assign  x_zc_v [15] = x_af_v [12];
assign  x_zc_d [15] = x_af_d [12];
assign  x_af_r [12] = x_zc_r [15];

assign  x_zd_v [15] = x_af_v [13];
assign  x_zd_d [15] = x_af_d [13];
assign  x_af_r [13] = x_zd_r [15];

assign  x_ze_v [15] = x_af_v [14];
assign  x_ze_d [15] = x_af_d [14];
assign  x_af_r [14] = x_ze_r [15];

assign  x_zf_v [15] = x_af_v [15];
assign  x_zf_d [15] = x_af_d [15];
assign  x_af_r [15] = x_zf_r [15];

//------------------------------------------------------------------------------

`ifdef  SIM
    always @(posedge clk)
        if ((i_z0_s == i_z1_s) || (i_z0_s == i_z2_s) || (i_z0_s == i_z3_s) || (i_z0_s == i_z4_s) || (i_z0_s == i_z5_s) || (i_z0_s == i_z6_s) || (i_z0_s == i_z7_s) || (i_z0_s == i_z8_s) || (i_z0_s == i_z9_s) || (i_z0_s == i_za_s) || (i_z0_s == i_zb_s) || (i_z0_s == i_zc_s) || (i_z0_s == i_zd_s) || (i_z0_s == i_ze_s) || (i_z0_s == i_zf_s) ||
                                  (i_z1_s == i_z2_s) || (i_z1_s == i_z3_s) || (i_z1_s == i_z4_s) || (i_z1_s == i_z5_s) || (i_z1_s == i_z6_s) || (i_z1_s == i_z7_s) || (i_z1_s == i_z8_s) || (i_z1_s == i_z9_s) || (i_z1_s == i_za_s) || (i_z1_s == i_zb_s) || (i_z1_s == i_zc_s) || (i_z1_s == i_zd_s) || (i_z1_s == i_ze_s) || (i_z1_s == i_zf_s) ||
                                                        (i_z2_s == i_z3_s) || (i_z2_s == i_z4_s) || (i_z2_s == i_z5_s) || (i_z2_s == i_z6_s) || (i_z2_s == i_z7_s) || (i_z2_s == i_z8_s) || (i_z2_s == i_z9_s) || (i_z2_s == i_za_s) || (i_z2_s == i_zb_s) || (i_z2_s == i_zc_s) || (i_z2_s == i_zd_s) || (i_z2_s == i_ze_s) || (i_z2_s == i_zf_s) ||
                                                                              (i_z3_s == i_z4_s) || (i_z3_s == i_z5_s) || (i_z3_s == i_z6_s) || (i_z3_s == i_z7_s) || (i_z3_s == i_z8_s) || (i_z3_s == i_z9_s) || (i_z3_s == i_za_s) || (i_z3_s == i_zb_s) || (i_z3_s == i_zc_s) || (i_z3_s == i_zd_s) || (i_z3_s == i_ze_s) || (i_z3_s == i_zf_s) ||
                                                                                                    (i_z4_s == i_z5_s) || (i_z4_s == i_z6_s) || (i_z4_s == i_z7_s) || (i_z4_s == i_z8_s) || (i_z4_s == i_z9_s) || (i_z4_s == i_za_s) || (i_z4_s == i_zb_s) || (i_z4_s == i_zc_s) || (i_z4_s == i_zd_s) || (i_z4_s == i_ze_s) || (i_z4_s == i_zf_s) ||
                                                                                                                          (i_z5_s == i_z6_s) || (i_z5_s == i_z7_s) || (i_z5_s == i_z8_s) || (i_z5_s == i_z9_s) || (i_z5_s == i_za_s) || (i_z5_s == i_zb_s) || (i_z5_s == i_zc_s) || (i_z5_s == i_zd_s) || (i_z5_s == i_ze_s) || (i_z5_s == i_zf_s) ||
                                                                                                                                                (i_z6_s == i_z7_s) || (i_z6_s == i_z8_s) || (i_z6_s == i_z9_s) || (i_z6_s == i_za_s) || (i_z6_s == i_zb_s) || (i_z6_s == i_zc_s) || (i_z6_s == i_zd_s) || (i_z6_s == i_ze_s) || (i_z6_s == i_zf_s) ||
                                                                                                                                                                      (i_z7_s == i_z8_s) || (i_z7_s == i_z9_s) || (i_z7_s == i_za_s) || (i_z7_s == i_zb_s) || (i_z7_s == i_zc_s) || (i_z7_s == i_zd_s) || (i_z7_s == i_ze_s) || (i_z7_s == i_zf_s) ||
                                                                                                                                                                                            (i_z8_s == i_z9_s) || (i_z8_s == i_za_s) || (i_z8_s == i_zb_s) || (i_z8_s == i_zc_s) || (i_z8_s == i_zd_s) || (i_z8_s == i_ze_s) || (i_z8_s == i_zf_s) ||
                                                                                                                                                                                                                  (i_z9_s == i_za_s) || (i_z9_s == i_zb_s) || (i_z9_s == i_zc_s) || (i_z9_s == i_zd_s) || (i_z9_s == i_ze_s) || (i_z9_s == i_zf_s) ||
                                                                                                                                                                                                                                        (i_za_s == i_zb_s) || (i_za_s == i_zc_s) || (i_za_s == i_zd_s) || (i_za_s == i_ze_s) || (i_za_s == i_zf_s) ||
                                                                                                                                                                                                                                                              (i_zb_s == i_zc_s) || (i_zb_s == i_zd_s) || (i_zb_s == i_ze_s) || (i_zb_s == i_zf_s) ||
                                                                                                                                                                                                                                                                                    (i_zc_s == i_zd_s) || (i_zc_s == i_ze_s) || (i_zc_s == i_zf_s) ||
                                                                                                                                                                                                                                                                                                          (i_zd_s == i_ze_s) || (i_zd_s == i_zf_s) ||
                                                                                                                                                                                                                                                                                                                                (i_ze_s == i_zf_s)
        ) begin
            $display ("ERROR:%m: zx_s[0-15] = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d @ %t",
                i_z0_s, i_z1_s, i_z2_s, i_z3_s, i_z4_s, i_z5_s, i_z6_s, i_z7_s, i_z8_s, i_z9_s, i_za_s, i_zb_s, i_zc_s, i_zd_s, i_ze_s, i_zf_s,
                $time);
            $finish;
        end

`endif
endmodule

`endif
