//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_MUX16
    `define CORY_MUX16

//------------------------------------------------------------------------------
module cory_mux16 # (
    parameter   N   = 8,
    parameter   Q   = 0
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

    input           i_s_v,
    input   [3:0]   i_s_d,
    output          o_s_r,

    output          o_z_v,
    output  [N-1:0] o_z_d,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
wire            int_v;
wire    [N-1:0] int_d;
wire            int_r;

//------------------------------------------------------------------------------
wire    [3:0]   sel;

assign  sel         = i_s_d;
assign  o_s_r       = int_r;

//------------------------------------------------------------------------------

assign  int_v   = sel == 0 ? i_a0_v && i_s_v :
                  sel == 1 ? i_a1_v && i_s_v :
                  sel == 2 ? i_a2_v && i_s_v :
                  sel == 3 ? i_a3_v && i_s_v :
                  sel == 4 ? i_a4_v && i_s_v :
                  sel == 5 ? i_a5_v && i_s_v :
                  sel == 6 ? i_a6_v && i_s_v :
                  sel == 7 ? i_a7_v && i_s_v :
                  sel == 8 ? i_a8_v && i_s_v :
                  sel == 9 ? i_a9_v && i_s_v :
                  sel == 10 ? i_aa_v && i_s_v :
                  sel == 11 ? i_ab_v && i_s_v :
                  sel == 12 ? i_ac_v && i_s_v :
                  sel == 13 ? i_ad_v && i_s_v :
                  sel == 14 ? i_ae_v && i_s_v :
                  sel == 15 ? i_af_v && i_s_v : 0;

assign  int_d   = sel == 0 ? i_a0_d :
                  sel == 1 ? i_a1_d :
                  sel == 2 ? i_a2_d :
                  sel == 3 ? i_a3_d :
                  sel == 4 ? i_a4_d :
                  sel == 5 ? i_a5_d :
                  sel == 6 ? i_a6_d :
                  sel == 7 ? i_a7_d :
                  sel == 8 ? i_a8_d :
                  sel == 9 ? i_a9_d :
                  sel == 10 ? i_aa_d :
                  sel == 11 ? i_ab_d :
                  sel == 12 ? i_ac_d :
                  sel == 13 ? i_ad_d :
                  sel == 14 ? i_ae_d :
                  sel == 15 ? i_af_d : 0;

assign  o_a0_r  = sel == 0 ? int_r : 0;
assign  o_a1_r  = sel == 1 ? int_r : 0;
assign  o_a2_r  = sel == 2 ? int_r : 0;
assign  o_a3_r  = sel == 3 ? int_r : 0;
assign  o_a4_r  = sel == 4 ? int_r : 0;
assign  o_a5_r  = sel == 5 ? int_r : 0;
assign  o_a6_r  = sel == 6 ? int_r : 0;
assign  o_a7_r  = sel == 7 ? int_r : 0;
assign  o_a8_r  = sel == 8 ? int_r : 0;
assign  o_a9_r  = sel == 9 ? int_r : 0;
assign  o_aa_r  = sel == 10 ? int_r : 0;
assign  o_ab_r  = sel == 11 ? int_r : 0;
assign  o_ac_r  = sel == 12 ? int_r : 0;
assign  o_ad_r  = sel == 13 ? int_r : 0;
assign  o_ae_r  = sel == 14 ? int_r : 0;
assign  o_af_r  = sel == 15 ? int_r : 0;

//------------------------------------------------------------------------------
cory_queue #(.N(N), .Q(Q)) u_queue (
    .clk        (clk),
    .i_a_v      (int_v),
    .i_a_d      (int_d),
    .o_a_r      (int_r),
    .o_z_v      (o_z_v),
    .o_z_d      (o_z_d),
    .i_z_r      (i_z_r),
    .reset_n    (reset_n)
);

endmodule

`endif
