module tb;
`ifdef  SIM
//------------------------------------------------------------------------------

parameter   MAX_SIM_TIME    = 9999999;

wire    clk;
wire    reset_n;

clk_gen #(10) u_clk_gen (
    .clk        (clk),
    .reset_n    (reset_n)
);

`ifndef  WAVE_FILE
    `define WAVE_FILE   "/home/user/dump/cory"
`endif

initial begin
    $display ("NOTE:%m: waveform in %s", `WAVE_FILE);
    $shm_open (`WAVE_FILE);
    $shm_probe (tb, "ASM");
    #(MAX_SIM_TIME);
    $display ("NOTE:%m: simulation time limited to %t", MAX_SIM_TIME);
    $finish;
end

//------------------------------------------------------------------------------
reg             cmd_v;
reg     [31:0]  cmd_cnt;
wire            cmd_r;

initial begin
    cmd_v   = 0;
    cmd_cnt = (1920/8)*1080;

    @(posedge reset_n);
    @(posedge clk);
    cmd_v   = 1;
    while (cmd_r != 1)
        @(posedge clk);
    cmd_v   = 0;
    @(posedge clk);
    #100000;
    $display ("NOTE:%m: ===================== DONE =========================");
    $finish;
end

wire            din_v;
wire    [63:0]  din_d;
wire            din_r;
wire            din8_v;
wire    [63:0]  din8_d;
wire            din8_r;
wire            dout8_v;
wire    [63:0]  dout8_d;
wire            dout8_r;

cory_master #(.N(64), .T(0), .V(2), .I(64'h8877665544332211)) u_master (
    .clk        (clk),
    .o_v        (din_v),
    .o_d        (din_d),
    .i_r        (din_r),
    .reset_n    (reset_n)
);

cory_pass #(.N(64), .W(32)) u_din_pass (
    .clk        (clk),
    .i_cmd_v    (cmd_v),
    .i_cmd_cnt  (cmd_cnt),
    .o_cmd_r    (cmd_r),
    .i_a_v      (din_v),
    .i_a_d      (din_d),
    .o_a_r      (din_r),
    .o_z_v      (din8_v),
    .o_z_d      (din8_d),
    .i_z_r      (din8_r),
    .o_z_cnt    (),
    .o_z_last   (),
    .reset_n    (reset_n)
);

wire            aw_v;
wire    [31:0]  aw_a;
wire    [3:0]   aw_l;
wire            aw_r;
wire            dw_v;
wire    [63:0]  dw_d;
wire            dw_l;
wire            dw_r;
wire            bw_v;
wire            bw_r;

wire            ar_v;
wire    [31:0]  ar_a;
wire    [3:0]   ar_l;
wire            ar_r;
wire            dr_v;
wire    [63:0]  dr_d;
wire            dr_l;
wire            dr_r;

cory_queue_axi #(.N(64), .A(32), .L(4), .D(64), .Q(240*2)) u_queue_axi (
    .clk        (clk),
    .i_a_v      (din8_v),
    .i_a_d      (din8_d),
    .o_a_r      (din8_r),
    .o_z_v      (dout8_v),
    .o_z_d      (dout8_d),
    .i_z_r      (dout8_r),
    .o_aw_v     (aw_v),
    .o_aw_a     (aw_a),
    .o_aw_l     (aw_l),
    .i_aw_r     (aw_r),
    .o_w_v      (dw_v),
    .o_w_d      (dw_d),
    .o_w_l      (dw_l),
    .i_w_r      (dw_r),
    .i_b_v      (bw_v),
    .o_b_r      (bw_r),
    .o_ar_v     (ar_v),
    .o_ar_a     (ar_a),
    .o_ar_l     (ar_l),
    .i_ar_r     (ar_r),
    .i_r_v      (dr_v),
    .i_r_d      (dr_d),
    .i_r_l      (dr_l),
    .o_r_r      (dr_r),
    .reset_n    (reset_n)
);

cory_slave #(.N(64), .R(1), .V(2)) u_slave (
    .clk        (clk),
    .i_v        (dout8_v),
    .i_d        (dout8_d),
    .o_r        (dout8_r),
    .reset_n    (reset_n)
);

axis u_axis (
    .clk        (clk),
    .i_awvalid  (aw_v),
    .i_awaddr   (aw_a),
    .i_awlen    (aw_l),
    .o_awready  (aw_r),
    .i_wvalid   (dw_v),
    .i_wdata    (dw_d),
    .i_wlast    (dw_l),
    .o_wready   (dw_r),
    .i_arvalid  (ar_v),
    .i_araddr   (ar_a),
    .i_arlen    (ar_l),
    .o_arready  (ar_r),
    .o_rvalid   (dr_v),
    .o_rdata    (dr_d),
    .o_rlast    (dr_l),
    .i_rready   (dr_r),
    .o_bvalid   (bw_v),
    .i_bready   (bw_r),
    .o_busy     (),
    .reset_n    (reset_n)
);

`endif  // SIM
endmodule

//------------------------------------------------------------------------------
//  clk
//------------------------------------------------------------------------------
module clk_gen # (
    parameter   PERIOD  = 10
) (
    output          clk,
    output          reset_n
);

`ifdef  SIM
    reg     r_clk;
    reg     r_reset_n;

    initial begin
        r_clk  <= 1;
        forever #(PERIOD/2) r_clk <= !r_clk;
    end

    initial begin
        r_reset_n <= 0;
        #(PERIOD/2*3) r_reset_n <= 1;
    end

    assign  clk     = r_clk;
    assign  reset_n = r_reset_n;

`endif  // SIM

endmodule


