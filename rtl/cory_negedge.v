//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_NEGEDGE
    `define CORY_NEGEDGE

//------------------------------------------------------------------------------
//  falling edge detect -> 1shot generator
//------------------------------------------------------------------------------
module cory_negedge (
    input           clk,
    input           i_a,
    output          o_z,
    input           reset_n
);

reg     i_a_1d;
always @(posedge clk or negedge reset_n)
    if (!reset_n)
        i_a_1d    <= 0;
    else
        i_a_1d    <= i_a;

assign  o_z     = !i_a & i_a_1d;

endmodule


`endif
