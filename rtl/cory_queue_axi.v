//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_QUEUE_AXI
    `define CORY_QUEUE_AXI

//------------------------------------------------------------------------------
//  a->z queuing to axi
//------------------------------------------------------------------------------
module cory_queue_axi # (
    parameter   N   = 64,                       // item width
    parameter   Q   = 256,                      // queue depth
    parameter   A   = 32,
    parameter   L   = 4,
    parameter   D   = N
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    output  [N-1:0] o_z_d,
    output          o_z_v,
    input           i_z_r,

    output          o_aw_v,
    output  [A-1:0] o_aw_a,
    output  [L-1:0] o_aw_l,
    input           i_aw_r,
    output          o_w_v,
    output  [D-1:0] o_w_d,
    output          o_w_l,
    input           i_w_r,
    input           i_b_v,
    output          o_b_r,

    output          o_ar_v,
    output  [A-1:0] o_ar_a,
    output  [L-1:0] o_ar_l,
    input           i_ar_r,
    input           i_r_v,
    input   [D-1:0] i_r_d,
    input           i_r_l,
    output          o_r_r,

    input           reset_n

);

//------------------------------------------------------------------------------

localparam  MAXBURST    = (2**L);               // 2^4=16
localparam  MARGIN      = MAXBURST;

assign      o_b_r       = i_b_v;

//------------------------------------------------------------------------------
reg     [A-1:0] queue_rptr;                     // word
reg     [A-1:0] queue_wptr;                     // word
reg     [A:0]   queue_i_cnt;                    // word
reg     [A:0]   queue_x_cnt;                    // word

wire    queue_i_full    = queue_i_cnt > Q - MARGIN;
wire    queue_i_empty   = queue_i_cnt < MARGIN;
wire    queue_x_full    = queue_x_cnt > Q - MARGIN;
wire    queue_x_empty   = queue_x_cnt < MARGIN;

wire            aw_v        = !queue_i_full;
wire    [A-1:0] aw_a;
wire    [L-1:0] aw_l        = 4'hf;
wire            aw_r;

wire            ar_v        = !queue_x_empty;
wire    [A-1:0] ar_a;
wire    [L-1:0] ar_l        = 4'hf;
wire            ar_r;

wire            dw_v;
wire    [N-1:0] dw_d;
wire            dw_l;
wire            dw_r;

wire            dr_v;
wire    [D-1:0] dr_d;
wire            dr_l;
wire            dr_r;

assign          o_a_r   = i_a_v ? (dw_v & dw_r) : 1'b0;

//------------------------------------------------------------------------------
generate 
begin : u_aw_ar_addr
    case (D)
    1024: begin                                 // 128byte
        assign  aw_a    = {queue_wptr, 7'h0};
        assign  ar_a    = {queue_rptr, 7'h0};
    end
    512: begin                                  // 64byte
        assign  aw_a    = {queue_wptr, 6'h0};
        assign  ar_a    = {queue_rptr, 6'h0};
    end
    256: begin                                  // 32byte
        assign  aw_a    = {queue_wptr, 5'h0};
        assign  ar_a    = {queue_rptr, 5'h0};
    end
    128: begin                                  // 16byte
        assign  aw_a    = {queue_wptr, 4'h0};
        assign  ar_a    = {queue_rptr, 4'h0};
    end
    64: begin                                   // 8byte
        assign  aw_a    = {queue_wptr, 3'h0};
        assign  ar_a    = {queue_rptr, 3'h0};
    end
    32: begin                                   // 4byte
        assign  aw_a    = {queue_wptr, 2'h0};
        assign  ar_a    = {queue_rptr, 2'h0};
    end
    16: begin                                   // 2byte
        assign  aw_a    = {queue_wptr, 1'h0};
        assign  ar_a    = {queue_rptr, 1'h0};
    end
    8: begin                                    // 1byte
        assign  aw_a    = {queue_wptr};
        assign  ar_a    = {queue_rptr};
    end
//    default: begin
//        $display ("ERROR:%m:D = %d, not supported", D);
//        $finish;
//    end
    endcase
end
endgenerate

//------------------------------------------------------------------------------

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        queue_i_cnt <= 0;
        queue_x_cnt <= 0;
        queue_wptr  <= 0;
        queue_rptr  <= 0;
    end
    else begin
        if (aw_v & aw_r) begin
            if (queue_wptr == Q-MAXBURST)
                queue_wptr  <= 0;
            else
                queue_wptr  <= queue_wptr + MAXBURST;
        end
        if (ar_v & ar_r) begin
            if (queue_rptr == Q-MAXBURST)
                queue_rptr  <= 0;
            else
                queue_rptr  <= queue_rptr + MAXBURST;
        end
        case ({aw_v & aw_r, i_r_v & o_r_r})     // based on data transaction
            2'b10:  queue_i_cnt   <= queue_i_cnt + MAXBURST;
            2'b01:  queue_i_cnt   <= queue_i_cnt - 1;
            2'b11:  queue_i_cnt   <= queue_i_cnt + MAXBURST - 1;
        endcase
        case ({i_b_v & o_b_r, ar_v & ar_r})     // based on data transaction
            2'b10:  queue_x_cnt   <= queue_x_cnt + MAXBURST;
            2'b01:  queue_x_cnt   <= queue_x_cnt - MAXBURST;
            2'b11:  queue_x_cnt   <= queue_x_cnt + MAXBURST - MAXBURST;
        endcase
    end
end

//------------------------------------------------------------------------------

reg     [L-1:0] dw_cnt;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        dw_cnt  <= 0;
    else if (dw_v & dw_r)
        dw_cnt  <= dw_cnt + 1;

assign  dw_l    = dw_cnt == {L{1'b1}};

//------------------------------------------------------------------------------
cory_wire #(.N(D)) u_a_reg (
    .clk            (clk),
    .i_a_v          (i_a_v),
    .i_a_d          (i_a_d),
    .o_a_r          (o_a_r),
    .o_z_v          (dw_v),
    .o_z_d          (dw_d),
    .i_z_r          (dw_r),
    .reset_n        (reset_n)
);

cory_axiwo_queue #(.A(A), .D(D), .L(L), .Q(2)) u_dw_queue (
    .clk            (clk),

    .i_aw_v         (aw_v),
    .i_aw_a         (aw_a),
    .i_aw_l         (aw_l),
    .o_aw_r         (aw_r),

    .i_w_v          (dw_v),
    .i_w_d          (dw_d),
    .i_w_l          (dw_l),
    .o_w_r          (dw_r),

    .o_aw_v         (o_aw_v),
    .o_aw_a         (o_aw_a),
    .o_aw_l         (o_aw_l),
    .i_aw_r         (i_aw_r),

    .o_w_v          (o_w_v),
    .o_w_d          (o_w_d),
    .o_w_l          (o_w_l),
    .i_w_r          (i_w_r),
    .reset_n        (reset_n)
);

cory_axiro_queue #(.A(A), .D(D), .L(L), .Q(2)) u_dr_queue (
    .clk            (clk),

    .i_ar_v         (ar_v),
    .i_ar_a         (ar_a),
    .i_ar_l         (ar_l),
    .o_ar_r         (ar_r),

    .o_r_v          (dr_v),
    .o_r_d          (dr_d),
    .o_r_l          (dr_l),
    .i_r_r          (dr_r),

    .o_ar_v         (o_ar_v),
    .o_ar_a         (o_ar_a),
    .o_ar_l         (o_ar_l),
    .i_ar_r         (i_ar_r),

    .i_r_v          (i_r_v),
    .i_r_d          (i_r_d),
    .i_r_l          (i_r_l),
    .o_r_r          (o_r_r),
    .reset_n        (reset_n)
);

cory_wire #(.N(D)) u_z_reg (
    .clk            (clk),
    .i_a_v          (dr_v),
    .i_a_d          (dr_d),
    .o_a_r          (dr_r),
    .o_z_v          (o_z_v),
    .o_z_d          (o_z_d),
    .i_z_r          (i_z_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
`ifdef  SIM

    always @(posedge clk)
        if (queue_i_cnt > Q) begin
            $display ("ERROR:%m: queue count for int overflow, %d @ %t", queue_i_cnt, $time);
            #100;
            $finish;
        end

    always @(posedge clk)
        if (queue_x_cnt > Q) begin
            $display ("ERROR:%m: queue count for ext overflow, %d @ %t", queue_x_cnt, $time);
            #100;
            $finish;
        end

    wire    debug_a_vr    = i_a_v & o_a_r;
    wire    debug_z_vr    = o_z_v & i_z_r;

    reg     debug_a_vr_1d;
    always @(posedge clk or negedge reset_n)
        if (!reset_n)
            debug_a_vr_1d <= 0;
        else if (debug_a_vr)
            debug_a_vr_1d <= 1;
        else
            debug_a_vr_1d <= 0;

