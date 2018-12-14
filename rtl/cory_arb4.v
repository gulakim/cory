//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_ARB4
    `define CORY_ARB4

//------------------------------------------------------------------------------
module cory_arb4 # (
    parameter   N       = 8,                    // # of data bits
    parameter   ROUND   = 1,                    // 1:round, 0:port (0>1>2=3)
    parameter   Q       = 0
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

    output          o_z_v,
    output  [N-1:0] o_z_d,
    output  [1:0]   o_z_s,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
wire            a01_v;
wire    [N-1:0] a01_d;
wire            a01_r;
wire            a01_s;

cory_arb2 #(.N(N), .ROUND(ROUND), .Q(Q)) u_arb01 (
    .clk        (clk),
    .i_a0_v     (i_a0_v),
    .i_a0_d     (i_a0_d),
    .o_a0_r     (o_a0_r),
    .i_a1_v     (i_a1_v),
    .i_a1_d     (i_a1_d),
    .o_a1_r     (o_a1_r),
    .o_z_v      (a01_v),
    .o_z_d      (a01_d),
    .o_z_s      (a01_s),
    .i_z_r      (a01_r),
    .reset_n    (reset_n)
);

wire            a23_v;
wire    [N-1:0] a23_d;
wire            a23_r;
wire            a23_s;

cory_arb2 #(.N(N), .ROUND(1), .Q(Q)) u_arb23 (         // see priority case above
    .clk        (clk),
    .i_a0_v     (i_a2_v),
    .i_a0_d     (i_a2_d),
    .o_a0_r     (o_a2_r),
    .i_a1_v     (i_a3_v),
    .i_a1_d     (i_a3_d),
    .o_a1_r     (o_a3_r),
    .o_z_v      (a23_v),
    .o_z_d      (a23_d),
    .o_z_s      (a23_s),
    .i_z_r      (a23_r),
    .reset_n    (reset_n)
);

//------------------------------------------------------------------------------
wire    z_s1;

cory_arb2 #(.N(N), .ROUND(ROUND), .Q(Q)) u_arb (
    .clk        (clk),
    .i_a0_v     (a01_v),
    .i_a0_d     (a01_d),
    .o_a0_r     (a01_r),
    .i_a1_v     (a23_v),
    .i_a1_d     (a23_d),
    .o_a1_r     (a23_r),
    .o_z_v      (o_z_v),
    .o_z_d      (o_z_d),
    .o_z_s      (z_s1),
    .i_z_r      (i_z_r),
    .reset_n    (reset_n)
);

assign  o_z_s   = z_s1 ? {z_s1, a23_s} : {z_s1, a01_s};

endmodule

`endif                                          // CORY_ARBR4
