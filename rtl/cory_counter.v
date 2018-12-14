//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_COUNTER
    `define CORY_COUNTER

//------------------------------------------------------------------------------
//  count down until all-zeros to generate a valid signal
//------------------------------------------------------------------------------
module cory_counter # (
    parameter   N       = 8,
    parameter   INIT    = 0,
    parameter   QI      = 0         // input queue, 1 more clock delay
) (
    input           clk,
    input           i_en,           // enable counting, preset works always

    input           i_a_v,
    input   [N-1:0] i_a_preset,
    output          o_a_r,

    output          o_z_v,          // valid when counter == 0
    output  [N-1:0] o_z_count,      // current value
    output          o_z_last,       // last, counter==0
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------
//  QI is to support non-blocking input, adding extra 1-cycle delay
//  when QI==0, preset = 2 => 2 cycle after output valid generated
//  when QI!=0, preset = 2 => 3 cycle after output valid generated
//------------------------------------------------------------------------------
wire            ain_v;
wire    [N-1:0] ain_preset;
wire            ain_r;

cory_queue #(.N(N), .Q(QI)) u_input_queue (
    .clk        (clk),
    
    .i_a_v      (i_a_v),
    .i_a_d      (i_a_preset),
    .o_a_r      (o_a_r),

    .o_z_v      (ain_v),
    .o_z_d      (ain_preset),
    .i_z_r      (ain_r),

    .reset_n    (reset_n)
);

//------------------------------------------------------------------------------
//  warning for input queue and input valid not accepted
//  QI is only to support non-blocking input
//------------------------------------------------------------------------------
`ifdef  SIM
    wire    debug_input_preset_blocked  = i_a_v & (!o_a_r) & (QI != 0);

    always @(posedge clk)
        if (debug_input_preset_blocked) begin
            $display ("WARNING:%m: input preset(%1d) is blocked @ %t", i_a_preset, $time);
        end
`endif

//------------------------------------------------------------------------------

wire    busy    = o_z_v & (!i_z_r);
assign  ain_r   = ain_v & !busy;

//------------------------------------------------------------------------------

reg     [N-1:0] counter;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        counter <= INIT;
    else if (ain_v & (!busy))
        counter <= ain_preset;
    else if (i_en & counter != 0)
        counter <= counter - 1'b1;

assign  o_z_count   = counter;
assign  o_z_last    = counter == {N{1'b0}};

//------------------------------------------------------------------------------
reg             z_v;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        z_v <= 0;
    else if (ain_v & (!busy) & (ain_preset == 0))
        z_v <= 1;
    else if ((!ain_v) & counter == 1)
        z_v <= 1;
    else if (o_z_v & i_z_r)
        z_v <= 0;

assign  o_z_v   = z_v;

//------------------------------------------------------------------------------
`ifdef  SIM
`ifdef  CORY_MON
    cory_monitor #(.N(N)) u_monitor_z (
        .clk        (clk),
        .i_v        (o_z_v),
        .i_d        (o_z_count),
        .i_r        (i_z_r),
        .reset_n    (reset_n)
    );
`endif      // CORY_MON
`endif      // SIM

endmodule
`endif  // CORY_COUNTER
