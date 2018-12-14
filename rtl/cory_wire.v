//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_WIRE
    `define CORY_WIRE

//------------------------------------------------------------------------------
//  just wire
//------------------------------------------------------------------------------
module cory_wire # (
    parameter   N   = 8
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    output          o_z_v,
    output  [N-1:0] o_z_d,
    input           i_z_r,

    input           reset_n

);

//------------------------------------------------------------------------------

assign  o_z_v   = i_a_v;
assign  o_z_d   = i_a_d;
assign  o_a_r   = i_z_r;

endmodule


`endif
