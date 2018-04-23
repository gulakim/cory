//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_YUV2RGB
    `define CORY_YUV2RGB

//------------------------------------------------------------------------------
//  yuv 2 rgb conversion based on the equation
//------------------------------------------------------------------------------
module cory_yuv2rgb #(
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
wire            rgb_v;
wire    [23:0]  rgb_d;
wire            rgb_r;

_cory_yuv2rgb_core u_cory_yuv2rgb_core (.yuv (i_a_d), .rgb (rgb_d));

assign          rgb_v   = i_a_v;
assign          o_a_r   = rgb_r;

//------------------------------------------------------------------------------

cory_queue #(.N(24), .Q(Q)) u_reg (
    .clk            (clk),
    .i_a_v          (rgb_v),
    .i_a_d          (rgb_d),
    .o_a_r          (rgb_r),
    .o_z_v          (o_z_v),
    .o_z_d          (o_z_d),
    .i_z_r          (i_z_r),
    .reset_n        (reset_n)
);

endmodule

//------------------------------------------------------------------------------
module _cory_yuv2rgb_core (
    yuv,
    rgb
);

input  [23:0]  yuv;
output [23:0]  rgb;

wire   [ 7:0]  y  = yuv[23:16];
wire   [ 7:0]  cb = yuv[15: 8];
wire   [ 7:0]  cr = yuv[ 7: 0];
// 
// R = 298 *(y-16)                + 409*(cr-128) 
// G = 298 *(y-16) - 100*(cb-128) - 208*(cr-128)
// B = 298 *(y-16) + 516*(cb-128)

wire    [16:0]   CM0 = y*298;
//wire    [19:0]   rt = CM0          + 409*cr - 57120 (+128);
//wire    [19:0]   gt = CM0 - 100*cb - 208*cr + 34656 (+128);
//wire    [19:0]   bt = CM0 + 516*cb          - 70816 (+128);

wire    [19:0]   rt = CM0          + 409*cr - 56992;

wire    [19:0]   g1 = CM0 + 34784;
wire    [19:0]   g2 =100*cb + 208*cr;
//wire    [19:0]   gt = CM0 - 100*cb - 208*cr + 34784;
wire    [19:0]   gt = g1-g2;
wire    [19:0]   bt = CM0 + 516*cb          - 70688;

wire    [11:0]   rt1 = rt[19:8];
wire    [11:0]   gt1 = gt[19:8];
wire    [11:0]   bt1 = bt[19:8];

wire    [ 7:0]   r =  rt1[11] ? 8'd0 : (rt1[10:8] ? 8'd255 : rt1[7:0]);
wire    [ 7:0]   g =  gt1[11] ? 8'd0 : (gt1[10:8] ? 8'd255 : gt1[7:0]);
wire    [ 7:0]   b =  bt1[11] ? 8'd0 : (bt1[10:8] ? 8'd255 : bt1[7:0]);

assign        rgb = {r, g, b};

endmodule
`endif                                          // CORY_YUV2RGB
