//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_DEMUX8
    `define CORY_DEMUX8

//------------------------------------------------------------------------------
module cory_demux8 # (
    parameter   N   = 8,
    parameter   Q   = 0,
    parameter   Q0  = Q,
    parameter   Q1  = Q,
    parameter   Q2  = Q,
    parameter   Q3  = Q,
    parameter   Q4  = Q,
    parameter   Q5  = Q,
    parameter   Q6  = Q,
    parameter   Q7  = Q
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    input           i_s_v,
    input   [2:0]   i_s_d,
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

//------------------------------------------------------------------------------
wire    [2:0]   op_sel  = i_s_d;
wire    [N-1:0] op_d    = i_a_d;

wire    op_r_a0 = i_a_v && i_s_v;
wire    op_r_a1 = i_a_v && i_s_v;
wire    op_r_a2 = i_a_v && i_s_v;
wire    op_r_a3 = i_a_v && i_s_v;
wire    op_r_a4 = i_a_v && i_s_v;
wire    op_r_a5 = i_a_v && i_s_v;
wire    op_r_a6 = i_a_v && i_s_v;
wire    op_r_a7 = i_a_v && i_s_v;

wire    op_done_a0  = int_z0_v && int_z0_r;
wire    op_done_a1  = int_z1_v && int_z1_r;
wire    op_done_a2  = int_z2_v && int_z2_r;
wire    op_done_a3  = int_z3_v && int_z3_r;
wire    op_done_a4  = int_z4_v && int_z4_r;
wire    op_done_a5  = int_z5_v && int_z5_r;
wire    op_done_a6  = int_z6_v && int_z6_r;
wire    op_done_a7  = int_z7_v && int_z7_r;
wire    op_done     = op_done_a0 || op_done_a1 || op_done_a2 || op_done_a3 ||
                      op_done_a4 || op_done_a5 || op_done_a6 || op_done_a7;

assign  int_z0_v  = op_r_a0 && op_sel == 0;
assign  int_z1_v  = op_r_a1 && op_sel == 1;
assign  int_z2_v  = op_r_a2 && op_sel == 2;
assign  int_z3_v  = op_r_a3 && op_sel == 3;
assign  int_z4_v  = op_r_a4 && op_sel == 4;
assign  int_z5_v  = op_r_a5 && op_sel == 5;
assign  int_z6_v  = op_r_a6 && op_sel == 6;
assign  int_z7_v  = op_r_a7 && op_sel == 7;

assign  int_z0_d   = op_sel == 0 ? op_d : 0;
assign  int_z1_d   = op_sel == 1 ? op_d : 0;
assign  int_z2_d   = op_sel == 2 ? op_d : 0;
assign  int_z3_d   = op_sel == 3 ? op_d : 0;
assign  int_z4_d   = op_sel == 4 ? op_d : 0;
assign  int_z5_d   = op_sel == 5 ? op_d : 0;
assign  int_z6_d   = op_sel == 6 ? op_d : 0;
assign  int_z7_d   = op_sel == 7 ? op_d : 0;

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
`endif                                          //  CORY_MON
`endif
endmodule


`endif
