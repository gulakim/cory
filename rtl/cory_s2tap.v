//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_S2TAP
    `define CORY_S2TAP

//------------------------------------------------------------------------------
//  input data to filter tap with padding
//------------------------------------------------------------------------------
module cory_s2tap #(
    parameter   N   = 8,                        // Natual data bits
    parameter   T   = 12,                       // Tap count
    parameter   R   = 11,                       // Resolution bit
    parameter   W   = N * T,                    // bits for Window
    parameter   ZEROPADDING = 0                 // zero padding for left,right ob. otherwise using the closest data
) (
    input           clk,

    input           i_cmd_v,
    input   [R-1:0] i_cmd_cnt,                  // 1 for 1
    output          o_cmd_r,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    output          o_z_v,
    output  [W-1:0] o_z_d,
    output  [R-1:0] o_z_cnt,
    output          o_z_last,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------

wire            cmd_data_v;
wire            cmd_data_r;

wire            cmd_tap_v;
wire            cmd_tap_r;

cory_dup2 #(.N(1)) u_cmd_dup (
    .clk            (clk),
    .i_a_v          (i_cmd_v),
    .i_a_d          (1'b0),
    .o_a_r          (o_cmd_r),
    .o_z0_v         (cmd_data_v),
    .o_z0_d         (),
    .i_z0_r         (cmd_data_r),
    .o_z1_v         (cmd_tap_v),
    .o_z1_d         (),
    .i_z1_r         (cmd_tap_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            data_v;
wire    [N-1:0] data_d;
wire            data_r;
wire    [R-1:0] data_cnt;
wire            data_first  = data_cnt == 0;
wire            data_last;

cory_loop #(.N(N), .W(R)) u_data_loop (
    .clk            (clk),
    .i_cmd_v        (cmd_data_v),
    .i_cmd_cnt      (i_cmd_cnt),
    .o_cmd_r        (cmd_data_r),

    .i_a_v          (i_a_v),
    .i_a_d          (i_a_d),
    .o_a_r          (o_a_r),

    .o_z_v          (data_v),
    .o_z_d          (data_d),
    .o_z_cnt        (data_cnt),
    .o_z_last       (data_last),
    .i_z_r          (data_r),

    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
localparam      PAD_LEFT    = (T-1) / 2;        // (4-1)/2=1, (3-1)/2=1
localparam      PAD_RIGHT   = T / 2;            // 4/2=2, 3/2=1
localparam      P   = 4;                        // log2(max_padding)

reg             pad_right_v;
reg     [P-1:0] pad_right_cnt;
wire            pad_right_r;

wire            pad_right_cnt_last  = pad_right_cnt >= PAD_RIGHT - 1;

always @(posedge clk or negedge reset_n)
    if (!reset_n) begin
        pad_right_v     <= 0;
        pad_right_cnt   <= 0;
    end
    else if (data_v & data_r & data_last) begin
        pad_right_v     <= 1;
        pad_right_cnt   <= 0;
    end
    else if (pad_right_v & pad_right_r) begin
        if (pad_right_cnt_last)
            pad_right_v     <= 0;
        else
            pad_right_cnt   <= pad_right_cnt + 1;
    end

//------------------------------------------------------------------------------
//  x0 x1 x2 x3 : T=4
//  p0 p0 p1 p2
//------------------------------------------------------------------------------
//  x0 x1 x2    : T=3
//  p0 p0 p1
//------------------------------------------------------------------------------
wire            window_v;
wire    [W-1:0] window_d;
wire            window_r;

wire    [PAD_LEFT*N-1:0]    pad_left    = ZEROPADDING ? 0 : {PAD_LEFT{data_d}};
wire    [N-1:0]             pad_right   = ZEROPADDING ? 0 : window_d[W-1:W-N];

wire            win_in_v        = data_v | pad_right_v;
wire    [W-1:0] win_in_d        = data_v ? (data_first ? {data_d, pad_left, {(PAD_RIGHT*N){1'b0}}} :
                                                       {data_d, window_d[W-1:N]}) :
                                  pad_right_v ? {pad_right, window_d[W-1:N]} : {W{1'bx}};
wire            win_in_r;

assign          data_r          = data_v ? win_in_r : 1'b0;
assign          pad_right_r     = data_v ? 1'b0     : win_in_r;


cory_flop #(.N(W)) u_window (                   // do not replace with other cory module
    .clk            (clk),
    .i_a_v          (win_in_v),
    .i_a_d          (win_in_d),
    .o_a_r          (win_in_r),
    .o_z_v          (window_v),
    .o_z_d          (window_d),
    .i_z_r          (window_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------

reg             ignore_v;
reg     [P-1:0] ignore_cnt;
wire            ignore_cnt_last   = ignore_cnt >= PAD_RIGHT - 1;        // ignore what will be padded

always @(posedge clk or negedge reset_n)
    if (!reset_n) begin
        ignore_v    <= 1;
        ignore_cnt  <= 0;
    end
    else if (cmd_tap_v & cmd_tap_r) begin
        ignore_v    <= 1;
        ignore_cnt  <= 0;
    end
    else if (window_v & window_r) begin
        if (ignore_cnt_last)
            ignore_v    <= 0;
        else
            ignore_cnt  <= ignore_cnt + 1;
    end

//------------------------------------------------------------------------------

wire            tap_v       = ignore_v ? 1'b0 : window_v;
wire    [W-1:0] tap_d       = window_d;
wire            tap_r;

assign          window_r    = ignore_v ? window_v : tap_r;

//------------------------------------------------------------------------------

cory_loop #(.N(W), .W(R)) u_tap_loop (
    .clk            (clk),
    .i_cmd_v        (cmd_tap_v),
    .i_cmd_cnt      (i_cmd_cnt),
    .o_cmd_r        (cmd_tap_r),

    .i_a_v          (tap_v),
    .i_a_d          (tap_d),
    .o_a_r          (tap_r),

    .o_z_v          (o_z_v),
    .o_z_d          (o_z_d),
    .o_z_cnt        (o_z_cnt),
    .o_z_last       (o_z_last),
    .i_z_r          (i_z_r),

    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
`ifdef SIM
    cory_monitor #(.N(W)) u_mon_tap (
        .clk            (clk),
        .i_v            (o_z_v),
        .i_d            (o_z_d),
        .i_r            (i_z_r),
        .reset_n        (reset_n)
    );

//    initial begin
//        if (T % 2 != 0) begin
//            $display ("ERROR:%m: TAP size (T=%d) must be even", T);
//            $finish;
//        end
//    end
    initial begin
        if (PAD_RIGHT > 16) begin
            $display ("ERROR:%m: TAP size (T=%d) is bigger than pad_cnt(see pad_right_cnt)", T);
            $finish;
        end
    end

`endif                                          // SIM
endmodule


`endif
