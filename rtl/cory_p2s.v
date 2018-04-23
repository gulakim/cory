//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_P2S
    `define CORY_P2S

//------------------------------------------------------------------------------
//  wider data to narrower data
//------------------------------------------------------------------------------
module cory_p2s #(
    parameter   N   = 8,                        // number of bits for the smallest
    parameter   R   = 2,                        // ratio, 2,4,8,16
    parameter   A   = N * R,                    // number of bits for input
    parameter   Z   = N,                        // number of bits for output
    parameter   BS  = (1<=R && R<=2) ? 1 :
                      (3<=R && R<=4) ? 2 :
                      (5<=R && R<=8) ? 3 :
                      (9<=R && R<=16) ? 4 : 1'bx
) (
    input           clk,

    input           i_a_v,
    input   [A-1:0] i_a_d,
    output          o_a_r,

    output          o_z_v,
    output  [Z-1:0] o_z_d,
    output  [BS-1:0]o_z_s,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
wire            a_v[0:R-1];
wire    [N-1:0] a_d[0:R-1];
wire            a_r[0:R-1];

wire            z_v[0:R-1];
wire    [N-1:0] z_d[0:R-1];
wire            z_r[0:R-1];

wire            s_v;
wire    [BS-1:0]s_d;
wire            s_r;

reg     [BS-1:0]sel;

assign          o_z_s   = sel;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        sel <= 0;
    else if (s_v & s_r)
        if (sel == R-1)
            sel <= 0;
        else
            sel <= sel + 1;

assign  s_v     = 1;
assign  s_d     = sel;

assign  o_z_s   = sel;

//------------------------------------------------------------------------------

generate
begin : g_unpack
    case (R)
    2: cory_unpack2 #(.N(N)) u_unpack (
            .clk        (clk),
            .i_a_v      (i_a_v),
            .i_a_d      (i_a_d),
            .o_a_r      (o_a_r),
            .o_z0_v     (a_v[0]),
            .o_z0_d     (a_d[0]),
            .i_z0_r     (a_r[0]),
            .o_z1_v     (a_v[1]),
            .o_z1_d     (a_d[1]),
            .i_z1_r     (a_r[1]),
            .reset_n    (reset_n)
        );
    4: cory_unpack4 #(.N(N)) u_unpack (
            .clk        (clk),
            .i_a_v      (i_a_v),
            .i_a_d      (i_a_d),
            .o_a_r      (o_a_r),
            .o_z0_v     (a_v[0]),
            .o_z0_d     (a_d[0]),
            .i_z0_r     (a_r[0]),
            .o_z1_v     (a_v[1]),
            .o_z1_d     (a_d[1]),
            .i_z1_r     (a_r[1]),
            .o_z2_v     (a_v[2]),
            .o_z2_d     (a_d[2]),
            .i_z2_r     (a_r[2]),
            .o_z3_v     (a_v[3]),
            .o_z3_d     (a_d[3]),
            .i_z3_r     (a_r[3]),
            .reset_n    (reset_n)
        );
    8: cory_unpack8 #(.N(N)) u_unpack (
            .clk        (clk),
            .i_a_v      (i_a_v),
            .i_a_d      (i_a_d),
            .o_a_r      (o_a_r),
            .o_z0_v     (a_v[0]),
            .o_z0_d     (a_d[0]),
            .i_z0_r     (a_r[0]),
            .o_z1_v     (a_v[1]),
            .o_z1_d     (a_d[1]),
            .i_z1_r     (a_r[1]),
            .o_z2_v     (a_v[2]),
            .o_z2_d     (a_d[2]),
            .i_z2_r     (a_r[2]),
            .o_z3_v     (a_v[3]),
            .o_z3_d     (a_d[3]),
            .i_z3_r     (a_r[3]),
            .o_z4_v     (a_v[4]),
            .o_z4_d     (a_d[4]),
            .i_z4_r     (a_r[4]),
            .o_z5_v     (a_v[5]),
            .o_z5_d     (a_d[5]),
            .i_z5_r     (a_r[5]),
            .o_z6_v     (a_v[6]),
            .o_z6_d     (a_d[6]),
            .i_z6_r     (a_r[6]),
            .o_z7_v     (a_v[7]),
            .o_z7_d     (a_d[7]),
            .i_z7_r     (a_r[7]),
            .reset_n    (reset_n)
        );
    16: cory_unpack16 #(.N(N)) u_unpack (
            .clk        (clk),
            .i_a_v      (i_a_v),
            .i_a_d      (i_a_d),
            .o_a_r      (o_a_r),
            .o_z0_v     (a_v[0]),
            .o_z0_d     (a_d[0]),
            .i_z0_r     (a_r[0]),
            .o_z1_v     (a_v[1]),
            .o_z1_d     (a_d[1]),
            .i_z1_r     (a_r[1]),
            .o_z2_v     (a_v[2]),
            .o_z2_d     (a_d[2]),
            .i_z2_r     (a_r[2]),
            .o_z3_v     (a_v[3]),
            .o_z3_d     (a_d[3]),
            .i_z3_r     (a_r[3]),
            .o_z4_v     (a_v[4]),
            .o_z4_d     (a_d[4]),
            .i_z4_r     (a_r[4]),
            .o_z5_v     (a_v[5]),
            .o_z5_d     (a_d[5]),
            .i_z5_r     (a_r[5]),
            .o_z6_v     (a_v[6]),
            .o_z6_d     (a_d[6]),
            .i_z6_r     (a_r[6]),
            .o_z7_v     (a_v[7]),
            .o_z7_d     (a_d[7]),
            .i_z7_r     (a_r[7]),
            .o_z8_v     (a_v[8]),
            .o_z8_d     (a_d[8]),
            .i_z8_r     (a_r[8]),
            .o_z9_v     (a_v[9]),
            .o_z9_d     (a_d[9]),
            .i_z9_r     (a_r[9]),
            .o_za_v     (a_v[10]),
            .o_za_d     (a_d[10]),
            .i_za_r     (a_r[10]),
            .o_zb_v     (a_v[11]),
            .o_zb_d     (a_d[11]),
            .i_zb_r     (a_r[11]),
            .o_zc_v     (a_v[12]),
            .o_zc_d     (a_d[12]),
            .i_zc_r     (a_r[12]),
            .o_zd_v     (a_v[13]),
            .o_zd_d     (a_d[13]),
            .i_zd_r     (a_r[13]),
            .o_ze_v     (a_v[14]),
            .o_ze_d     (a_d[14]),
            .i_ze_r     (a_r[14]),
            .o_zf_v     (a_v[15]),
            .o_zf_d     (a_d[15]),
            .i_zf_r     (a_r[15]),
            .reset_n    (reset_n)
        );
    endcase
end
endgenerate

genvar  i;
generate
begin : g_flop
    for (i=0; i<R; i=i+1) begin : u_blk_flop
        cory_flop #(.N(N)) u_flop (
            .clk        (clk),
            .i_a_v      (a_v[i]),
            .i_a_d      (a_d[i]),
            .o_a_r      (a_r[i]),
            .o_z_v      (z_v[i]),
            .o_z_d      (z_d[i]),
            .i_z_r      (z_r[i]),
            .reset_n    (reset_n)
        );
    end
end
endgenerate

generate
begin : g_mux
    case (R)
    2: cory_mux2 #(.N(N)) u_mux (
            .clk        (clk),
            .i_a0_v     (z_v[0]),
            .i_a0_d     (z_d[0]),
            .o_a0_r     (z_r[0]),
            .i_a1_v     (z_v[1]),
            .i_a1_d     (z_d[1]),
            .o_a1_r     (z_r[1]),
            .i_s_v      (s_v),
            .i_s_d      (s_d),
            .o_s_r      (s_r),
            .o_z_v      (o_z_v),
            .o_z_d      (o_z_d),
            .i_z_r      (i_z_r),
            .reset_n    (reset_n)
        );
    4: cory_mux4 #(.N(N)) u_mux (
            .clk        (clk),
            .i_a0_v     (z_v[0]),
            .i_a0_d     (z_d[0]),
            .o_a0_r     (z_r[0]),
            .i_a1_v     (z_v[1]),
            .i_a1_d     (z_d[1]),
            .o_a1_r     (z_r[1]),
            .i_a2_v     (z_v[2]),
            .i_a2_d     (z_d[2]),
            .o_a2_r     (z_r[2]),
            .i_a3_v     (z_v[3]),
            .i_a3_d     (z_d[3]),
            .o_a3_r     (z_r[3]),
            .i_s_v      (s_v),
            .i_s_d      (s_d),
            .o_s_r      (s_r),
            .o_z_v      (o_z_v),
            .o_z_d      (o_z_d),
            .i_z_r      (i_z_r),
            .reset_n    (reset_n)
        );
    8: cory_mux8 #(.N(N)) u_mux (
            .clk        (clk),
            .i_a0_v     (z_v[0]),
            .i_a0_d     (z_d[0]),
            .o_a0_r     (z_r[0]),
            .i_a1_v     (z_v[1]),
            .i_a1_d     (z_d[1]),
            .o_a1_r     (z_r[1]),
            .i_a2_v     (z_v[2]),
            .i_a2_d     (z_d[2]),
            .o_a2_r     (z_r[2]),
            .i_a3_v     (z_v[3]),
            .i_a3_d     (z_d[3]),
            .o_a3_r     (z_r[3]),
            .i_a4_v     (z_v[4]),
            .i_a4_d     (z_d[4]),
            .o_a4_r     (z_r[4]),
            .i_a5_v     (z_v[5]),
            .i_a5_d     (z_d[5]),
            .o_a5_r     (z_r[5]),
            .i_a6_v     (z_v[6]),
            .i_a6_d     (z_d[6]),
            .o_a6_r     (z_r[6]),
            .i_a7_v     (z_v[7]),
            .i_a7_d     (z_d[7]),
            .o_a7_r     (z_r[7]),
            .i_s_v      (s_v),
            .i_s_d      (s_d),
            .o_s_r      (s_r),
            .o_z_v      (o_z_v),
            .o_z_d      (o_z_d),
            .i_z_r      (i_z_r),
            .reset_n    (reset_n)
        );
    16: cory_mux16 #(.N(N)) u_mux (
            .clk        (clk),
            .i_a0_v     (z_v[0]),
            .i_a0_d     (z_d[0]),
            .o_a0_r     (z_r[0]),
            .i_a1_v     (z_v[1]),
            .i_a1_d     (z_d[1]),
            .o_a1_r     (z_r[1]),
            .i_a2_v     (z_v[2]),
            .i_a2_d     (z_d[2]),
            .o_a2_r     (z_r[2]),
            .i_a3_v     (z_v[3]),
            .i_a3_d     (z_d[3]),
            .o_a3_r     (z_r[3]),
            .i_a4_v     (z_v[4]),
            .i_a4_d     (z_d[4]),
            .o_a4_r     (z_r[4]),
            .i_a5_v     (z_v[5]),
            .i_a5_d     (z_d[5]),
            .o_a5_r     (z_r[5]),
            .i_a6_v     (z_v[6]),
            .i_a6_d     (z_d[6]),
            .o_a6_r     (z_r[6]),
            .i_a7_v     (z_v[7]),
            .i_a7_d     (z_d[7]),
            .o_a7_r     (z_r[7]),
            .i_a8_v     (z_v[8]),
            .i_a8_d     (z_d[8]),
            .o_a8_r     (z_r[8]),
            .i_a9_v     (z_v[9]),
            .i_a9_d     (z_d[9]),
            .o_a9_r     (z_r[9]),
            .i_aa_v     (z_v[10]),
            .i_aa_d     (z_d[10]),
            .o_aa_r     (z_r[10]),
            .i_ab_v     (z_v[11]),
            .i_ab_d     (z_d[11]),
            .o_ab_r     (z_r[11]),
            .i_ac_v     (z_v[12]),
            .i_ac_d     (z_d[12]),
            .o_ac_r     (z_r[12]),
            .i_ad_v     (z_v[13]),
            .i_ad_d     (z_d[13]),
            .o_ad_r     (z_r[13]),
            .i_ae_v     (z_v[14]),
            .i_ae_d     (z_d[14]),
            .o_ae_r     (z_r[14]),
            .i_af_v     (z_v[15]),
            .i_af_d     (z_d[15]),
            .o_af_r     (z_r[15]),
            .i_s_v      (s_v),
            .i_s_d      (s_d),
            .o_s_r      (s_r),
            .o_z_v      (o_z_v),
            .o_z_d      (o_z_d),
            .i_z_r      (i_z_r),
            .reset_n    (reset_n)
        );
    endcase
end
endgenerate

`ifdef  SIM
    initial begin
        if (R != 2 && R != 4 && R != 8 && R != 16) begin
            $display ("ERROR:%m: R = %d, not supported", R);
            $finish;
        end
    end
`endif

endmodule


`endif
