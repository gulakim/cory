//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_LOOP
    `define CORY_LOOP

//------------------------------------------------------------------------------
//  for loop, input -> output counting
//------------------------------------------------------------------------------
module cory_loop # (
    parameter   N   = 8,
    parameter   W   = 8
) (
    input           clk,

    input           i_cmd_v,
    input   [W-1:0] i_cmd_cnt,                  // 1 for 1
    output          o_cmd_r,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    output          o_z_v,
    output  [N-1:0] o_z_d,
    output          o_z_last,                   // last
    output  [W-1:0] o_z_cnt,
    input           i_z_r,

    input           reset_n

);

//------------------------------------------------------------------------------
wire            cmd_cnt_zero    = i_cmd_cnt == 0;

reg     [W-1:0] cnt;
wire            cnt_last        = cmd_cnt_zero ? 1'b1 :
                                                 cnt >= i_cmd_cnt - 1;

always @ (posedge clk or negedge reset_n)
    if (!reset_n)
        cnt <= 0;
    else if (o_z_v & i_z_r) begin
        if (cnt_last)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end

//------------------------------------------------------------------------------
assign  o_z_v   = i_cmd_v & (!cmd_cnt_zero) ? i_a_v : 1'b0;
assign  o_z_d   = i_cmd_v & (!cmd_cnt_zero) ? i_a_d : {N{1'b0}};
assign  o_a_r   = i_cmd_v ? i_a_v & i_z_r : 1'b0;
assign  o_z_last= cnt_last;
assign  o_z_cnt = cnt;

assign  o_cmd_r = o_z_v & i_z_r & cnt_last;

`ifdef  SIM
    cory_monitor #(.N(N)) u_mon_z (
        .clk            (clk),
        .i_v            (o_z_v),
        .i_d            (o_z_d),
        .i_r            (i_z_r),
        .reset_n        (reset_n)
    );
`endif
endmodule


`endif

