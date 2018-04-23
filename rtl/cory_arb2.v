//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_ARB2
    `define CORY_ARB2

//------------------------------------------------------------------------------
//  2 input arbiter
//------------------------------------------------------------------------------
module cory_arb2 # (
    parameter   N       = 8,                    // # of data bits
    parameter   ROUND   = 1,                    // 1:round, 0:port priority (0>1)
    parameter   Q       = 0
) (
    input           clk,

    input           i_a0_v,
    input   [N-1:0] i_a0_d,
    output          o_a0_r,

    input           i_a1_v,
    input   [N-1:0] i_a1_d,
    output          o_a1_r,

    output          o_z_v,
    output  [N-1:0] o_z_d,
    output          o_z_s,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
wire            int_v;
wire    [N-1:0] int_d;
wire            int_s;
wire            int_r;

//------------------------------------------------------------------------------
wire    slave_accept    = int_v & int_r;
wire    a0_v_ex = i_a0_v & (!i_a1_v);
wire    a1_v_ex = (!i_a0_v) & i_a1_v;

wire            sel;
reg             pri;

wire    pri_sel;

generate
begin : g_pri_sel
    case (ROUND)
    1:  assign  pri_sel    = sel + 1;
    0:  assign  pri_sel    = 0;
    endcase
end
endgenerate

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        pri <= 0;
    else
        casex ({a1_v_ex, a0_v_ex, slave_accept})
        3'b010: pri <= 0;
        3'b100: pri <= 1;
        3'bxx1: pri <= pri_sel;
        endcase

assign  sel     = a0_v_ex ? 0 :
                  a1_v_ex ? 1 : pri;

assign  int_s   = sel;

//------------------------------------------------------------------------------

cory_mux2 #(.N(N)) u_mux2 (
    .clk        (clk),
    .i_a0_v     (i_a0_v),
    .i_a0_d     (i_a0_d),
    .o_a0_r     (o_a0_r),
    .i_a1_v     (i_a1_v),
    .i_a1_d     (i_a1_d),
    .o_a1_r     (o_a1_r),
    .i_s_v      (1'b1),
    .i_s_d      (sel),
    .o_s_r      (),
    .o_z_v      (int_v),
    .o_z_d      (int_d),
    .i_z_r      (int_r),
    .reset_n    (reset_n)
);

//------------------------------------------------------------------------------
cory_queue #(.N(1+N), .Q(Q)) u_queue (
    .clk        (clk),
    .i_a_v      (int_v),
    .i_a_d      ({int_s, int_d}),
    .o_a_r      (int_r),
    .o_z_v      (o_z_v),
    .o_z_d      ({o_z_s, o_z_d}),
    .i_z_r      (i_z_r),
    .reset_n    (reset_n)
);

//------------------------------------------------------------------------------

endmodule


`endif
