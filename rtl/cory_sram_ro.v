//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_SRAM_RO
    `define CORY_SRAM_RO

//------------------------------------------------------------------------------
//  sram read-only with valid/ready
//------------------------------------------------------------------------------
module cory_sram_ro #(
    parameter   C  = 2,                         // control bits
    parameter   A  = 8,                         // address bits
    parameter   D  = 8                          // data bits
) (
    input           clk,

    input   [C-1:0] i_s_cen,
    input   [C-1:0] i_s_oen,
    input   [A-1:0] i_s_addr,
    output          o_s_r,

    output  [C-1:0] o_z_cen,
    output  [C-1:0] o_z_oen,
    output  [A-1:0] o_z_addr,
    input   [D-1:0] i_z_rdata,
    input           i_z_r,

    output          o_d_v,
    output  [D-1:0] o_d_d,
    input           i_d_r,

    input           reset_n

);

//------------------------------------------------------------------------------
wire    s_v     = &i_s_cen == 0 ? 1'b1 : 1'b0;
wire    s_r     = o_s_r;
wire    s_vr    = s_v & s_r;

reg     rdata_v;
wire    rdata_r;                                // must be the same as rdata_v

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        rdata_v  <= 0;
    else if (s_vr)
        rdata_v  <= 1;
    else
        rdata_v  <= 0;

//------------------------------------------------------------------------------
reg     [1:0]   req_queue_cnt;                  // 0 or 1

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        req_queue_cnt   <= 0;
    else
        case ({s_v & s_r, rdata_v & rdata_r})
        2'b10:  req_queue_cnt   <= req_queue_cnt + 1;
        2'b01:  req_queue_cnt   <= req_queue_cnt - 1;
        2'b11:  req_queue_cnt   <= req_queue_cnt;
        endcase

//------------------------------------------------------------------------------
wire    [1:0]   data_queue_cnt;

wire            queue_cnt_full  = req_queue_cnt + data_queue_cnt >= 2;

wire    pass_it     = !(queue_cnt_full & o_d_v & !i_d_r);
reg     pass_it_1d;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        pass_it_1d  <= 0;
    else
        pass_it_1d  <= pass_it;

//------------------------------------------------------------------------------

assign  o_z_cen     = pass_it    ? i_s_cen     : {C{1'b1}};
assign  o_z_oen     = pass_it_1d ? i_s_oen     : {C{1'B1}};
assign  o_z_addr    = i_s_addr;
assign  o_s_r       = pass_it    ? s_v & i_z_r : 1'b0;

//------------------------------------------------------------------------------
cory_queue_cnt #(.N(D), .Q(2)) u_rdata (
    .clk        (clk),
    .i_a_v      (rdata_v),
    .i_a_d      (i_z_rdata),
    .o_a_r      (rdata_r),                      // supposed to be 1 when v==1
    .o_z_v      (o_d_v),
    .o_z_d      (o_d_d),
    .i_z_r      (i_d_r),
    .o_z_cnt    (data_queue_cnt),
    .reset_n    (reset_n)
);

//------------------------------------------------------------------------------

`ifdef SIM

    always @(posedge clk or negedge reset_n)
        if (reset_n & rdata_v & !rdata_r) begin
            $display ("ERROR:%m: rdata_v=%d, rdata_r=%d, it must always accept @ %t", rdata_v, rdata_r, $time);
            #100;
            $finish;
        end

`endif                                          // SIM

endmodule


`endif
