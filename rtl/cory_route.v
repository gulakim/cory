//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_ROUTE
    `define CORY_ROUTE

//------------------------------------------------------------------------------
module cory_route # (
    parameter   N       = 8,
    parameter   S       = 1,                    // # bit for selector
    parameter   Q       = 0,
    parameter   QS      = 0,                    // must be static selector when 0
                                                // do not touch the parameters below
    parameter   R       = 2**S,                 // 2x2, 4x4, 8x8, 16x16
    parameter   D       = N * R,                // data width for all
    parameter   E       = S * R                 // # bit for all selector
) (
    input           clk,

    input   [S-1:0] i_a_v,
    input   [D-1:0] i_a_d,
    output  [S-1:0] o_a_r,

    output  [S-1:0] o_z_v,
    output  [D-1:0] o_z_d,
    input   [E-1:0] i_z_s,
    input   [S-1:0] i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
wire            a_v[0:R-1];
wire    [N-1:0] a_d[0:R-1];
wire            a_r[0:R-1];
wire            z_v[0:R-1];
wire    [N-1:0] z_d[0:R-1];
wire            z_r[0:R-1];
wire    [S-1:0] z_s[0:R-1];

generate
begin : g_route
    case (S)
    1: begin
        assign  {a_v[1], a_v[0]}    = i_a_v;
        assign  {a_d[1], a_d[0]}    = i_a_d;
        assign  o_a_r   = {a_r[1], a_r[0]};
        assign  o_z_v   = {z_v[1], z_v[0]};
        assign  o_z_d   = {z_d[1], z_d[0]};
        assign  {z_r[1], z_r[0]}    = i_z_r;
        assign  {z_s[1], z_s[0]}    = i_z_s;

        cory_route2 #(.N(N), .S(S), .QS(QS), .Q(Q)) u_route (
            .clk            (clk),
            .i_a0_v         (a_v[0]),
            .i_a0_d         (a_d[0]),
            .o_a0_r         (a_r[0]),
            .i_a1_v         (a_v[1]),
            .i_a1_d         (a_d[1]),
            .o_a1_r         (a_r[1]),
            .o_z0_v         (z_v[0]),
            .o_z0_d         (z_d[0]),
            .i_z0_r         (z_r[0]),
            .o_z1_v         (z_v[1]),
            .o_z1_d         (z_d[1]),
            .i_z1_r         (z_r[1]),
            .i_z0_s         (z_s[0]),
            .i_z1_s         (z_s[1]),
            .reset_n        (reset_n)
        );
    end
//------------------------------------------------------------------------------
    2: begin
        assign  {a_v[3], a_v[2], a_v[1], a_v[0]}    = i_a_v;
        assign  {a_d[3], a_d[2], a_d[1], a_d[0]}    = i_a_d;
        assign  o_a_r   = {a_r[3], a_r[2], a_r[1], a_r[0]};
        assign  o_z_v   = {z_v[3], z_v[2], z_v[1], z_v[0]};
        assign  o_z_d   = {z_d[3], z_d[2], z_d[1], z_d[0]};
        assign  {z_r[3], z_r[2], z_r[1], z_r[0]}    = i_z_r;
        assign  {z_s[3], z_s[2], z_s[1], z_s[0]}    = i_z_s;

        cory_route4 #(.N(N), .S(S), .QS(QS), .Q(Q)) u_route (
            .clk            (clk),
            .i_a0_v         (a_v[0]),
            .i_a0_d         (a_d[0]),
            .o_a0_r         (a_r[0]),
            .i_a1_v         (a_v[1]),
            .i_a1_d         (a_d[1]),
            .o_a1_r         (a_r[1]),
            .i_a2_v         (a_v[2]),
            .i_a2_d         (a_d[2]),
            .o_a2_r         (a_r[2]),
            .i_a3_v         (a_v[3]),
            .i_a3_d         (a_d[3]),
            .o_a3_r         (a_r[3]),
            .o_z0_v         (z_v[0]),
            .o_z0_d         (z_d[0]),
            .i_z0_r         (z_r[0]),
            .o_z1_v         (z_v[1]),
            .o_z1_d         (z_d[1]),
            .i_z1_r         (z_r[1]),
            .o_z2_v         (z_v[2]),
            .o_z2_d         (z_d[2]),
            .i_z2_r         (z_r[2]),
            .o_z3_v         (z_v[3]),
            .o_z3_d         (z_d[3]),
            .i_z3_r         (z_r[3]),
            .i_z0_s         (z_s[0]),
            .i_z1_s         (z_s[1]),
            .i_z2_s         (z_s[2]),
            .i_z3_s         (z_s[3]),
            .reset_n        (reset_n)
        );
    end
//------------------------------------------------------------------------------
    3: begin
        assign  {a_v[7], a_v[6], a_v[5], a_v[4], a_v[3], a_v[2], a_v[1], a_v[0]}    = i_a_v;
        assign  {a_d[7], a_d[6], a_d[5], a_d[4], a_d[3], a_d[2], a_d[1], a_d[0]}    = i_a_d;
        assign  o_a_r   = {a_r[7], a_r[6], a_r[5], a_r[4], a_r[3], a_r[2], a_r[1], a_r[0]};
        assign  o_z_v   = {z_v[7], z_v[6], z_v[5], z_v[4], z_v[3], z_v[2], z_v[1], z_v[0]};
        assign  o_z_d   = {z_d[7], z_d[6], z_d[5], z_d[4], z_d[3], z_d[2], z_d[1], z_d[0]};
        assign  {z_r[7], z_r[6], z_r[5], z_r[4], z_r[3], z_r[2], z_r[1], z_r[0]}    = i_z_r;
        assign  {z_s[7], z_s[6], z_s[5], z_s[4], z_s[3], z_s[2], z_s[1], z_s[0]}    = i_z_s;

        cory_route8 #(.N(N), .S(S), .QS(QS), .Q(Q)) u_route (
            .clk            (clk),
            .i_a0_v         (a_v[0]),
            .i_a0_d         (a_d[0]),
            .o_a0_r         (a_r[0]),
            .i_a1_v         (a_v[1]),
            .i_a1_d         (a_d[1]),
            .o_a1_r         (a_r[1]),
            .i_a2_v         (a_v[2]),
            .i_a2_d         (a_d[2]),
            .o_a2_r         (a_r[2]),
            .i_a3_v         (a_v[3]),
            .i_a3_d         (a_d[3]),
            .o_a3_r         (a_r[3]),
            .i_a4_v         (a_v[4]),
            .i_a4_d         (a_d[4]),
            .o_a4_r         (a_r[4]),
            .i_a5_v         (a_v[5]),
            .i_a5_d         (a_d[5]),
            .o_a5_r         (a_r[5]),
            .i_a6_v         (a_v[6]),
            .i_a6_d         (a_d[6]),
            .o_a6_r         (a_r[6]),
            .i_a7_v         (a_v[7]),
            .i_a7_d         (a_d[7]),
            .o_a7_r         (a_r[7]),
            .o_z0_v         (z_v[0]),
            .o_z0_d         (z_d[0]),
            .i_z0_r         (z_r[0]),
            .o_z1_v         (z_v[1]),
            .o_z1_d         (z_d[1]),
            .i_z1_r         (z_r[1]),
            .o_z2_v         (z_v[2]),
            .o_z2_d         (z_d[2]),
            .i_z2_r         (z_r[2]),
            .o_z3_v         (z_v[3]),
            .o_z3_d         (z_d[3]),
            .i_z3_r         (z_r[3]),
            .o_z4_v         (z_v[4]),
            .o_z4_d         (z_d[4]),
            .i_z4_r         (z_r[4]),
            .o_z5_v         (z_v[5]),
            .o_z5_d         (z_d[5]),
            .i_z5_r         (z_r[5]),
            .o_z6_v         (z_v[6]),
            .o_z6_d         (z_d[6]),
            .i_z6_r         (z_r[6]),
            .o_z7_v         (z_v[7]),
            .o_z7_d         (z_d[7]),
            .i_z7_r         (z_r[7]),
            .i_z0_s         (z_s[0]),
            .i_z1_s         (z_s[1]),
            .i_z2_s         (z_s[2]),
            .i_z3_s         (z_s[3]),
            .i_z4_s         (z_s[4]),
            .i_z5_s         (z_s[5]),
            .i_z6_s         (z_s[6]),
            .i_z7_s         (z_s[7]),
            .reset_n        (reset_n)
        );
    end
//------------------------------------------------------------------------------
    4: begin
        assign  {a_v[15], a_v[14], a_v[13], a_v[12], a_v[11], a_v[10], a_v[9], a_v[8],
                 a_v[7], a_v[6], a_v[5], a_v[4], a_v[3], a_v[2], a_v[1], a_v[0]}    = i_a_v;
        assign  {a_d[15], a_d[14], a_d[13], a_d[12], a_d[11], a_d[10], a_d[9], a_d[8],
                 a_d[7], a_d[6], a_d[5], a_d[4], a_d[3], a_d[2], a_d[1], a_d[0]}    = i_a_d;
        assign  o_a_r   = {a_r[15], a_r[14], a_r[13], a_r[12], a_r[11], a_r[10], a_r[9], a_r[8],
                           a_r[7], a_r[6], a_r[5], a_r[4], a_r[3], a_r[2], a_r[1], a_r[0]};
        assign  o_z_v   = {z_v[15], z_v[14], z_v[13], z_v[12], z_v[11], z_v[10], z_v[9], z_v[8],
                           z_v[7], z_v[6], z_v[5], z_v[4], z_v[3], z_v[2], z_v[1], z_v[0]};
        assign  o_z_d   = {z_d[15], z_d[14], z_d[13], z_d[12], z_d[11], z_d[10], z_d[9], z_d[8],
                           z_d[7], z_d[6], z_d[5], z_d[4], z_d[3], z_d[2], z_d[1], z_d[0]};
        assign  {z_r[15], z_r[14], z_r[13], z_r[12], z_r[11], z_r[10], z_r[9], z_r[8],
                 z_r[7], z_r[6], z_r[5], z_r[4], z_r[3], z_r[2], z_r[1], z_r[0]}    = i_z_r;
        assign  {z_s[15], z_s[14], z_s[13], z_s[12], z_s[11], z_s[10], z_s[9], z_s[8],
                 z_s[7], z_s[6], z_s[5], z_s[4], z_s[3], z_s[2], z_s[1], z_s[0]}    = i_z_s;

        cory_route16 #(.N(N), .S(S), .QS(QS), .Q(Q)) u_route (
            .clk            (clk),
            .i_a0_v         (a_v[0]),
            .i_a0_d         (a_d[0]),
            .o_a0_r         (a_r[0]),
            .i_a1_v         (a_v[1]),
            .i_a1_d         (a_d[1]),
            .o_a1_r         (a_r[1]),
            .i_a2_v         (a_v[2]),
            .i_a2_d         (a_d[2]),
            .o_a2_r         (a_r[2]),
            .i_a3_v         (a_v[3]),
            .i_a3_d         (a_d[3]),
            .o_a3_r         (a_r[3]),
            .i_a4_v         (a_v[4]),
            .i_a4_d         (a_d[4]),
            .o_a4_r         (a_r[4]),
            .i_a5_v         (a_v[5]),
            .i_a5_d         (a_d[5]),
            .o_a5_r         (a_r[5]),
            .i_a6_v         (a_v[6]),
            .i_a6_d         (a_d[6]),
            .o_a6_r         (a_r[6]),
            .i_a7_v         (a_v[7]),
            .i_a7_d         (a_d[7]),
            .o_a7_r         (a_r[7]),
            .i_a8_v         (a_v[8]),
            .i_a8_d         (a_d[8]),
            .o_a8_r         (a_r[8]),
            .i_a9_v         (a_v[9]),
            .i_a9_d         (a_d[9]),
            .o_a9_r         (a_r[9]),
            .i_aa_v         (a_v[10]),
            .i_aa_d         (a_d[10]),
            .o_aa_r         (a_r[10]),
            .i_ab_v         (a_v[11]),
            .i_ab_d         (a_d[11]),
            .o_ab_r         (a_r[11]),
            .i_ac_v         (a_v[12]),
            .i_ac_d         (a_d[12]),
            .o_ac_r         (a_r[12]),
            .i_ad_v         (a_v[13]),
            .i_ad_d         (a_d[13]),
            .o_ad_r         (a_r[13]),
            .i_ae_v         (a_v[14]),
            .i_ae_d         (a_d[14]),
            .o_ae_r         (a_r[14]),
            .i_af_v         (a_v[15]),
            .i_af_d         (a_d[15]),
            .o_af_r         (a_r[15]),
            .o_z0_v         (z_v[0]),
            .o_z0_d         (z_d[0]),
            .i_z0_r         (z_r[0]),
            .o_z1_v         (z_v[1]),
            .o_z1_d         (z_d[1]),
            .i_z1_r         (z_r[1]),
            .o_z2_v         (z_v[2]),
            .o_z2_d         (z_d[2]),
            .i_z2_r         (z_r[2]),
            .o_z3_v         (z_v[3]),
            .o_z3_d         (z_d[3]),
            .i_z3_r         (z_r[3]),
            .o_z4_v         (z_v[4]),
            .o_z4_d         (z_d[4]),
            .i_z4_r         (z_r[4]),
            .o_z5_v         (z_v[5]),
            .o_z5_d         (z_d[5]),
            .i_z5_r         (z_r[5]),
            .o_z6_v         (z_v[6]),
            .o_z6_d         (z_d[6]),
            .i_z6_r         (z_r[6]),
            .o_z7_v         (z_v[7]),
            .o_z7_d         (z_d[7]),
            .i_z7_r         (z_r[7]),
            .o_z8_v         (z_v[8]),
            .o_z8_d         (z_d[8]),
            .i_z8_r         (z_r[8]),
            .o_z9_v         (z_v[9]),
            .o_z9_d         (z_d[9]),
            .i_z9_r         (z_r[9]),
            .o_za_v         (z_v[10]),
            .o_za_d         (z_d[10]),
            .i_za_r         (z_r[10]),
            .o_zb_v         (z_v[11]),
            .o_zb_d         (z_d[11]),
            .i_zb_r         (z_r[11]),
            .o_zc_v         (z_v[12]),
            .o_zc_d         (z_d[12]),
            .i_zc_r         (z_r[12]),
            .o_zd_v         (z_v[13]),
            .o_zd_d         (z_d[13]),
            .i_zd_r         (z_r[13]),
            .o_ze_v         (z_v[14]),
            .o_ze_d         (z_d[14]),
            .i_ze_r         (z_r[14]),
            .o_zf_v         (z_v[15]),
            .o_zf_d         (z_d[15]),
            .i_zf_r         (z_r[15]),
            .i_z0_s         (z_s[0]),
            .i_z1_s         (z_s[1]),
            .i_z2_s         (z_s[2]),
            .i_z3_s         (z_s[3]),
            .i_z4_s         (z_s[4]),
            .i_z5_s         (z_s[5]),
            .i_z6_s         (z_s[6]),
            .i_z7_s         (z_s[7]),
            .i_z8_s         (z_s[8]),
            .i_z9_s         (z_s[9]),
            .i_za_s         (z_s[10]),
            .i_zb_s         (z_s[11]),
            .i_zc_s         (z_s[12]),
            .i_zd_s         (z_s[13]),
            .i_ze_s         (z_s[14]),
            .i_zf_s         (z_s[15]),
            .reset_n        (reset_n)
        );
    end
//------------------------------------------------------------------------------
`ifdef  SIM
    default: begin
        initial begin
            $display ("ERROR:%m: S(%1d) not supported", S);
            $finish;
        end
    end
`endif  //  SIM
    endcase
end
endgenerate

//------------------------------------------------------------------------------
`ifdef  SIM
    initial begin
        if (R != 2**S) begin
            $display ("ERROR:%m: 2^S(%1d) = R(%1d) expected, do not touch R", S, R);
            $finish;
        end
    end
`endif

endmodule

`endif
