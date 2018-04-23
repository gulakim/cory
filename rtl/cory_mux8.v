//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_MUX8
    `define CORY_MUX8

//------------------------------------------------------------------------------
module cory_mux8 # (
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

    input           i_s_v,
    input   [2:0]   i_s_d,
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
wire    [2:0]   sel;

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
                  sel == 7 ? i_a7_v && i_s_v : 0;

assign  int_d   = sel == 0 ? i_a0_d :
                  sel == 1 ? i_a1_d :
                  sel == 2 ? i_a2_d :
                  sel == 3 ? i_a3_d :
                  sel == 4 ? i_a4_d :
                  sel == 5 ? i_a5_d :
                  sel == 6 ? i_a6_d :
                  sel == 7 ? i_a7_d : 0;

assign  o_a0_r  = sel == 0 ? int_r : 0;
assign  o_a1_r  = sel == 1 ? int_r : 0;
assign  o_a2_r  = sel == 2 ? int_r : 0;
assign  o_a3_r  = sel == 3 ? int_r : 0;
assign  o_a4_r  = sel == 4 ? int_r : 0;
assign  o_a5_r  = sel == 5 ? int_r : 0;
assign  o_a6_r  = sel == 6 ? int_r : 0;
assign  o_a7_r  = sel == 7 ? int_r : 0;

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
