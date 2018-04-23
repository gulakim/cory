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
localparam  N       = 8;
localparam  NA      = 8;
localparam  NZ      = 3;
localparam  A       = NA * N;
localparam  Z       = NZ * N;

wire            ain_v;
wire    [A-1:0] ain_d;
wire            ain_r;

cory_master #(.N(A), .T(0), .V(1), .I(64'h0706050403020100)) u_master_0 (
    .clk        (clk),
    .o_v        (ain_v),
    .o_d        (ain_d),
    .i_r        (ain_r),
    .reset_n    (reset_n)
);

wire            zout_v;
wire    [Z-1:0] zout_d;
wire            zout_r;

localparam  Q   = NA + NZ*2;

//  cory_s2s #(.N(N), .A(A), .Z(Z), .Q(Q)) u_unit (
cory_s2s #(.N(N), .A(A), .Z(Z)) u_unit (
    .clk        (clk),

    .i_a_v      (ain_v),
    .i_a_d      (ain_d),
    .o_a_r      (ain_r),

    .o_z_v      (zout_v),
    .o_z_d      (zout_d),
    .i_z_r      (zout_r),

    .reset_n    (reset_n)
);

cory_slave #(.N(Z), .R(0), .V(0)) u_slave (
    .clk        (clk),
    .i_v        (zout_v),
    .i_d        (zout_d),
    .o_r        (zout_r),
    .reset_n    (reset_n)
);

`endif  // SIM

function integer f_log2;
    input   integer value;
    begin
		     if(value <= 2) f_log2= 1;
		else if(value <= 4) f_log2= 2;
		else if(value <= 8) f_log2= 3;
		else if(value <= 16) f_log2= 4;
		else if(value <= 32) f_log2= 5;
		else if(value <= 64) f_log2= 6;
		else if(value <= 128) f_log2= 7;
		else if(value <= 256) f_log2= 8;
		else if(value <= 512) f_log2= 9;
		else if(value <= 1024) f_log2= 10;
		else if(value <= 2048) f_log2= 11;
		else if(value <= 4096) f_log2= 12;
		else if(value <= 8192) f_log2= 13;
		else if(value <= 16384) f_log2= 14;
		else if(value <= 32768) f_log2= 15;
		else if(value <= 65536) f_log2= 16;
    end
endfunction

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


