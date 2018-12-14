//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_RGB_DEC2
    `define CORY_RGB_DEC2

//-----------------------------------------------------------------------------------
//  rgb level decimation by 2, 3-tap average
//-----------------------------------------------------------------------------------
module cory_rgb_dec2 # (
    parameter   Q   = 0
) (
    input           clk,
    input           i_a_v,
    input   [23:0]  i_a_d,
    input           i_a_first,
    output          o_a_r,
    output          o_z_v,
    output  [23:0]  o_z_d,
    input           i_z_r,
    input           reset_n
);

//-----------------------------------------------------------------------------------
wire    [7:0]   a_r;
wire    [7:0]   a_g;
wire    [7:0]   a_b;
assign  {a_r, a_g, a_b} = i_a_d;

wire    [7:0]   z_r;
wire    [7:0]   z_g;
wire    [7:0]   z_b;
assign  o_z_d   = {z_r, z_g, z_b};

//-----------------------------------------------------------------------------------
cory_dec2 #(.N(8), .Q(Q)) u_r (
    .clk            (clk),
    .i_a_v          (i_a_v),
    .i_a_d          (a_r),
    .i_a_first      (i_a_first),
    .o_a_r          (o_a_r),
    .o_z_v          (o_z_v),
    .o_z_d          (z_r),
    .i_z_r          (i_z_r),
    .reset_n        (reset_n)
);

cory_dec2 #(.N(8), .Q(Q)) u_g (
    .clk            (clk),
    .i_a_v          (i_a_v),
    .i_a_d          (a_g),
    .i_a_first      (i_a_first),
    .o_a_r          (),
    .o_z_v          (),
    .o_z_d          (z_g),
    .i_z_r          (i_z_r),
    .reset_n        (reset_n)
);

cory_dec2 #(.N(8), .Q(Q)) u_b (
    .clk            (clk),
    .i_a_v          (i_a_v),
    .i_a_d          (a_b),
    .i_a_first      (i_a_first),
    .o_a_r          (),
    .o_z_v          (),
    .o_z_d          (z_b),
    .i_z_r          (i_z_r),
    .reset_n        (reset_n)
);

endmodule


`endif
