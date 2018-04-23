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
    $shm_probe (tb, "ASM");
    #(MAX_SIM_TIME);
    $display ("NOTE:%m: simulation time limited to %t", MAX_SIM_TIME);
    $finish;
end

//------------------------------------------------------------------------------

wire            din8_v;
wire    [63:0]  din8_d;
wire            din8_r;

cory_master #(.N(64), .T(8), .V(1), .I(64'h8877665544332211)) u_master (
    .clk        (clk),
    .o_v        (din8_v),
    .o_d        (din8_d),
    .i_r        (din8_r),
    .reset_n    (reset_n)
);

wire            dn4_v;
wire    [3:0]   dn4_d;
wire            dn4_r;

cory_p2s #(.N(4), .R(16)) u_p2s (
    .clk        (clk),
    .i_a_v      (din8_v),
    .i_a_d      (din8_d),
    .o_a_r      (din8_r),
    .o_z_v      (dn4_v),
    .o_z_d      (dn4_d),
    .o_z_s      (),
    .i_z_r      (dn4_r),
    .reset_n    (reset_n)
);

wire            dout8_v;
wire    [63:0]  dout8_d;
wire            dout8_r;

cory_s2p #(.N(4), .R(16)) u_s2p (
    .clk        (clk),
    .i_a_v      (dn4_v),
    .i_a_d      (dn4_d),
    .o_a_r      (dn4_r),
    .o_z_v      (dout8_v),
    .o_z_d      (dout8_d),
    .o_z_s      (),
    .i_z_r      (dout8_r),
    .reset_n    (reset_n)
);

cory_slave #(.N(64), .B(20), .R(1), .V(0)) u_slave (
    .clk        (clk),
    .i_v        (dout8_v),
    .i_d        (dout8_d),
    .o_r        (dout8_r),
    .reset_n    (reset_n)
);

/*
cory_y_monitor #(.N(64), .R(R), .V(2)) u_out (
    .clk        (clk),
    .i_width    (cmd_out_width),
    .i_height   (cmd_out_height),
    .i_y_v      (dout8_v),
    .i_y_d      (dout8_d),
    .i_y_r      (dout8_r),
    .reset_n    (reset_n)
);
*/

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


