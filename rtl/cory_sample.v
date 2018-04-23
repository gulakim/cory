//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_SAMPLE
    `define CORY_SAMPLE

//------------------------------------------------------------------------------
//  input data to filter tap with padding
//  input in_cnt, output out_cnt
//      ratio too big   => last input is used for output data
//      ratio too small => remaining inputs skipped
//------------------------------------------------------------------------------
module cory_sample #(
    parameter   N   = 8,                        // Natual data bits
    parameter   R   = 11                        // Resolution bit
) (
    input           clk,

    input           i_cmd_v,
    input   [R-1:0] i_cmd_in_cnt,               // 1 for 1
    input   [R-1:0] i_cmd_out_cnt,              // 1 for 1
    input   [15:0]  i_cmd_ratio,                // 16.8f
    output          o_cmd_r,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    output          o_z_v,
    output  [N-1:0] o_z_d,
    output  [R-1:0] o_z_cnt,                    // integer addr
    output  [R-1:0] o_z_pos,                    // integer position
    output  [7:0]   o_z_phase,                  // fractional position
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------

wire            cmd_din_v;
wire            cmd_din_r;

wire            cmd_dout_v;
wire            cmd_dout_r;

cory_dist #(.N(2)) u_cmd_dup (
    .clk            (clk),
    .i_a_v          (i_cmd_v),
    .o_a_r          (o_cmd_r),
    .o_zx_v         ({cmd_din_v, cmd_dout_v}),
    .i_zx_r         ({cmd_din_r, cmd_dout_r}),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            din_v;
wire    [N-1:0] din_d;
wire            din_r;
wire    [R-1:0] din_pos;
wire            din_last;

cory_loop #(.N(N), .W(R)) u_data_loop (
    .clk            (clk),
    .i_cmd_v        (cmd_din_v),
    .i_cmd_cnt      (i_cmd_in_cnt),
    .o_cmd_r        (cmd_din_r),

    .i_a_v          (i_a_v),
    .i_a_d          (i_a_d),
    .o_a_r          (o_a_r),

    .o_z_v          (din_v),
    .o_z_d          (din_d),
    .o_z_cnt        (din_pos),
    .o_z_last       (din_last),
    .i_z_r          (din_r),

    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------

reg             din_ob_v;
reg     [N-1:0] din_ob_d;
wire            din_ob_r;

always @(posedge clk or negedge reset_n)
    if (!reset_n) begin
        din_ob_v    <= 0;
        din_ob_d    <= 0;
    end
    else if (i_cmd_v & o_cmd_r) begin
        din_ob_v    <= 0;
        din_ob_d    <= 0;
    end
    else if (din_v & din_r & din_last) begin
        din_ob_v    <= 1;
        din_ob_d    <= din_d;
    end

//------------------------------------------------------------------------------

wire            din_ob_mux_v;
wire    [N-1:0] din_ob_mux_d;
wire            din_ob_mux_r;

cory_mux2 #(.N(N)) u_din_ob_mux (
    .clk            (clk),
    .i_a0_v         (din_v),
    .i_a0_d         (din_d),
    .o_a0_r         (din_r),
    .i_a1_v         (din_ob_v),
    .i_a1_d         (din_ob_d),
    .o_a1_r         (din_ob_r),
    .i_s_v          (1'b1),
    .i_s_d          (din_ob_v),
    .o_s_r          (),
    .o_z_v          (din_ob_mux_v),
    .o_z_d          (din_ob_mux_d),
    .i_z_r          (din_ob_mux_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------

wire            dout_v;
wire    [N-1:0] dout_d;
wire            dout_r;

wire    [R-1:0] dout_cnt;
wire            dout_last;

cory_loop #(.N(N), .W(R)) u_tap_loop (
    .clk            (clk),
    .i_cmd_v        (cmd_dout_v),
    .i_cmd_cnt      (i_cmd_out_cnt),
    .o_cmd_r        (cmd_dout_r),

    .i_a_v          (dout_v),
    .i_a_d          (dout_d),
    .o_a_r          (dout_r),

    .o_z_v          (o_z_v),
    .o_z_d          (o_z_d),
    .o_z_cnt        (dout_cnt),
    .o_z_last       (dout_last),
    .i_z_r          (i_z_r),

    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------

reg     [R+7:0] pix_f8;                         // R.8
wire    [R-1:0] pix_pos;
wire    [7:0]   pix_frac;

assign          {pix_pos, pix_frac} = pix_f8;

wire    [R+7:0] next_f8 = pix_f8 + i_cmd_ratio;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        pix_f8  <= 0;
    else if (cmd_dout_v & cmd_dout_r)
        pix_f8  <= 0;
    else if (dout_v & dout_r)
        pix_f8  <= next_f8;

wire    [R-1:0] next_pos;
wire    [7:0]   next_frac;
assign          {next_pos, next_frac}   = next_f8;

wire            pix_to_new      = pix_pos != next_pos;
wire            pix_in_din      = pix_pos == din_pos;

//------------------------------------------------------------------------------
assign  din_ob_mux_r    = din_v ? (pix_in_din ? (pix_to_new & dout_v & dout_r) : 1'b1) :
                          din_ob_v ? 1'b1 : 1'b0;

assign  dout_d          = din_ob_mux_d;

assign  dout_v          = din_v ? pix_in_din : din_ob_v;

//------------------------------------------------------------------------------
assign  o_z_cnt     = dout_cnt;
assign  o_z_pos     = pix_pos;
assign  o_z_phase   = pix_frac;

//------------------------------------------------------------------------------
`ifdef SIM
    cory_monitor #(.N(N)) u_mon_z (
        .clk            (clk),
        .i_v            (o_z_v),
        .i_d            (o_z_d),
        .i_r            (i_z_r),
        .reset_n        (reset_n)
    );

/*  it's handled
    always @(posedge clk)
        if (i_cmd_v & (((i_cmd_in_cnt * 256 / i_cmd_ratio)) > i_cmd_out_cnt)) begin
            $display ("ERROR:%m: ratio wrong, in(=%d) * ratio.8f(=%x) <= out(%d) @ $time", i_cmd_in_cnt, i_cmd_ratio, i_cmd_out_cnt);
            $finish;
        end
*/
`endif                                          // SIM
endmodule


`endif
