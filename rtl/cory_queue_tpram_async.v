//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_QUEUE_TPRAM_ASYNC
    `define CORY_QUEUE_TPRAM_ASYNC

//------------------------------------------------------------------------------
//  a->z queue with async two port memory
//------------------------------------------------------------------------------
module cory_queue_tpram_async # (
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
    input           aclk,
    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    input           zclk,
    output  [N-1:0] o_z_d,
    output          o_z_v,
    input           i_z_r,

    output          o_s_wclk,
    output          o_s_wen,
    output  [A-1:0] o_s_waddr,
    output  [N-1:0] o_s_wdata,
    input           i_s_wready,

    output          o_s_rclk,
    output          o_s_ren,
    output          o_s_oen,
    output  [A-1:0] o_s_raddr,
    input   [N-1:0] i_s_rdata,
    input           i_s_rready,

    output  [A:0]   o_a_queue_cnt,
    output  [A:0]   o_z_queue_cnt,

    input           areset_n,
    input           zreset_n
);

//------------------------------------------------------------------------------
wire    wr_vr;
wire    rd_vr;

//------------------------------------------------------------------------------
reg     [A-1:0] queue_wptr_a;

always @(posedge aclk or negedge areset_n) begin
    if (!areset_n)
        queue_wptr_a    <= 0;
    else
        if (wr_vr) begin
            if (queue_wptr_a == Q-1)
                queue_wptr_a    <= 0;
            else
                queue_wptr_a    <= queue_wptr_a + 1;
        end
end

/*
reg     [A-1:0] queue_wptr_m;
reg     [A-1:0] queue_wptr_z;

always @(posedge zclk or negedge zreset_n)
    if (!zreset_n) begin
        queue_wptr_m    <= 0;
        queue_wptr_z    <= 0;
    end
    else begin
        queue_wptr_m    <= queue_wptr_a;
        queue_wptr_z    <= queue_wptr_m;
    end
*/
//------------------------------------------------------------------------------
reg     [A-1:0] queue_rptr_z;

always @(posedge zclk or negedge zreset_n) begin
    if (!zreset_n)
        queue_rptr_z    <= 0;
    else
        if (rd_vr) begin
            if (queue_rptr_z == Q-1)
                queue_rptr_z    <= 0;
            else
                queue_rptr_z    <= queue_rptr_z + 1;
        end
end

/*
reg     [A-1:0] queue_rptr_m;
reg     [A-1:0] queue_rptr_a;

always @(posedge aclk or negedge areset_n)
    if (!areset_n) begin
        queue_rptr_m    <= 0;
        queue_rptr_a    <= 0;
    end
    else begin
        queue_rptr_m    <= queue_rptr_z;
        queue_rptr_a    <= queue_rptr_m;
    end
*/

//------------------------------------------------------------------------------

wire    [A-1:0] queue_rptr_a;
wire    [A-1:0] queue_wptr_z;

_cory_AsyncAddrXchgx4 #(A) u_addr_sync (
    .clk0           (aclk),
    .reset0         (!areset_n),
    .addr0          (queue_wptr_a),
    .addr1_sync     (queue_rptr_a),
    .clk1           (zclk),
    .reset1         (!zreset_n),
    .addr1          (queue_rptr_z),
    .addr0_sync     (queue_wptr_z)
);

//------------------------------------------------------------------------------
wire    [A:0]   queue_cnt_a      = queue_wptr_a > queue_rptr_a ? queue_wptr_a - queue_rptr_a :
                                   queue_wptr_a < queue_rptr_a ? Q + queue_wptr_a - queue_rptr_a : 0;
wire            queue_full_a    = queue_cnt_a >= Q-1;
wire            queue_empty_a   = queue_cnt_a == 0;

assign          o_a_queue_cnt   = queue_cnt_a;

wire    [A:0]   queue_cnt_z      = queue_wptr_z > queue_rptr_z ? queue_wptr_z - queue_rptr_z :
                                   queue_wptr_z < queue_rptr_z ? Q + queue_wptr_z - queue_rptr_z : 0;

wire            queue_full_z    = queue_cnt_z >= Q-1;
wire            queue_empty_z   = queue_cnt_z == 0;

assign          o_z_queue_cnt   = queue_cnt_z;

//------------------------------------------------------------------------------

wire            wr_v        = i_a_v & !queue_full_a;
wire            wr_wen      = wr_v ? 1'b0 : 1'b1;
wire    [A-1:0] wr_waddr    = queue_wptr_a;
wire    [N-1:0] wr_wdata    = i_a_d;
wire            wr_r;
assign          wr_vr       = wr_v & wr_r;

assign          o_a_r   = i_a_v ? wr_vr : 1'b0;

//------------------------------------------------------------------------------

wire            rd_v       = !queue_empty_z;

reg             rd_vr_1d;
always @(posedge zclk or negedge zreset_n)
    if (!zreset_n)
        rd_vr_1d    <= 0;
    else if (rd_vr)
        rd_vr_1d    <= 1;
    else
        rd_vr_1d    <= 0;

wire            rd_ren      = rd_v     ? 1'b0 : 1'b1;
wire            rd_oen      = rd_vr_1d ? 1'b0 : 1'b1;
wire    [A-1:0] rd_raddr    = queue_rptr_z;
wire            rd_r;

assign          rd_vr       = rd_v & rd_r;

//------------------------------------------------------------------------------
wire            rdx_ren;
wire            rdx_oen;
wire    [A-1:0] rdx_raddr;
wire    [N-1:0] rdx_rdata;
wire            rdx_r;

cory_sram_ro #(.A(A), .D(N), .C(1)) u_rdata (
    .clk        (zclk),
    .i_s_cen    (rd_ren),
    .i_s_oen    (rd_oen),
    .i_s_addr   (rd_raddr),
    .o_s_r      (rd_r),

    .o_z_cen    (rdx_ren),
    .o_z_oen    (rdx_oen),
    .o_z_addr   (rdx_raddr),
    .i_z_rdata  (rdx_rdata),
    .i_z_r      (rdx_r),

    .o_d_v      (o_z_v),
    .o_d_d      (o_z_d),
    .i_d_r      (i_z_r),
    .reset_n    (zreset_n)
);

//------------------------------------------------------------------------------
assign  o_s_wclk    = aclk;
assign  o_s_wen     = wr_wen;
assign  o_s_waddr   = wr_waddr;
assign  o_s_wdata   = wr_wdata;
assign  wr_r        = i_s_wready;

//------------------------------------------------------------------------------
assign  o_s_rclk    = zclk;
assign  o_s_ren     = rdx_ren;
assign  o_s_oen     = rdx_oen;
assign  o_s_raddr   = rdx_raddr;

assign  rdx_r       = i_s_rready;
assign  rdx_rdata   = i_s_rdata;

//------------------------------------------------------------------------------
`ifdef  SIM

    always @(posedge zclk)
        if (queue_cnt_z > Q) begin
            $display ("ERROR:%m: queue count overflow, %d @ %t", queue_cnt_z, $time);
            #100;
            $finish;
        end

