//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_DEMUX16
    `define CORY_DEMUX16

//------------------------------------------------------------------------------
module cory_demux16 # (
    parameter   N   = 8,
    parameter   Q   = 0,
    parameter   Q0  = Q,
    parameter   Q1  = Q,
    parameter   Q2  = Q,
    parameter   Q3  = Q,
    parameter   Q4  = Q,
    parameter   Q5  = Q,
    parameter   Q6  = Q,
    parameter   Q7  = Q,
    parameter   Q8  = Q,
    parameter   Q9  = Q,
    parameter   QA  = Q,
    parameter   QB  = Q,
    parameter   QC  = Q,
    parameter   QD  = Q,
    parameter   QE  = Q,
    parameter   QF  = Q
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    input           i_s_v,
    input   [3:0]   i_s_d,
    output          o_s_r,

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

    input           reset_n
);

//------------------------------------------------------------------------------
wire            int_z0_v;
wire    [N-1:0] int_z0_d;
wire            int_z0_r;
wire            int_z1_v;
wire    [N-1:0] int_z1_d;
wire            int_z1_r;
wire            int_z2_v;
wire    [N-1:0] int_z2_d;
wire            int_z2_r;
wire            int_z3_v;
wire    [N-1:0] int_z3_d;
wire            int_z3_r;
wire            int_z4_v;
wire    [N-1:0] int_z4_d;
wire            int_z4_r;
wire            int_z5_v;
wire    [N-1:0] int_z5_d;
wire            int_z5_r;
wire            int_z6_v;
wire    [N-1:0] int_z6_d;
wire            int_z6_r;
wire            int_z7_v;
wire    [N-1:0] int_z7_d;
wire            int_z7_r;
wire            int_z8_v;
wire    [N-1:0] int_z8_d;
wire            int_z8_r;
wire            int_z9_v;
wire    [N-1:0] int_z9_d;
wire            int_z9_r;
wire            int_za_v;
wire    [N-1:0] int_za_d;
wire            int_za_r;
wire            int_zb_v;
wire    [N-1:0] int_zb_d;
wire            int_zb_r;
wire            int_zc_v;
wire    [N-1:0] int_zc_d;
wire            int_zc_r;
wire            int_zd_v;
wire    [N-1:0] int_zd_d;
wire            int_zd_r;
wire            int_ze_v;
wire    [N-1:0] int_ze_d;
wire            int_ze_r;
wire            int_zf_v;
wire    [N-1:0] int_zf_d;
wire            int_zf_r;

//------------------------------------------------------------------------------
wire    [3:0]   op_sel  = i_s_d;
wire    [N-1:0]  op_d = i_a_d;

wire    op_r_ax = i_a_v && i_s_v;

wire    op_done_a0  = int_z0_v && int_z0_r;
wire    op_done_a1  = int_z1_v && int_z1_r;
wire    op_done_a2  = int_z2_v && int_z2_r;
wire    op_done_a3  = int_z3_v && int_z3_r;
wire    op_done_a4  = int_z4_v && int_z4_r;
wire    op_done_a5  = int_z5_v && int_z5_r;
wire    op_done_a6  = int_z6_v && int_z6_r;
wire    op_done_a7  = int_z7_v && int_z7_r;
wire    op_done_a8  = int_z8_v && int_z8_r;
wire    op_done_a9  = int_z9_v && int_z9_r;
wire    op_done_aa  = int_za_v && int_za_r;
wire    op_done_ab  = int_zb_v && int_zb_r;
wire    op_done_ac  = int_zc_v && int_zc_r;
wire    op_done_ad  = int_zd_v && int_zd_r;
wire    op_done_ae  = int_ze_v && int_ze_r;
wire    op_done_af  = int_zf_v && int_zf_r;
wire    op_done     = op_done_a0 || op_done_a1 || op_done_a2 || op_done_a3 ||
                      op_done_a4 || op_done_a5 || op_done_a6 || op_done_a7 ||
                      op_done_a8 || op_done_a9 || op_done_aa || op_done_ab ||
                      op_done_ac || op_done_ad || op_done_ae || op_done_af;

assign  int_z0_v  = op_r_ax && op_sel == 0;
assign  int_z1_v  = op_r_ax && op_sel == 1;
assign  int_z2_v  = op_r_ax && op_sel == 2;
assign  int_z3_v  = op_r_ax && op_sel == 3;
assign  int_z4_v  = op_r_ax && op_sel == 4;
assign  int_z5_v  = op_r_ax && op_sel == 5;
assign  int_z6_v  = op_r_ax && op_sel == 6;
assign  int_z7_v  = op_r_ax && op_sel == 7;
assign  int_z8_v  = op_r_ax && op_sel == 8;
assign  int_z9_v  = op_r_ax && op_sel == 9;
assign  int_za_v  = op_r_ax && op_sel == 10;
assign  int_zb_v  = op_r_ax && op_sel == 11;
assign  int_zc_v  = op_r_ax && op_sel == 12;
assign  int_zd_v  = op_r_ax && op_sel == 13;
assign  int_ze_v  = op_r_ax && op_sel == 14;
assign  int_zf_v  = op_r_ax && op_sel == 15;

assign  int_z0_d   = op_sel == 0 ? op_d : 0;
assign  int_z1_d   = op_sel == 1 ? op_d : 0;
assign  int_z2_d   = op_sel == 2 ? op_d : 0;
assign  int_z3_d   = op_sel == 3 ? op_d : 0;
assign  int_z4_d   = op_sel == 4 ? op_d : 0;
assign  int_z5_d   = op_sel == 5 ? op_d : 0;
assign  int_z6_d   = op_sel == 6 ? op_d : 0;
assign  int_z7_d   = op_sel == 7 ? op_d : 0;
assign  int_z8_d   = op_sel == 8 ? op_d : 0;
assign  int_z9_d   = op_sel == 9 ? op_d : 0;
assign  int_za_d   = op_sel == 10 ? op_d : 0;
assign  int_zb_d   = op_sel == 11 ? op_d : 0;
assign  int_zc_d   = op_sel == 12 ? op_d : 0;
assign  int_zd_d   = op_sel == 13 ? op_d : 0;
assign  int_ze_d   = op_sel == 14 ? op_d : 0;
assign  int_zf_d   = op_sel == 15 ? op_d : 0;

assign  o_s_r   = op_done;
assign  o_a_r   = op_done;

//------------------------------------------------------------------------------
cory_queue #(.N(N), .Q(Q0)) u_queue_z0 (
    .clk        (clk),
    
    .i_a_v      (int_z0_v),
    .i_a_d      (int_z0_d),
    .o_a_r      (int_z0_r),

    .o_z_v      (o_z0_v),
    .o_z_d      (o_z0_d),
    .i_z_r      (i_z0_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(Q1)) u_queue_z1 (
    .clk        (clk),
    
    .i_a_v      (int_z1_v),
    .i_a_d      (int_z1_d),
    .o_a_r      (int_z1_r),

    .o_z_v      (o_z1_v),
    .o_z_d      (o_z1_d),
    .i_z_r      (i_z1_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(Q2)) u_queue_z2 (
    .clk        (clk),
    
    .i_a_v      (int_z2_v),
    .i_a_d      (int_z2_d),
    .o_a_r      (int_z2_r),

    .o_z_v      (o_z2_v),
    .o_z_d      (o_z2_d),
    .i_z_r      (i_z2_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(Q3)) u_queue_z3 (
    .clk        (clk),
    
    .i_a_v      (int_z3_v),
    .i_a_d      (int_z3_d),
    .o_a_r      (int_z3_r),

    .o_z_v      (o_z3_v),
    .o_z_d      (o_z3_d),
    .i_z_r      (i_z3_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(Q4)) u_queue_z4 (
    .clk        (clk),
    
    .i_a_v      (int_z4_v),
    .i_a_d      (int_z4_d),
    .o_a_r      (int_z4_r),

    .o_z_v      (o_z4_v),
    .o_z_d      (o_z4_d),
    .i_z_r      (i_z4_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(Q5)) u_queue_z5 (
    .clk        (clk),
    
    .i_a_v      (int_z5_v),
    .i_a_d      (int_z5_d),
    .o_a_r      (int_z5_r),

    .o_z_v      (o_z5_v),
    .o_z_d      (o_z5_d),
    .i_z_r      (i_z5_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(Q6)) u_queue_z6 (
    .clk        (clk),
    
    .i_a_v      (int_z6_v),
    .i_a_d      (int_z6_d),
    .o_a_r      (int_z6_r),

    .o_z_v      (o_z6_v),
    .o_z_d      (o_z6_d),
    .i_z_r      (i_z6_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(Q7)) u_queue_z7 (
    .clk        (clk),
    
    .i_a_v      (int_z7_v),
    .i_a_d      (int_z7_d),
    .o_a_r      (int_z7_r),

    .o_z_v      (o_z7_v),
    .o_z_d      (o_z7_d),
    .i_z_r      (i_z7_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(Q8)) u_queue_z8 (
    .clk        (clk),
    
    .i_a_v      (int_z8_v),
    .i_a_d      (int_z8_d),
    .o_a_r      (int_z8_r),

    .o_z_v      (o_z8_v),
    .o_z_d      (o_z8_d),
    .i_z_r      (i_z8_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(Q9)) u_queue_z9 (
    .clk        (clk),
    
    .i_a_v      (int_z9_v),
    .i_a_d      (int_z9_d),
    .o_a_r      (int_z9_r),

    .o_z_v      (o_z9_v),
    .o_z_d      (o_z9_d),
    .i_z_r      (i_z9_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(QA)) u_queue_za (
    .clk        (clk),
    
    .i_a_v      (int_za_v),
    .i_a_d      (int_za_d),
    .o_a_r      (int_za_r),

    .o_z_v      (o_za_v),
    .o_z_d      (o_za_d),
    .i_z_r      (i_za_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(QB)) u_queue_zb (
    .clk        (clk),
    
    .i_a_v      (int_zb_v),
    .i_a_d      (int_zb_d),
    .o_a_r      (int_zb_r),

    .o_z_v      (o_zb_v),
    .o_z_d      (o_zb_d),
    .i_z_r      (i_zb_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(QC)) u_queue_zc (
    .clk        (clk),
    
    .i_a_v      (int_zc_v),
    .i_a_d      (int_zc_d),
    .o_a_r      (int_zc_r),

    .o_z_v      (o_zc_v),
    .o_z_d      (o_zc_d),
    .i_z_r      (i_zc_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(QD)) u_queue_zd (
    .clk        (clk),
    
    .i_a_v      (int_zd_v),
    .i_a_d      (int_zd_d),
    .o_a_r      (int_zd_r),

    .o_z_v      (o_zd_v),
    .o_z_d      (o_zd_d),
    .i_z_r      (i_zd_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(QE)) u_queue_ze (
    .clk        (clk),
    
    .i_a_v      (int_ze_v),
    .i_a_d      (int_ze_d),
    .o_a_r      (int_ze_r),

    .o_z_v      (o_ze_v),
    .o_z_d      (o_ze_d),
    .i_z_r      (i_ze_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(N), .Q(QF)) u_queue_zf (
    .clk        (clk),
    
    .i_a_v      (int_zf_v),
    .i_a_d      (int_zf_d),
    .o_a_r      (int_zf_r),

    .o_z_v      (o_zf_v),
    .o_z_d      (o_zf_d),
    .i_z_r      (i_zf_r),

    .reset_n    (reset_n)
);

//------------------------------------------------------------------------------
`ifdef SIM
`ifdef  CORY_MON
    cory_monitor #(N) u_monitor_z0 (
        .clk        (clk),
        .i_v        (o_z0_v),
        .i_d        (o_z0_d),
        .i_r        (i_z0_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_z1 (
        .clk        (clk),
        .i_v        (o_z1_v),
        .i_d        (o_z1_d),
        .i_r        (i_z1_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_z2 (
        .clk        (clk),
        .i_v        (o_z2_v),
        .i_d        (o_z2_d),
        .i_r        (i_z2_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_z3 (
        .clk        (clk),
        .i_v        (o_z3_v),
        .i_d        (o_z3_d),
        .i_r        (i_z3_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_z4 (
        .clk        (clk),
        .i_v        (o_z4_v),
        .i_d        (o_z4_d),
        .i_r        (i_z4_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_z5 (
        .clk        (clk),
        .i_v        (o_z5_v),
        .i_d        (o_z5_d),
        .i_r        (i_z5_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_z6 (
        .clk        (clk),
        .i_v        (o_z6_v),
        .i_d        (o_z6_d),
        .i_r        (i_z6_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_z7 (
        .clk        (clk),
        .i_v        (o_z7_v),
        .i_d        (o_z7_d),
        .i_r        (i_z7_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_z8 (
        .clk        (clk),
        .i_v        (o_z8_v),
        .i_d        (o_z8_d),
        .i_r        (i_z8_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_z9 (
        .clk        (clk),
        .i_v        (o_z9_v),
        .i_d        (o_z9_d),
        .i_r        (i_z9_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_za (
        .clk        (clk),
        .i_v        (o_za_v),
        .i_d        (o_za_d),
        .i_r        (i_za_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_zb (
        .clk        (clk),
        .i_v        (o_zb_v),
        .i_d        (o_zb_d),
        .i_r        (i_zb_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_zc (
        .clk        (clk),
        .i_v        (o_zc_v),
        .i_d        (o_zc_d),
        .i_r        (i_zc_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_zd (
        .clk        (clk),
        .i_v        (o_zd_v),
        .i_d        (o_zd_d),
        .i_r        (i_zd_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_ze (
        .clk        (clk),
        .i_v        (o_ze_v),
        .i_d        (o_ze_d),
        .i_r        (i_ze_r),
        .reset_n    (reset_n)
    );

    cory_monitor #(N) u_monitor_zf (
        .clk        (clk),
        .i_v        (o_zf_v),
        .i_d        (o_zf_d),
        .i_r        (i_zf_r),
        .reset_n    (reset_n)
    );
`endif                                          //  CORY_MON
`endif
endmodule


`endif
