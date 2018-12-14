//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_ARB4_BANDWIDTH
    `define CORY_ARB4_BANDWIDTH

//------------------------------------------------------------------------------
//  limitation:
//      timing critical for u_sel
//------------------------------------------------------------------------------
module cory_arb4_bandwidth # (
    parameter   N   = 8,                        // # of data bits
    parameter   B   = 8,                        // # of bw bits
    parameter   L   = 4,                        // # of weight bits (arlen)
    parameter   Q   = 0                         // queue on the output
) (
    input           clk,

    input           i_a0_v,
    input   [N-1:0] i_a0_d,
    output          o_a0_r,
    input   [L-1:0] i_a0_wt,                    // increment, like arlen, 0 for 1 weight
    input   [B-1:0] i_a0_bw,                    // 0 for 1 req, 255 for 256 req

    input           i_a1_v,
    input   [N-1:0] i_a1_d,
    output          o_a1_r,
    input   [L-1:0] i_a1_wt,                    // increment, like arlen
    input   [B-1:0] i_a1_bw,                    // 0 for 1 req, 255 for 256 req

    input           i_a2_v,
    input   [N-1:0] i_a2_d,
    output          o_a2_r,
    input   [L-1:0] i_a2_wt,                    // increment, like arlen
    input   [B-1:0] i_a2_bw,                    // 0 for 1 req, 255 for 256 req

    input           i_a3_v,
    input   [N-1:0] i_a3_d,
    output          o_a3_r,
    input   [L-1:0] i_a3_wt,                    // increment, like arlen
    input   [B-1:0] i_a3_bw,                    // 0 for 1 req, 255 for 256 req

    output          o_z_v,
    output  [N-1:0] o_z_d,
    output  [1:0]   o_z_s,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
wire            int_v;
wire    [N-1:0] int_d;
wire            int_r;
wire    [1:0]   int_s;

//------------------------------------------------------------------------------
wire    [1:0]   sel;

_cory_arb4_bandwidth_sel #(.B(B), .L(L)) u_sel (
    .clk        (clk),
    .i_a0_v     (i_a0_v),
    .i_a0_bw    (i_a0_bw),
    .i_a0_wt    (i_a0_wt),
    .i_a1_v     (i_a1_v),
    .i_a1_bw    (i_a1_bw),
    .i_a1_wt    (i_a1_wt),
    .i_a2_v     (i_a2_v),
    .i_a2_bw    (i_a2_bw),
    .i_a2_wt    (i_a2_wt),
    .i_a3_v     (i_a3_v),
    .i_a3_bw    (i_a3_bw),
    .i_a3_wt    (i_a3_wt),
    .i_z_v      (int_v),
    .i_z_r      (int_r),
    .o_sel      (sel),
    .reset_n    (reset_n)
);

//------------------------------------------------------------------------------
cory_mux4 #(.N(N)) u_mux4 (
    .clk        (clk),
    .i_a0_v     (i_a0_v),
    .i_a0_d     (i_a0_d),
    .o_a0_r     (o_a0_r),
    .i_a1_v     (i_a1_v),
    .i_a1_d     (i_a1_d),
    .o_a1_r     (o_a1_r),
    .i_a2_v     (i_a2_v),
    .i_a2_d     (i_a2_d),
    .o_a2_r     (o_a2_r),
    .i_a3_v     (i_a3_v),
    .i_a3_d     (i_a3_d),
    .o_a3_r     (o_a3_r),
    .i_s_v      (1'b1),
    .i_s_d      (sel),
    .o_s_r      (),
    .o_z_v      (int_v),
    .o_z_d      (int_d),
    .i_z_r      (int_r),
    .reset_n    (reset_n)
);

assign  int_s   = sel;

//------------------------------------------------------------------------------
cory_queue #(.N(2+N), .Q(Q)) u_queue (
    .clk            (clk),
    .i_a_v          (int_v),
    .i_a_d          ({int_s, int_d}),
    .o_a_r          (int_r),
    .o_z_v          (o_z_v),
    .o_z_d          ({o_z_s, o_z_d}),
    .i_z_r          (i_z_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
`ifdef  SIM
    always @(*) begin
        if (i_a0_bw < (2**L-1) && i_a0_bw != 0)
            $display ("WARNING:%m: b0 bandwidth = %1d words < 2^L(%1d), may be too small", i_a0_bw+1, L, $time);
        if (i_a1_bw < (2**L-1) && i_a1_bw != 0)
            $display ("WARNING:%m: b1 bandwidth = %1d words < 2^L(%1d), may be too small", i_a1_bw+1, L, $time);
        if (i_a2_bw < (2**L-1) && i_a2_bw != 0)
            $display ("WARNING:%m: b2 bandwidth = %1d words < 2^L(%1d), may be too small", i_a2_bw+1, L, $time);
        if (i_a3_bw < (2**L-1) && i_a3_bw != 0)
            $display ("WARNING:%m: b3 bandwidth = %1d words < 2^L(%1d), may be too small", i_a3_bw+1, L, $time);
    end
