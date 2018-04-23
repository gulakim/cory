module tb;
`ifdef  SIM
//------------------------------------------------------------------------------

parameter   MAX_SIM_TIME    = 99999;

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
    $shm_probe (tb, "ACM");
    #(MAX_SIM_TIME);
    $display ("NOTE:%m: simulation time limited to %t", MAX_SIM_TIME);
    $finish;
end

//------------------------------------------------------------------------------

wire            din_v [0:3];
wire    [7:0]   din_d [0:3];
wire            din_r [0:3];

wire    [7:0]   din_bw [0:3];
wire    [3:0]   din_wt [0:3];

assign  din_bw[0]   = 8'h7f;
assign  din_bw[1]   = 8'h3f;
assign  din_bw[2]   = 8'h1f;
assign  din_bw[3]   = 8'h00;


localparam  TICK_MASTER0    = 2-1;
localparam  TICK_MASTER1    = 4-1;
localparam  TICK_MASTER2    = 8-1;
localparam  TICK_MASTER3    = 8-1;

/*
localparam  TICK_MASTER0    = 2-1;
localparam  TICK_MASTER1    = 4-1;
localparam  TICK_MASTER2    = 8-1;
localparam  TICK_MASTER3    = 8-1;
*/
localparam  TICK_SLAVE      = 1-1;

cory_master #(.N(4+8), .T(TICK_MASTER0), .V(1), .I(8'h0)) u_master_0 (
    .clk        (clk),
    .o_v        (din_v[0]),
    .o_d        ({din_wt[0], din_d[0]}),
    .i_r        (din_r[0]),
    .reset_n    (reset_n)
);

cory_master #(.N(4+8), .T(TICK_MASTER1), .V(1), .I(8'h01)) u_master_1 (
    .clk        (clk),
    .o_v        (din_v[1]),
    .o_d        ({din_wt[1], din_d[1]}),
    .i_r        (din_r[1]),
    .reset_n    (reset_n)
);

cory_master #(.N(4+8), .T(TICK_MASTER2), .V(1), .I(8'h02)) u_master_2 (
    .clk        (clk),
    .o_v        (din_v[2]),
    .o_d        ({din_wt[2], din_d[2]}),
    .i_r        (din_r[2]),
    .reset_n    (reset_n)
);

cory_master #(.N(4+8), .T(TICK_MASTER3), .V(1), .I(8'h03)) u_master_3 (
    .clk        (clk),
    .o_v        (din_v[3]),
    .o_d        ({din_wt[3], din_d[3]}),
    .i_r        (din_r[3]),
    .reset_n    (reset_n)
);

wire            dout_v;
wire    [7:0]   dout_d;
wire            dout_r;
wire    [1:0]   dout_sel;

cory_arb4_bandwidth #(.N(8), .B(8), .L(4)) u_arb (
    .clk        (clk),

    .i_a0_wt    (din_wt[0]),
    .i_a1_wt    (din_wt[1]),
    .i_a2_wt    (din_wt[2]),
    .i_a3_wt    (din_wt[3]),

    //  .i_a0_wt    (4'h0),
    //  .i_a1_wt    (4'h0),
    //  .i_a2_wt    (4'h0),
    //  .i_a3_wt    (4'h0),

    .i_a0_v     (din_v[0]),
    .i_a0_d     (din_d[0]),
    .o_a0_r     (din_r[0]),
    .i_a0_bw    (din_bw[0]),

    .i_a1_v     (din_v[1]),
    .i_a1_d     (din_d[1]),
    .o_a1_r     (din_r[1]),
    .i_a1_bw    (din_bw[1]),

    .i_a2_v     (din_v[2]),
    .i_a2_d     (din_d[2]),
    .o_a2_r     (din_r[2]),
    .i_a2_bw    (din_bw[2]),

    .i_a3_v     (din_v[3]),
    .i_a3_d     (din_d[3]),
    .o_a3_r     (din_r[3]),
    .i_a3_bw    (din_bw[3]),

    .o_z_v      (dout_v),
    .o_z_d      (dout_d),
    .i_z_r      (dout_r),
    .o_z_s      (dout_sel),

    .reset_n    (reset_n)
);

cory_slave #(.N(8), .R(TICK_SLAVE), .V(0)) u_slave (
    .clk        (clk),
    .i_v        (dout_v),
    .i_d        (dout_d),
    .o_r        (dout_r),
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


