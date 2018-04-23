//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_PASS
    `define CORY_PASS

//------------------------------------------------------------------------------
//  pass or block, not like ignore or pass
//------------------------------------------------------------------------------
module cory_pass # (
    parameter   N   = 8,
    parameter   Q   = 0
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,
    input           i_a_en,     // async

    output          o_z_v,
    output  [N-1:0] o_z_d,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
wire            int_v;
wire    [N-1:0] int_d;
wire            int_r;

reg     r_a_en;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        r_a_en  <= 1'b0;
    else if (int_v & int_r)
        r_a_en  <= 1'b0;
    else if (i_a_en & i_a_v)
        r_a_en  <= 1'b1;

wire    pass_enable = i_a_en || r_a_en;

//------------------------------------------------------------------------------
assign  int_v   = pass_enable ? i_a_v : 1'b0;
assign  int_d   =               i_a_d;
assign  o_a_r   = pass_enable ? int_r : 1'b0;

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

`endif                                          // CORY_PASS
