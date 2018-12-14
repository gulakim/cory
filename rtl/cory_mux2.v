//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_MUX2
    `define CORY_MUX2

//------------------------------------------------------------------------------
module cory_mux2 # (
    parameter   N   = 8,                        // # of data bits
    parameter   Q   = 0
) (
    input           clk,

    input           i_a0_v,
    input   [N-1:0] i_a0_d,
    output          o_a0_r,

    input           i_a1_v,
    input   [N-1:0] i_a1_d,
    output          o_a1_r,

    input           i_s_v,
    input           i_s_d,
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
wire            sel;

assign  sel     = i_s_d;
assign  o_s_r   = int_r;

//------------------------------------------------------------------------------

assign  int_v   = sel == 0 ? i_a0_v && i_s_v :
                  sel == 1 ? i_a1_v && i_s_v : 0;

assign  int_d   = sel == 0 ? i_a0_d :
                  sel == 1 ? i_a1_d : 0;

assign  o_a0_r  = sel == 0 ? int_r : 0;
assign  o_a1_r  = sel == 1 ? int_r : 0;

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
