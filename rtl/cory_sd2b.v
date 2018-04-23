//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_SD2B
    `define CORY_SD2B

module cory_sd2b (
    input           clk,
    input           i_start,
    input           i_done,
    output          o_busy,
    input           reset_n
);

reg         busy;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        busy    <= 0;
    else if (i_start)
        busy    <= 1;
    else if (i_done)
        busy    <= 0;

assign      o_busy  = busy;

endmodule
`endif

