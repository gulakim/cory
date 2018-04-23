//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_QUEUE_SRAM
    `define CORY_QUEUE_SRAM

//------------------------------------------------------------------------------
//  a->z queuing to single port sram, wirte first
//------------------------------------------------------------------------------
module cory_queue_sram # (
    parameter   N   = 8,                        // item width
    parameter   Q   = 256,                      // queue depth
    parameter   A   = (1<=Q && Q<=2) ? 1 :
                      (3<=Q && Q<=4) ? 2 :
                      (5<=Q && Q<=8) ? 3 :
                      (9<=Q && Q<=16) ? 4 :
                      (17<=Q && Q<=32) ? 5 :
                      (33<=Q && Q<=64) ? 6 :
                      (65<=Q && Q<=128) ? 7 :
                      (129<=Q && Q<=256) ? 8 :
                      (257<=Q && Q<=512) ? 9 :
                      (513<=Q && Q<=1024) ? 10 :
                      (1025<=Q && Q<=2048) ? 11 :
                      (2049<=Q && Q<=4096) ? 12 :
                      1'bx
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    output  [N-1:0] o_z_d,
    output          o_z_v,
    input           i_z_r,

    output          o_s_cen,
    output          o_s_wen,
    output          o_s_oen,
    output  [A-1:0] o_s_addr,
    output  [N-1:0] o_s_wdata,
    input   [N-1:0] i_s_rdata,
    input           i_s_r,

    input           reset_n

);

//------------------------------------------------------------------------------
wire    wr_vr;
wire    rd_vr;

//------------------------------------------------------------------------------
reg     [A-1:0] queue_rptr;
reg     [A-1:0] queue_wptr;
reg     [A:0]   queue_cnt;

wire    queue_full  = queue_cnt == Q;
wire    queue_empty = queue_cnt == 0;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        queue_cnt   <= 0;
        queue_wptr  <= 0;
        queue_rptr  <= 0;
    end
    else begin
        if (wr_vr) begin
            if (queue_wptr == Q-1)
                queue_wptr  <= 0;
            else
                queue_wptr  <= queue_wptr + 1;
        end
        if (rd_vr) begin
            if (queue_rptr == Q-1)
                queue_rptr  <= 0;
            else
                queue_rptr  <= queue_rptr + 1;
        end
        case ({wr_vr, rd_vr})
            2'b10:  queue_cnt   <= queue_cnt + 1;
            2'b01:  queue_cnt   <= queue_cnt - 1;
        endcase
    end
end

//------------------------------------------------------------------------------

wire            wr_v        = i_a_v & !queue_full;
wire            wr_cen      = wr_v ? 1'b0 : 1'b1;
wire            wr_wen      = wr_v ? 1'b0 : 1'b1;
wire    [A-1:0] wr_addr     = queue_wptr;
wire    [N-1:0] wr_wdata    = i_a_d;
wire            wr_r;
assign          wr_vr       = wr_v & wr_r;

assign          o_a_r   = i_a_v ? wr_vr : 1'b0;


//------------------------------------------------------------------------------

wire            rd_v       = !queue_empty;

reg             rd_vr_1d;
always @(posedge clk or negedge reset_n)
    if (!reset_n)
        rd_vr_1d    <= 0;
    else if (rd_vr)
        rd_vr_1d    <= 1;
    else
        rd_vr_1d    <= 0;

wire            rd_cen      = rd_v     ? 1'b0 : 1'b1;
wire            rd_oen      = rd_vr_1d ? 1'b0 : 1'b1;
wire    [A-1:0] rd_addr     = queue_rptr;
wire            rd_r;

assign          rd_vr       = rd_v & rd_r;

//------------------------------------------------------------------------------
wire            rdx_cen;
wire            rdx_oen;
wire    [A-1:0] rdx_addr;
wire    [N-1:0] rdx_rdata;
wire            rdx_r;

cory_sram_ro #(.A(A), .D(N), .C(1)) u_rdata (
    .clk            (clk),
    .i_s_cen        (rd_cen),
    .i_s_oen        (rd_oen),
    .i_s_addr       (rd_addr),
    .o_s_r          (rd_r),

    .o_z_cen        (rdx_cen),
    .o_z_oen        (rdx_oen),
    .o_z_addr       (rdx_addr),
    .i_z_rdata      (rdx_rdata),
    .i_z_r          (rdx_r),

    .o_d_v          (o_z_v),
    .o_d_d          (o_z_d),
    .i_d_r          (i_z_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
//  write first
//------------------------------------------------------------------------------

wire    rdx_v       = rdx_cen == 0 ? 1'b1 : 1'b0;
wire    rdx_vr      = rdx_v & rdx_r;

reg     rdx_vr_1d;
always @(posedge clk or negedge reset_n)
    if (!reset_n)
        rdx_vr_1d    <= 0;
    else if (rdx_vr)
        rdx_vr_1d    <= 1;
    else
        rdx_vr_1d    <= 0;

assign  o_s_cen     = wr_v ? wr_cen    : rdx_v      ? rdx_cen   : 1'b1;
assign  o_s_wen     = wr_v ? wr_wen    :                          1'b1;
assign  o_s_oen     =                    rdx_vr_1d  ? rdx_oen   : 1'b1;
assign  o_s_addr    = wr_v ? wr_addr   : rdx_v      ? rdx_addr  : {A{1'b0}};
assign  o_s_wdata   =        wr_wdata;

assign  wr_r        = wr_v ? i_s_r     : 1'b0;

assign  rdx_rdata   =                                 i_s_rdata;
assign  rdx_r       = wr_v ? 1'b0      : rdx_v      ? i_s_r     : 1'b0;

//------------------------------------------------------------------------------
`ifdef  SIM

    always @(posedge clk)
        if (queue_cnt > Q) begin
            $display ("ERROR:%m: queue count overflow, %d @ %t", queue_cnt, $time);
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
        .clk        (clk),
        .i_v        (o_z_v),
        .i_d        (o_z_d),
        .i_r        (i_z_r),
        .reset_n    (reset_n)
    );

`endif                                          //  CORY_MON
`endif                                          // SIM

endmodule


`endif
