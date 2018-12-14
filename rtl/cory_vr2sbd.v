//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_VR2SBD
    `define CORY_VR2SBD

module cory_vr2sbd (
    input           clk,

    input           i_v,
    output          o_r,

    output          o_start,
    output          o_busy,
    input           i_done,

    input           reset_n
);

cory_posedge u_start (
    .clk            (clk),
    .i_a            (i_v & (!o_r)),
    .o_z            (o_start),
    .reset_n        (reset_n)
);

assign      o_r     = i_done;

reg         busy;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        busy    <= 0;
    else if (o_start)
        busy    <= 1;
    else if (i_done)
        busy    <= 0;

assign      o_busy  = busy;

endmodule
`endif
