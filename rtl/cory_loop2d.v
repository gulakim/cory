//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_LOOP2D
    `define CORY_LOOP2D

//------------------------------------------------------------------------------
//  loop cnt number of valid-ready
//------------------------------------------------------------------------------
module cory_loop2d # (
    parameter   N   = 8,
    parameter   W   = 8,
    parameter   H   = 8
) (
    input           clk,

    input           i_cmd_v,
    input   [W-1:0] i_cmd_width,                // 1 for 1
    input   [H-1:0] i_cmd_height,               // 1 for 1
    output          o_cmd_r,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    output          o_z_v,
    output  [N-1:0] o_z_d,
    output  [W-1:0] o_z_cnt_x,
    output          o_z_last_x,                 // last
    output  [H-1:0] o_z_cnt_y,
    output          o_z_last_y,                 // last
    input           i_z_r,

    input           reset_n

);

wire            cmd_x_v;
wire            cmd_x_r;

cory_loop #(.N(1), .W(H)) u_height (
    .clk            (clk),
    .i_cmd_v        (i_cmd_v),
    .i_cmd_cnt      (i_cmd_height),
    .o_cmd_r        (o_cmd_r),
    .i_a_v          (1'b1),
    .i_a_d          (1'b1),
    .o_a_r          (),
    .o_z_v          (cmd_x_v),
    .o_z_d          (),                         // width
    .i_z_r          (cmd_x_r),
    .o_z_cnt        (o_z_cnt_y),
    .o_z_last       (o_z_last_y),
    .reset_n        (reset_n)
);

cory_loop #(.N(N), .W(W)) u_width (
    .clk            (clk),
    .i_cmd_v        (cmd_x_v),
    .i_cmd_cnt      (i_cmd_width),
    .o_cmd_r        (cmd_x_r),
    .i_a_v          (i_a_v),
    .i_a_d          (i_a_d),
    .o_a_r          (o_a_r),
    .o_z_v          (o_z_v),
    .o_z_d          (o_z_d),
    .i_z_r          (i_z_r),
    .o_z_cnt        (o_z_cnt_x),
    .o_z_last       (o_z_last_x),
    .reset_n        (reset_n)
);

endmodule
`endif