`ifdef  CORY_MON
    cory_monitor #(N) u_monitor_z (
        .clk        (zclk),
        .i_v        (o_z_v),
        .i_d        (o_z_d),
        .i_r        (i_z_r),
        .reset_n    (zreset_n)
    );
`endif                                          //  CORY_MON
`endif                                          // SIM

endmodule

//------------------------------------------------------------------------------
//  async module
//------------------------------------------------------------------------------
module _cory_AsyncAddrXchgx4 # (
    parameter   N   = 8,
    parameter   N1  = N - 1
) (
    reset0,
    clk0,
    addr0,
    addr1_sync,
    reset1,
    clk1,
    addr1,
    addr0_sync);

localparam AW = N1;                             // address width - 1

input         reset0;
input         clk0;
input  [AW:0] addr0;
output [AW:0] addr1_sync;
input         reset1;
input         clk1;
input  [AW:0] addr1;
output [AW:0] addr0_sync;

reg    [AW:0] addr1_sync;
reg    [AW:0] addr0_sync;

wire          able0;
wire          able1;

_cory_AsyncHSCore U_AsyncHSCore(.reset0(reset0), .clk0(clk0), .able0(able0),
                          .reset1(reset1), .clk1(clk1), .able1(able1));

reg    [AW:0] sampleaddr0;
reg    [AW:0] sampleaddr1;

/*
always @(posedge clk0)
    if (reset0 | able0) begin
        sampleaddr0   <= addr0;
        addr1_sync    <= sampleaddr1;
    end

always @(posedge clk1)
    if (reset1 | able1) begin
        sampleaddr1   <= addr1;
        addr0_sync    <= sampleaddr0;
    end
*/

always @(posedge reset0 or posedge clk0)
    if (reset0) begin
        sampleaddr0   <= 0;
        addr1_sync    <= 0;
    end
    else if (able0) begin
        sampleaddr0   <= addr0;
        addr1_sync    <= sampleaddr1;
    end

always @(posedge reset1 or posedge clk1)
    if (reset1) begin
        sampleaddr1   <= 0;
        addr0_sync    <= 0;
    end
    else if (able1) begin
        sampleaddr1   <= addr1;
        addr0_sync    <= sampleaddr0;
    end

endmodule

module _cory_AsyncHSCore (
input  reset0,
input  clk0,
output able0,
input  reset1,
input  clk1,
output able1);

wire   one = 1;

_cory_AsyncHS U_AsyncHS(.reset0(reset0), .clk0(clk0), .valid0(one)  , .ready0(able0),
                  .reset1(reset1), .clk1(clk1), .valid1(able1), .ready1(one)  );

endmodule

module _cory_AsyncHS (
input  reset0,
input  clk0,
input  valid0,
output ready0,
input  reset1,
input  clk1,
output valid1,
input  ready1);

reg    flag1_1d;
reg    flag1_2d;
reg    flag0;
reg    flag0_1d;
reg    flag0_2d;
reg    flag1;

assign ready0 = !(flag1_2d^flag0);
assign valid1 =   flag0_2d^flag1 ;

always @(posedge reset0 or posedge clk0)
    if (reset0) begin
        flag0     <= 0;
        flag1_2d  <= 0;
        flag1_1d  <= 0;
    end
    else begin
        if (valid0) begin
            flag0 <= !flag1_2d;
        end
        flag1_2d  <= flag1_1d;
        flag1_1d  <= flag1;
    end

always @(posedge reset1 or posedge clk1)
    if (reset1) begin
        flag1     <= 0;
        flag0_2d  <= 0;
        flag0_1d  <= 0;
    end
    else begin
        if (ready1) begin
            flag1 <= flag0_2d;
        end
        flag0_2d  <= flag0_1d;
        flag0_1d  <= flag0;
    end

endmodule


`endif
