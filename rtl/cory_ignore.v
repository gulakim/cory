//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_IGNORE
    `define CORY_IGNORE

//------------------------------------------------------------------------------
//  ignore input or pass it to the output
//------------------------------------------------------------------------------
module cory_ignore # (
    parameter   N   = 8
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,
    input           i_a_ignore,

    output          o_z_v,
    output  [N-1:0] o_z_d,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
assign  o_z_v   = i_a_ignore ? 1'b0      : i_a_v;
assign  o_z_d   = i_a_ignore ? {N{1'b0}} : i_a_d;
assign  o_a_r   = i_a_ignore ? i_a_v     : i_z_r;

endmodule

`endif                                          // CORY_IGNORE
