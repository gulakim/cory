module tb;
`ifdef  SIM
//------------------------------------------------------------------------------

parameter   MAX_SIM_TIME    = 99999;

wire    clk;
wire    reset_n;

clk_gen #(10) u_clk_gen (
    .clk        (clk),
    .reset_n    (reset_n)
);

`ifndef  WAVE_FILE
    `define WAVE_FILE   "/home/user/dump/cory"
`endif

initial begin
    $display ("NOTE:%m: waveform in %s", `WAVE_FILE);
    $shm_open (`WAVE_FILE);
    $shm_probe (tb, "ACM");
    #(MAX_SIM_TIME);
    $display ("NOTE:%m: simulation time limited to %t", MAX_SIM_TIME);
    $finish;
end

//------------------------------------------------------------------------------

wire            din_v [0:15];
wire    [7:0]   din_d [0:15];
wire            din_r [0:15];

wire    [3:0]   zx_sel[0:15];

/*
assign          zx_sel[0]   = 0;
assign          zx_sel[1]   = 1;
assign          zx_sel[2]   = 2;
assign          zx_sel[3]   = 3;
assign          zx_sel[4]   = 4;
assign          zx_sel[5]   = 5;
assign          zx_sel[6]   = 6;
assign          zx_sel[7]   = 7;
assign          zx_sel[8]   = 8;
assign          zx_sel[9]   = 9;
assign          zx_sel[10]  = 10;
assign          zx_sel[11]  = 11;
assign          zx_sel[12]  = 12;
assign          zx_sel[13]  = 13;
assign          zx_sel[14]  = 14;
assign          zx_sel[15]  = 15;
*/
parameter   M   = 3;
assign          zx_sel[0]   = f_4bit(M * 21 + 1);
assign          zx_sel[1]   = f_4bit(zx_sel[0] * 21 + 1);
assign          zx_sel[2]   = f_4bit(zx_sel[1] * 21 + 1);
assign          zx_sel[3]   = f_4bit(zx_sel[2] * 21 + 1);
assign          zx_sel[4]   = f_4bit(zx_sel[3] * 21 + 1);
assign          zx_sel[5]   = f_4bit(zx_sel[4] * 21 + 1);
assign          zx_sel[6]   = f_4bit(zx_sel[5] * 21 + 1);
assign          zx_sel[7]   = f_4bit(zx_sel[6] * 21 + 1);
assign          zx_sel[8]   = f_4bit(zx_sel[7] * 21 + 1);
assign          zx_sel[9]   = f_4bit(zx_sel[8] * 21 + 1);
assign          zx_sel[10]  = f_4bit(zx_sel[9] * 21 + 1);
assign          zx_sel[11]  = f_4bit(zx_sel[10] * 21 + 1);
assign          zx_sel[12]  = f_4bit(zx_sel[11] * 21 + 1);
assign          zx_sel[13]  = f_4bit(zx_sel[12] * 21 + 1);
assign          zx_sel[14]  = f_4bit(zx_sel[13] * 21 + 1);
assign          zx_sel[15]  = f_4bit(zx_sel[14] * 21 + 1);
//  assign          zx_sel[15]  = f_4bit(zx_sel[14] * 1 + 0);

function [3:0] f_4bit;
    input   [7:0] in;
begin
    f_4bit = in[3:0];
end
endfunction

genvar m;
generate
    for (m=0; m<16; m=m+1) begin
        cory_master #(.N(8), .T(0), .V(0), .I(m*16)) u_master (
            .clk        (clk),
            .o_v        (din_v[m]),
            .o_d        (din_d[m]),
            .i_r        (din_r[m]),
            .reset_n    (reset_n)
        );
    end
endgenerate

wire            dout_v[0:15];
wire    [7:0]   dout_d[0:15];
wire            dout_r[0:15];

