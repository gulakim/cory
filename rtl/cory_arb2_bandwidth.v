//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_ARB2_BANDWIDTH
    `define CORY_ARB2_BANDWIDTH

//------------------------------------------------------------------------------
//  bandwidth allocation arbiter with weighted 2-inputs
//------------------------------------------------------------------------------
module cory_arb2_bandwidth # (
    parameter   N   = 8,                        // # of data bits
    parameter   B   = 8,                        // # of bw bits
    parameter   L   = 4,                        // # of weight bits (arlen)
    parameter   Q   = 0
) (
    input           clk,

    input           i_a0_v,
    input   [N-1:0] i_a0_d,
    input   [L-1:0] i_a0_wt,                    // increment, like arlen, 0 for 1 weight
    output          o_a0_r,
    input   [B-1:0] i_a0_bw,                    // 0 for 1 req

    input           i_a1_v,
    input   [N-1:0] i_a1_d,
    input   [L-1:0] i_a1_wt,                    // increment, like arlen
    output          o_a1_r,
    input   [B-1:0] i_a1_bw,

    output          o_z_v,
    output  [N-1:0] o_z_d,
    output          o_z_s,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
wire            int_v;
wire    [N-1:0] int_d;
wire            int_s;
wire            int_r;

//------------------------------------------------------------------------------
wire    slave_accept    = int_v & int_r;
wire    slave_idle      = !int_v;

//------------------------------------------------------------------------------
wire            sel;

reg     [B:0]   cnt_a0;
wire    [B:0]   cnt_a0_next = cnt_a0 + i_a0_wt + 1;
wire            cnt_a0_last = cnt_a0_next >= i_a0_bw + 1;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        cnt_a0  <= 0;
    else if (slave_accept & sel == 0) begin
        if (cnt_a0_last)
            cnt_a0  <= cnt_a0_next - i_a0_bw - 1;
        else
            cnt_a0  <= cnt_a0_next;
    end
    else if (slave_accept & sel != 0) begin
        if (cnt_a0)
            cnt_a0  <= cnt_a0 - 1'b1;
    end

reg     [B:0]   cnt_a1;
wire    [B:0]   cnt_a1_next = cnt_a1 + i_a1_wt + 1;
wire            cnt_a1_last = cnt_a1_next >= i_a1_bw + 1;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        cnt_a1  <= 0;
    else if (slave_accept & sel == 1) begin
        if (cnt_a1_last)
            cnt_a1  <= cnt_a1_next - i_a1_bw - 1;
        else
            cnt_a1  <= cnt_a1_next;
    end
    else if (slave_accept & sel != 1) begin
        if (cnt_a1)
            cnt_a1  <= cnt_a1 - 1'b1;
    end

wire    a0_v_ex = i_a0_v & (!i_a1_v);
wire    a1_v_ex = (!i_a0_v) & i_a1_v;

wire    a0_last = (sel == 0 && cnt_a0_last);
wire    a1_last = (sel == 1 && cnt_a1_last);

reg     pri_hold;
reg     pri_bw;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        pri_hold <= 0;
    else
        casex ({a1_last, a0_last, slave_accept})
        3'bxx0: pri_hold <= sel;
        3'b011: pri_hold <= 1;
        3'b101: pri_hold <= 0;
        3'b001: pri_hold <= pri_bw;
        endcase

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        pri_bw  <= 0;
    else if (slave_accept) begin
        case ({a1_last, a0_last})
        2'b01:  pri_bw  <= 1;
        2'b10:  pri_bw  <= 0;
        endcase
    end

assign  sel     = a0_v_ex ? 0 :
                  a1_v_ex ? 1 :
                            pri_hold;

//------------------------------------------------------------------------------
cory_mux2 #(.N(N)) u_mux2 (
    .clk        (clk),
    .i_a0_v     (i_a0_v),
    .i_a0_d     (i_a0_d),
    .o_a0_r     (o_a0_r),
    .i_a1_v     (i_a1_v),
    .i_a1_d     (i_a1_d),
    .o_a1_r     (o_a1_r),
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
cory_queue #(.N(1+N), .Q(Q)) u_queue (
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

`ifdef SIM
`ifdef  CORY_MON
    cory_monitor #(N) u_monitor_z (
        .clk        (clk),
        .i_v        (o_z_v),
        .i_d        (o_z_d),
        .i_r        (i_z_r),
        .reset_n    (reset_n)
    );
`endif                                          //  CORY_MON
`endif
endmodule

`endif
