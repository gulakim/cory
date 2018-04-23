//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------

`ifndef CORY_LATENCY
    `define CORY_LATENCY

//------------------------------------------------------------------------------
//  queue - global shift, 100% throughput
//------------------------------------------------------------------------------
module cory_latency # (
    parameter   N   = 8,
    parameter   L   = 8,                        // # of bits for max latency
    parameter   Q   = 2,                        // # of queue for input
    parameter   I   = 1                         // initial value of latency for random
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    output          o_z_v,
    output  [N-1:0] o_z_d,
    input           i_z_r,

    input           reset_n

);

`ifdef  SIM

//------------------------------------------------------------------------------
wire            ain_v;
wire    [N-1:0] ain_d;
wire            ain_r;

cory_queue #(.N(N), .Q(Q)) u_reg (
    .clk            (clk),
    .i_a_v          (i_a_v),
    .i_a_d          (i_a_d),
    .o_a_r          (o_a_r),
    .o_z_v          (ain_v),
    .o_z_d          (ain_d),
    .i_z_r          (ain_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
reg     [L-1:0] latency;
reg     [L-1:0] counter;
wire            pass_it = counter >= latency;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        counter <= 0;
    else if (ain_v) begin
        if (pass_it) begin
            if (o_z_v & i_z_r)
                counter <= 0;
        end
        else
            counter <= counter + 1;
    end

assign  o_z_v       = pass_it ? ain_v : 1'b0;
assign  o_z_d       =           ain_d;
assign  ain_r       =           i_z_r;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        latency <= I;
    else if (o_z_v & i_z_r)
        latency <= latency * 21 + 1;

endmodule

`else                                           //  SIM
cory_wire #(.N(N)) u_wire (
    .clk            (clk),
    .i_a_v          (i_a_v),
    .i_a_d          (i_a_d),
    .o_a_r          (o_a_r),
    .o_z_v          (o_z_v),
    .o_z_d          (o_z_d),
    .i_z_r          (i_z_r),
    .reset_n        (reset_n)
);

`endif                                          //  SIM

`endif