cory_route16 #(.N(8)) u_unit (
    .clk        (clk),

    .i_a0_v     (din_v[0]),
    .i_a0_d     (din_d[0]),
    .o_a0_r     (din_r[0]),
    .i_a1_v     (din_v[1]),
    .i_a1_d     (din_d[1]),
    .o_a1_r     (din_r[1]),
    .i_a2_v     (din_v[2]),
    .i_a2_d     (din_d[2]),
    .o_a2_r     (din_r[2]),
    .i_a3_v     (din_v[3]),
    .i_a3_d     (din_d[3]),
    .o_a3_r     (din_r[3]),
    .i_a4_v     (din_v[4]),
    .i_a4_d     (din_d[4]),
    .o_a4_r     (din_r[4]),
    .i_a5_v     (din_v[5]),
    .i_a5_d     (din_d[5]),
    .o_a5_r     (din_r[5]),
    .i_a6_v     (din_v[6]),
    .i_a6_d     (din_d[6]),
    .o_a6_r     (din_r[6]),
    .i_a7_v     (din_v[7]),
    .i_a7_d     (din_d[7]),
    .o_a7_r     (din_r[7]),
    .i_a8_v     (din_v[8]),
    .i_a8_d     (din_d[8]),
    .o_a8_r     (din_r[8]),
    .i_a9_v     (din_v[9]),
    .i_a9_d     (din_d[9]),
    .o_a9_r     (din_r[9]),
    .i_aa_v     (din_v[10]),
    .i_aa_d     (din_d[10]),
    .o_aa_r     (din_r[10]),
    .i_ab_v     (din_v[11]),
    .i_ab_d     (din_d[11]),
    .o_ab_r     (din_r[11]),
    .i_ac_v     (din_v[12]),
    .i_ac_d     (din_d[12]),
    .o_ac_r     (din_r[12]),
    .i_ad_v     (din_v[13]),
    .i_ad_d     (din_d[13]),
    .o_ad_r     (din_r[13]),
    .i_ae_v     (din_v[14]),
    .i_ae_d     (din_d[14]),
    .o_ae_r     (din_r[14]),
    .i_af_v     (din_v[15]),
    .i_af_d     (din_d[15]),
    .o_af_r     (din_r[15]),

    .o_z0_v     (dout_v[0]),
    .o_z0_d     (dout_d[0]),
    .i_z0_r     (dout_r[0]),
    .o_z1_v     (dout_v[1]),
    .o_z1_d     (dout_d[1]),
    .i_z1_r     (dout_r[1]),
    .o_z2_v     (dout_v[2]),
    .o_z2_d     (dout_d[2]),
    .i_z2_r     (dout_r[2]),
    .o_z3_v     (dout_v[3]),
    .o_z3_d     (dout_d[3]),
    .i_z3_r     (dout_r[3]),
    .o_z4_v     (dout_v[4]),
    .o_z4_d     (dout_d[4]),
    .i_z4_r     (dout_r[4]),
    .o_z5_v     (dout_v[5]),
    .o_z5_d     (dout_d[5]),
    .i_z5_r     (dout_r[5]),
    .o_z6_v     (dout_v[6]),
    .o_z6_d     (dout_d[6]),
    .i_z6_r     (dout_r[6]),
    .o_z7_v     (dout_v[7]),
    .o_z7_d     (dout_d[7]),
    .i_z7_r     (dout_r[7]),
    .o_z8_v     (dout_v[8]),
    .o_z8_d     (dout_d[8]),
    .i_z8_r     (dout_r[8]),
    .o_z9_v     (dout_v[9]),
    .o_z9_d     (dout_d[9]),
    .i_z9_r     (dout_r[9]),
    .o_za_v     (dout_v[10]),
    .o_za_d     (dout_d[10]),
    .i_za_r     (dout_r[10]),
    .o_zb_v     (dout_v[11]),
    .o_zb_d     (dout_d[11]),
    .i_zb_r     (dout_r[11]),
    .o_zc_v     (dout_v[12]),
    .o_zc_d     (dout_d[12]),
    .i_zc_r     (dout_r[12]),
    .o_zd_v     (dout_v[13]),
    .o_zd_d     (dout_d[13]),
    .i_zd_r     (dout_r[13]),
    .o_ze_v     (dout_v[14]),
    .o_ze_d     (dout_d[14]),
    .i_ze_r     (dout_r[14]),
    .o_zf_v     (dout_v[15]),
    .o_zf_d     (dout_d[15]),
    .i_zf_r     (dout_r[15]),

    .i_z0_s     (zx_sel[0]),
    .i_z1_s     (zx_sel[1]),
    .i_z2_s     (zx_sel[2]),
    .i_z3_s     (zx_sel[3]),
    .i_z4_s     (zx_sel[4]),
    .i_z5_s     (zx_sel[5]),
    .i_z6_s     (zx_sel[6]),
    .i_z7_s     (zx_sel[7]),
    .i_z8_s     (zx_sel[8]),
    .i_z9_s     (zx_sel[9]),
    .i_za_s     (zx_sel[10]),
    .i_zb_s     (zx_sel[11]),
    .i_zc_s     (zx_sel[12]),
    .i_zd_s     (zx_sel[13]),
    .i_ze_s     (zx_sel[14]),
    .i_zf_s     (zx_sel[15]),

    .reset_n    (reset_n)
);

genvar s;
generate
    for (s=0; s<16; s=s+1) begin
        cory_slave #(.N(8), .R(0), .V(0)) u_slave (
            .clk        (clk),
            .i_v        (dout_v[s]),
            .i_d        (dout_d[s]),
            .o_r        (dout_r[s]),
            .reset_n    (reset_n)
        );
    end
endgenerate

`endif  // SIM
endmodule

//------------------------------------------------------------------------------
//  clk
//------------------------------------------------------------------------------
module clk_gen # (
    parameter   PERIOD  = 10
) (
    output          clk,
    output          reset_n
);

`ifdef  SIM
    reg     r_clk;
    reg     r_reset_n;

    initial begin
        r_clk  <= 1;
        forever #(PERIOD/2) r_clk <= !r_clk;
    end

    initial begin
        r_reset_n <= 0;
        #(PERIOD/2*3) r_reset_n <= 1;
    end

    assign  clk     = r_clk;
    assign  reset_n = r_reset_n;

`endif  // SIM

endmodule


