//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_PACK2
    `define CORY_PACK2

//------------------------------------------------------------------------------
module cory_pack2 #(
    parameter   N   = 16,
    parameter   A0  = N,
    parameter   A1  = N,
    parameter   Z   = A0 + A1
) (
    input           clk,
    input           i_a0_v,
    input   [A0-1:0]i_a0_d,
    output          o_a0_r,
    input           i_a1_v,
    input   [A1-1:0]i_a1_d,
    output          o_a1_r,
    output          o_z_v,
    output  [Z-1:0] o_z_d,
    input           i_z_r,
    input           reset_n
);

//------------------------------------------------------------------------------

wire    [A0-1:0]    op_a0   = i_a0_d;
wire    [A1-1:0]    op_a1   = i_a1_d;
wire    [Z-1:0]     op_z    = {op_a1, op_a0};

//------------------------------------------------------------------------------
wire    op_r        = i_a0_v & i_a1_v;
wire    op_done     = o_z_v & i_z_r;

assign  o_z_v   = op_r;
assign  o_z_d   = op_z;
assign  o_a0_r  = op_done;
assign  o_a1_r  = op_done;

`ifdef SIM

`ifdef  CORY_MON
    cory_monitor #(Z) u_monitor_z (
        .clk        (clk),
        .i_v        (o_z_v),
        .i_d        (o_z_d),
        .i_r        (i_z_r),
        .reset_n    (reset_n)
    );
`endif                                          //  CORY_MON

`endif
endmodule


`endif
