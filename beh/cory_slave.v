//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------

`ifndef CORY_SLAVE
    `define CORY_SLAVE

    `ifndef CORY_FILENAME
        `define CORY_FILENAME  64
    `endif
    `ifndef CORY_DUMP_DIR
        `define CORY_DUMP_DIR   "dump"
    `endif

//------------------------------------------------------------------------------
//  slave
//  R   : wait cycle 
//  V   : 0: ----, 1: ----, 2: to a file
//------------------------------------------------------------------------------

module cory_slave # (
    parameter   N   = 64,
    parameter   R   = 0,
    parameter   V   = 0                         // 2: dump enabled
) (
    input           clk,
    input           i_v,
    input   [N-1:0] i_d,
    output          o_r,
    input           reset_n
);

`ifdef  SIM
//------------------------------------------------------------------------------
integer cnt_r;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        cnt_r   <= 0;
    else if (i_v) begin
        if (cnt_r >= R)
            cnt_r   <= 0;
        else
            cnt_r   <= cnt_r + 1;
    end

assign  o_r = i_v && (cnt_r >= R);

//------------------------------------------------------------------------------
`ifdef  CORY_MON
    cory_monitor #(.N(N), .V(V)) dump (
        .clk        (clk),
        .i_v        (i_v),
        .i_d        (i_d),
        .i_r        (o_r),
        .reset_n    (reset_n)
    );
`endif                                          //  CORY_MON
`endif                                          // SIM

endmodule

`endif