`ifdef  CORY_MON
    cory_monitor #(N) u_monitor_z (
        .clk            (clk),
        .i_v            (o_z_v),
        .i_d            (o_z_d),
        .i_r            (i_z_r),
        .reset_n        (reset_n)
    );

    cory_axiro_monitor #(.A(A), .D(D), .L(L)) u_axiro_monitor (
        .clk            (clk),
        .i_ar_v         (o_ar_v),
        .i_ar_a         (o_ar_a),
        .i_ar_l         (o_ar_l),
        .i_ar_r         (i_ar_r),
        .i_r_v          (i_r_v),
        .i_r_d          (i_r_d),
        .i_r_l          (i_r_l),
        .i_r_r          (o_r_r),
        .reset_n        (reset_n)
    );

    cory_axiwo_monitor #(.A(A), .D(D), .L(L)) u_axiwo_monitor (
        .clk            (clk),
        .i_aw_v         (o_aw_v),
        .i_aw_a         (o_aw_a),
        .i_aw_l         (o_aw_l),
        .i_aw_r         (i_aw_r),
        .i_w_v          (o_w_v),
        .i_w_d          (o_w_d),
        .i_w_l          (o_w_l),
        .i_w_r          (i_w_r),
        .reset_n        (reset_n)
    );

`endif                                          //  CORY_MON

    initial begin
        if ((Q % MAXBURST) != 0) begin
            $display ("ERROR:%m:Q = %d not supported, multiple of %d supported", Q, MAXBURST);
        end
    end
`endif                                          // SIM


endmodule


`endif
