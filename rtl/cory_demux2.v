//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_DEMUX2
    `define CORY_DEMUX2

//------------------------------------------------------------------------------
module cory_demux2 # (
    parameter   N   = 8,
    parameter   Q   = 0,
    parameter   Q0  = Q,
    parameter   Q1  = Q
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    input           i_s_v,
    input           i_s_d,
    output          o_s_r,

    output          o_z0_v,
    output  [N-1:0] o_z0_d,
    input           i_z0_r,

    output          o_z1_v,
    output  [N-1:0] o_z1_d,
    input           i_z1_r,

    input           reset_n
);

//------------------------------------------------------------------------------
wire            int_z0_v;
wire    [N-1:0] int_z0_d;
wire            int_z0_r;
wire            int_z1_v;
wire    [N-1:0] int_z1_d;
wire            int_z1_r;

//------------------------------------------------------------------------------
wire            op_sel  = i_s_d;
wire    [N-1:0] op_d    = i_a_d;

wire    op_r_a0     = i_a_v && i_s_v;
wire    op_r_a1     = i_a_v && i_s_v;

wire    op_done_a0  = int_z0_v && int_z0_r;
wire    op_done_a1  = int_z1_v && int_z1_r;
wire    op_done     = op_done_a0 || op_done_a1;

assign  int_z0_v      = op_r_a0 && op_sel == 0;
assign  int_z1_v      = op_r_a1 && op_sel == 1;

assign  int_z0_d      = op_sel == 0 ? op_d : 0;
assign  int_z1_d      = op_sel == 1 ? op_d : 0;

assign  o_s_r       = op_done;
assign  o_a_r       = op_done;

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

endmodule

`endif
