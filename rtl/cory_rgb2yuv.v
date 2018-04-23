//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_RGB2YUV
    `define CORY_RGB2YUV

//------------------------------------------------------------------------------
//  rgb2yuv conversion based on equation
//------------------------------------------------------------------------------
module cory_rgb2yuv #(
    parameter   Q   = 0
) (
    input           clk,

    input           i_a_v,
    input   [23:0]  i_a_d,
    output          o_a_r,

    output          o_z_v,
    output  [23:0]  o_z_d,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
wire            yuv_v;
wire    [23:0]  yuv_d;
wire            yuv_r;

_cory_rgb2yuv_core u_cory_rgb2yuv_core (.rgb (i_a_d), .yuv (yuv_d));

assign          yuv_v   = i_a_v;
assign          o_a_r   = yuv_r;

//------------------------------------------------------------------------------

cory_queue #(.N(24), .Q(Q)) u_reg (
    .clk            (clk),
    .i_a_v          (yuv_v),
    .i_a_d          (yuv_d),
    .o_a_r          (yuv_r),
    .o_z_v          (o_z_v),
    .o_z_d          (o_z_d),
    .i_z_r          (i_z_r),
    .reset_n        (reset_n)
);

endmodule

//------------------------------------------------------------------------------
module _cory_rgb2yuv_core (
    rgb,
    yuv
);

input   [23:0]  rgb;
output  [23:0]  yuv;

//----------------------------------------------------------------------------------
//  Y   = {66 *R + 129*G + 25*B  + 128} >> 8 + 16
//  U   = {-38*R - 74 *G + 112*B + 128} >> 8 + 128
//  V   = {112*R - 94 *G - 18 *B  +128} >> 8 + 128
//----------------------------------------------------------------------------------

wire    [ 7:0] r = rgb[23:16];
wire    [ 7:0] g = rgb[15: 8];
wire    [ 7:0] b = rgb[ 7: 0];

wire    [15:0] y0 = 66*r + 129*g + 25* b;

wire    [14:0] u0 = 38*r + 74 *g;
wire    [14:0] u1 = 112*b;
wire    [15:0] u2 = {1'b0, u1} - {1'b0, u0};

wire    [14:0] v0 = 112*r;
wire    [14:0] v1 = 94*g + 18*b;
wire    [15:0] v2 = {1'b0, v0} - {1'b0, v1};

wire    [ 7:0] y  = y0[15:8] + y0[7] + 16;
wire    [ 8:0] u  = 128 + u2[15:8] + u2[7];
wire    [ 8:0] v  = 128 + v2[15:8] + v2[7];

assign  yuv = {y, u[7:0],v[7:0] };


endmodule
`endif                                          // CORY_RGB2YUV
