//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_SBD2VR
    `define CORY_SBD2VR

module cory_sbd2vr (
    input           clk,

    input           i_start,
    output          o_busy,
    output          o_done,

    output          o_v,
    input           i_r,

    input           reset_n
);

reg         valid;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        valid   <= 0;
    else if (i_start)
        valid   <= 1;
    else if (o_done)
        valid   <= 0;

assign  o_v     = valid;

assign      o_done  = i_r;

reg         busy;

always @ (posedge clk or negedge reset_n)
    if (!reset_n)
        busy    <= 0;
    else if (i_start)
        busy    <= 1;
    else if (o_done)
        busy    <= 0;

assign      o_busy  = busy;

endmodule
`endif

