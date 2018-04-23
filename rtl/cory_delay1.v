//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_DELAY1
    `define CORY_DELAY1

//------------------------------------------------------------------------------
//  1-cycle delay
//------------------------------------------------------------------------------
module cory_delay1 #(
    parameter   N   = 1
) (
    input           clk,
    input   [N-1:0] i_a,
    output  [N-1:0] o_z,
    input           reset_n
);

reg     [N-1:0] delay;
always @(posedge clk or negedge reset_n)
    if (!reset_n)
        delay   <= 0;
    else
        delay   <= i_a;

assign  o_z     = delay;

endmodule


`endif
