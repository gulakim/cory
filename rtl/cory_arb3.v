//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_ARB3
    `define CORY_ARB3


//------------------------------------------------------------------------------
//  arbiteration - round priority, sel for response demux
//------------------------------------------------------------------------------
module cory_arb3 # (
    parameter   N       = 8,                    // # of data bits
    parameter   ROUND   = 1,                    // 1:round, 0:port priority
    parameter   Q       = 0
) (
    input           clk,

    input           i_a0_v,
    input   [N-1:0] i_a0_d,
    output          o_a0_r,

    input           i_a1_v,
    input   [N-1:0] i_a1_d,
    output          o_a1_r,

    input           i_a2_v,
    input   [N-1:0] i_a2_d,
    output          o_a2_r,

    output          o_z_v,
    output  [N-1:0] o_z_d,
    output  [1:0]   o_z_s,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
wire            int_v;
wire    [N-1:0] int_d;
wire    [1:0]   int_s;
wire            int_r;

//------------------------------------------------------------------------------
wire    slave_accept    = int_v & int_r;
wire    slave_idle      = !int_v;

//------------------------------------------------------------------------------
//  for next
//------------------------------------------------------------------------------

wire    a0_v_ex = i_a0_v & (!i_a1_v) & (!i_a2_v);
wire    a1_v_ex = (!i_a0_v) & i_a1_v & (!i_a2_v);
wire    a2_v_ex = (!i_a0_v) & (!i_a1_v) & i_a2_v;

reg     [1:0]   sel;
reg     [1:0]   pri;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        pri <= 0;
    else
        casex ({a2_v_ex, a1_v_ex, a0_v_ex, slave_accept})
        4'b0010: pri <= 0;
        4'b0100: pri <= 1;
        4'b1000: pri <= 2;
        4'bxxx1: pri <= (sel == 2) ? 0 : sel + 1;
        endcase

always @(*)
    casex ({i_a2_v, i_a1_v, i_a0_v, pri})
    5'b001_xx:  sel <= 0;
    5'b010_xx:  sel <= 1;
    5'b100_xx:  sel <= 2;
    5'bxx1_00:  sel <= pri;
    5'bx10_00:  sel <= 1;
    5'b100_00:  sel <= 2;
    5'bx1x_01:  sel <= pri;
    5'b10x_01:  sel <= 2;
    5'b001_01:  sel <= 0;
    5'b1xx_10:  sel <= pri;
    5'b0x1_10:  sel <= 0;
    5'b010_10:  sel <= 1;
    default:    sel <= pri;
    endcase

assign  int_s   = sel;

//------------------------------------------------------------------------------

cory_mux3 #(.N(N)) u_mux3 (
    .clk            (clk),
    .i_a0_v         (i_a0_v),
    .i_a0_d         (i_a0_d),
    .o_a0_r         (o_a0_r),
    .i_a1_v         (i_a1_v),
    .i_a1_d         (i_a1_d),
    .o_a1_r         (o_a1_r),
    .i_a2_v         (i_a2_v),
    .i_a2_d         (i_a2_d),
    .o_a2_r         (o_a2_r),
    .i_s_v          (1'b1),
    .i_s_d          (sel),
    .o_s_r          (),
    .o_z_v          (int_v),
    .o_z_d          (int_d),
    .i_z_r          (int_r),
    .reset_n        (reset_n)
);

assign  int_s    = sel;

//------------------------------------------------------------------------------
cory_queue #(.N(2+N), .Q(Q)) u_queue (
    .clk        (clk),
    .i_a_v      (int_v),
    .i_a_d      ({int_s, int_d}),
    .o_a_r      (int_r),
    .o_z_v      (o_z_v),
    .o_z_d      ({o_z_s, o_z_d}),
    .i_z_r      (i_z_r),
    .reset_n    (reset_n)
);

`ifdef  SIM
    initial begin
        if (ROUND == 0) begin
            $display ("WARNING:%m: ROUND = 1 supported only");
        end
    end
`endif

endmodule


`endif