`endif  // SIM
endmodule

//------------------------------------------------------------------------------
module _cory_arb4_bandwidth_sel #(
    parameter   B   = 8,
    parameter   L   = 4
) (
    input           clk,
    input           i_a0_v,
    input   [B-1:0] i_a0_bw,                    // bw==0, not getting priority
    input   [L-1:0] i_a0_wt,
    input           i_a1_v,
    input   [B-1:0] i_a1_bw,
    input   [L-1:0] i_a1_wt,
    input           i_a2_v,
    input   [B-1:0] i_a2_bw,
    input   [L-1:0] i_a2_wt,
    input           i_a3_v,
    input   [B-1:0] i_a3_bw,
    input   [L-1:0] i_a3_wt,
    input           i_z_v,
    input           i_z_r,
    output  [1:0]   o_sel,
    input           reset_n
);

//------------------------------------------------------------------------------
wire    [1:0]   sel;
assign          o_sel   = sel;

reg     [1:0]   pri;

wire    [3:0]   active;
assign          active[0]   = i_a0_bw != 0;
assign          active[1]   = i_a1_bw != 0;
assign          active[2]   = i_a2_bw != 0;
assign          active[3]   = i_a3_bw != 0;

wire    [B:0]   bandwidth[0:3];
assign          bandwidth[0]    = i_a0_bw + 1'b1;
assign          bandwidth[1]    = i_a1_bw + 1'b1;
assign          bandwidth[2]    = i_a2_bw + 1'b1;
assign          bandwidth[3]    = i_a3_bw + 1'b1;

wire    [L:0]   weight[0:3];
assign          weight[0]       = i_a0_wt + 1'b1;
assign          weight[1]       = i_a1_wt + 1'b1;
assign          weight[2]       = i_a2_wt + 1'b1;
assign          weight[3]       = i_a3_wt + 1'b1;

//------------------------------------------------------------------------------
reg     [B:0]   cnt[0:3];
wire    [B:0]   cnt_dec[0:3];
wire    [B:0]   cnt_inc[0:3];
wire    [3:0]   cnt_inc_last;                   // satisfied
wire    [3:0]   cnt_inc_full;                   // over counter limit
wire    [3:0]   cnt_inc_over;                   // over bandwidth
reg     [B:0]   cnt_next[0:3];
wire    [B:0]   cnt_decay[0:3];

always @(posedge clk or negedge reset_n)
    if (!reset_n) begin
        cnt[0]  <= 0;
        cnt[1]  <= 0;
        cnt[2]  <= 0;
        cnt[3]  <= 0;
    end
    else if (i_z_v & i_z_r) begin
        case (sel)
        0: begin
            cnt[0]  <= cnt_next[0];
            cnt[1]  <= cnt_decay[1];
            cnt[2]  <= cnt_decay[2];
            cnt[3]  <= cnt_decay[3];
        end
        1: begin
            cnt[0]  <= cnt_decay[0];
            cnt[1]  <= cnt_next[1];
            cnt[2]  <= cnt_decay[2];
            cnt[3]  <= cnt_decay[3];
        end
        2: begin
            cnt[0]  <= cnt_decay[0];
            cnt[1]  <= cnt_decay[1];
            cnt[2]  <= cnt_next[2];
            cnt[3]  <= cnt_decay[3];
        end
        3: begin
            cnt[0]  <= cnt_decay[0];
            cnt[1]  <= cnt_decay[1];
            cnt[2]  <= cnt_decay[2];
            cnt[3]  <= cnt_next[3];
        end
        endcase
    end

assign  cnt_decay[0]    = cnt[0] ? cnt[0] - 1'b1 : cnt[0];
assign  cnt_decay[1]    = cnt[1] ? cnt[1] - 1'b1 : cnt[1];
assign  cnt_decay[2]    = cnt[2] ? cnt[2] - 1'b1 : cnt[2];
assign  cnt_decay[3]    = cnt[3] ? cnt[3] - 1'b1 : cnt[3];

assign  cnt_inc[0]  = cnt[0] + weight[0];
assign  cnt_inc[1]  = cnt[1] + weight[1];
assign  cnt_inc[2]  = cnt[2] + weight[2];
assign  cnt_inc[3]  = cnt[3] + weight[3];

assign  cnt_dec[0]  = cnt_inc[0] - bandwidth[0];
assign  cnt_dec[1]  = cnt_inc[1] - bandwidth[1];
assign  cnt_dec[2]  = cnt_inc[2] - bandwidth[2];
assign  cnt_dec[3]  = cnt_inc[3] - bandwidth[3];

wire    [B:0]   cnt_0       = cnt[0];
wire    [B:0]   cnt_1       = cnt[1];
wire    [B:0]   cnt_2       = cnt[2];
wire    [B:0]   cnt_3       = cnt[3];
wire    [B:0]   cnt_inc_0   = cnt_inc[0];
wire    [B:0]   cnt_inc_1   = cnt_inc[1];
wire    [B:0]   cnt_inc_2   = cnt_inc[2];
wire    [B:0]   cnt_inc_3   = cnt_inc[3];
wire    [B:0]   cnt_dec_0   = cnt_dec[0];
wire    [B:0]   cnt_dec_1   = cnt_dec[1];
wire    [B:0]   cnt_dec_2   = cnt_dec[2];
wire    [B:0]   cnt_dec_3   = cnt_dec[3];
wire            cnt_inc_last_0  = cnt_inc_last[0];
wire            cnt_inc_last_1  = cnt_inc_last[1];
wire            cnt_inc_last_2  = cnt_inc_last[2];
wire            cnt_inc_last_3  = cnt_inc_last[3];
wire            cnt_inc_full_0  = cnt_inc_full[0];
wire            cnt_inc_full_1  = cnt_inc_full[1];
wire            cnt_inc_full_2  = cnt_inc_full[2];
wire            cnt_inc_full_3  = cnt_inc_full[3];

always @(*)
    if (sel == pri)
        case (sel)
        0:  cnt_next[0] <= cnt_inc_last_0 ? cnt_dec_0 : cnt_inc_0;
        1:  cnt_next[1] <= cnt_inc_last_1 ? cnt_dec_1 : cnt_inc_1;
        2:  cnt_next[2] <= cnt_inc_last_2 ? cnt_dec_2 : cnt_inc_2;
        3:  cnt_next[3] <= cnt_inc_last_3 ? cnt_dec_3 : cnt_inc_3;
        endcase
    else
        case (sel)
        0:  cnt_next[0] <= cnt_inc_full_0 ? {(B+1){1'b1}} : cnt_inc_0;
        1:  cnt_next[1] <= cnt_inc_full_1 ? {(B+1){1'b1}} : cnt_inc_1;
        2:  cnt_next[2] <= cnt_inc_full_2 ? {(B+1){1'b1}} : cnt_inc_2;
        3:  cnt_next[3] <= cnt_inc_full_3 ? {(B+1){1'b1}} : cnt_inc_3;
        endcase

assign  cnt_inc_full[0] = cnt_inc[0] < cnt[0];
assign  cnt_inc_full[1] = cnt_inc[1] < cnt[1];
assign  cnt_inc_full[2] = cnt_inc[2] < cnt[2];
assign  cnt_inc_full[3] = cnt_inc[3] < cnt[3];

assign  cnt_inc_over[0] = cnt_inc[0] >= bandwidth[0];
assign  cnt_inc_over[1] = cnt_inc[1] >= bandwidth[1];
assign  cnt_inc_over[2] = cnt_inc[2] >= bandwidth[2];
assign  cnt_inc_over[3] = cnt_inc[3] >= bandwidth[3];

assign  cnt_inc_last[0] = cnt_inc_over[0] || cnt_inc_full[0];
assign  cnt_inc_last[1] = cnt_inc_over[1] || cnt_inc_full[1];
assign  cnt_inc_last[2] = cnt_inc_over[2] || cnt_inc_full[2];
assign  cnt_inc_last[3] = cnt_inc_over[3] || cnt_inc_full[3];

//------------------------------------------------------------------------------

always @(posedge clk or negedge reset_n)
    if (!reset_n) begin
        pri <= 0;
    end
    else if (i_z_v & i_z_r & sel == pri) begin
        casex ({pri, active})
        6'b00_xx1x: if (cnt_inc_last[0]) pri <= 1;
        6'b00_x10x: if (cnt_inc_last[0]) pri <= 2;
        6'b00_100x: if (cnt_inc_last[0]) pri <= 3;
        6'b00_0001: if (cnt_inc_last[0]) pri <= 0;
        6'b01_x1xx: if (cnt_inc_last[1]) pri <= 2;
        6'b01_10xx: if (cnt_inc_last[1]) pri <= 3;
        6'b01_00x1: if (cnt_inc_last[1]) pri <= 0;
        6'b01_0010: if (cnt_inc_last[1]) pri <= 1;
        6'b10_1xxx: if (cnt_inc_last[2]) pri <= 3;
        6'b10_0xx1: if (cnt_inc_last[2]) pri <= 0;
        6'b10_0x10: if (cnt_inc_last[2]) pri <= 1;
        6'b10_0100: if (cnt_inc_last[2]) pri <= 2;
        6'b11_xxx1: if (cnt_inc_last[3]) pri <= 0;
        6'b11_xx10: if (cnt_inc_last[3]) pri <= 1;
        6'b11_x100: if (cnt_inc_last[3]) pri <= 2;
        6'b11_1000: if (cnt_inc_last[3]) pri <= 3;
        endcase
    end

//------------------------------------------------------------------------------

wire    [B+1:0] served[0:3];
assign          served[0]   = i_a0_v ? ({B{1'b1}} + cnt[0] - bandwidth[0]) : {(B+2){1'b1}};
assign          served[1]   = i_a1_v ? ({B{1'b1}} + cnt[1] - bandwidth[1]) : {(B+2){1'b1}};
assign          served[2]   = i_a2_v ? ({B{1'b1}} + cnt[2] - bandwidth[2]) : {(B+2){1'b1}};
assign          served[3]   = i_a3_v ? ({B{1'b1}} + cnt[3] - bandwidth[3]) : {(B+2){1'b1}};

wire    [B+1:0] served_0    = served[0];
wire    [B+1:0] served_1    = served[1];
wire    [B+1:0] served_2    = served[2];
wire    [B+1:0] served_3    = served[3];

reg     [1:0]   sel_min;

always @(*)
    case (pri)
    0: sel_min  <= i_a0_v ? 0 : f_min4 (served_0, served_1, served_2, served_3, pri);
    1: sel_min  <= i_a1_v ? 1 : f_min4 (served_0, served_1, served_2, served_3, pri);
    2: sel_min  <= i_a2_v ? 2 : f_min4 (served_0, served_1, served_2, served_3, pri);
    3: sel_min  <= i_a3_v ? 3 : f_min4 (served_0, served_1, served_2, served_3, pri);
    endcase

//------------------------------------------------------------------------------
reg             pending;
reg     [1:0]   pri_pending;

always @(posedge clk or negedge reset_n)
    if (!reset_n) begin
        pending     <= 0;
        pri_pending <= 0;
    end
    else if (i_z_v & !i_z_r) begin
        pending     <= 1;
        pri_pending <= sel_min;
    end
    else if (i_z_v & i_z_r) begin
        pending     <= 0;
    end

assign  sel = pending ? pri_pending : sel_min;

//------------------------------------------------------------------------------
function [1:0] f_min4;
    input   [B+1:0]   a0;
    input   [B+1:0]   a1;
    input   [B+1:0]   a2;
    input   [B+1:0]   a3;
    input   [1:0]   seed;
begin
    // one minimum
         if ((a0 < a1) & (a0 < a2) & (a0 < a3))
        f_min4  = 0;
    else if ((a1 < a0) & (a1 < a2) & (a1 < a3))
        f_min4  = 1;
    else if ((a2 < a0) & (a2 < a1) & (a2 < a3))
        f_min4  = 2;
    else if ((a3 < a0) & (a3 < a1) & (a3 < a2))
        f_min4  = 3;

    // two minimum
    else if ((a0 == a1) & (a0 < a2) & (a0 < a3)) begin
        case (seed)
        0:  f_min4  = 0;
        1:  f_min4  = 1;
        2:  f_min4  = 0;
        3:  f_min4  = 0;
        endcase
    end
    else if ((a1 < a0) & (a1 == a2) & (a1 < a3)) begin
        case (seed)
        0:  f_min4  = 1;
        1:  f_min4  = 1;
        2:  f_min4  = 2;
        3:  f_min4  = 1;
        endcase
    end
    else if ((a2 < a0) & (a2 < a1) & (a2 == a3)) begin
        case (seed)
        0:  f_min4  = 2;
        1:  f_min4  = 2;
        2:  f_min4  = 2;
        3:  f_min4  = 3;
        endcase
    end
    else if ((a3 == a0) & (a3 < a1) & (a3 < a2)) begin
        case (seed)
        0:  f_min4  = 0;
        1:  f_min4  = 3;
        2:  f_min4  = 3;
        3:  f_min4  = 3;
        endcase
    end

    // three minimum
    else if ((a0 == a1) & (a0 == a2) & (a0 < a3)) begin
        case (seed)
        0:  f_min4  = 0;
        1:  f_min4  = 1;
        2:  f_min4  = 2;
        3:  f_min4  = 0;
        endcase
    end
    else if ((a0 == a1) & (a0 == a3) & (a0 < a2)) begin
        case (seed)
        0:  f_min4  = 0;
        1:  f_min4  = 1;
        2:  f_min4  = 3;
        3:  f_min4  = 3;
        endcase
    end
    else if ((a0 == a2) & (a0 == a3) & (a0 < a1)) begin
        case (seed)
        0:  f_min4  = 0;
        1:  f_min4  = 2;
        2:  f_min4  = 2;
        3:  f_min4  = 3;
        endcase
    end
    else if ((a1 == a2) & (a1 == a3) & (a1 < a0)) begin
        case (seed)
        0:  f_min4  = 1;
        1:  f_min4  = 1;
        2:  f_min4  = 2;
        3:  f_min4  = 3;
        endcase
    end

    // four mininum
    else
        f_min4  = seed;
end
endfunction

endmodule

`endif                                          // 
