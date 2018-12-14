//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_FLOP
    `define CORY_FLOP

//------------------------------------------------------------------------------
//  1 flop with 100% throughput/ready propagation, or 50% throughput/best timing
//------------------------------------------------------------------------------
module cory_flop # (
    parameter   N       = 8,
    parameter   SPEED   = 0                     // 1: better timing, 50% throughput only, no r->r propagation
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    output  [N-1:0] o_z_d,
    output          o_z_v,
    input           i_z_r,

    input           reset_n

);

//------------------------------------------------------------------------------
wire    a_v_r       = i_a_v & o_a_r;
wire    z_v_r       = o_z_v & i_z_r;

//------------------------------------------------------------------------------
reg     [N-1:0] queue;
reg             queue_cnt;

wire    queue_full  = queue_cnt;
wire    queue_empty = !queue_cnt;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        queue       <= 0;
        queue_cnt   <= 0;
    end
    else begin
        if (a_v_r)
            queue   <= i_a_d;
        case ({a_v_r, z_v_r})
            2'b10:  queue_cnt   <= 1;
            2'b01:  queue_cnt   <= 0;
        endcase
    end
end

//------------------------------------------------------------------------------
wire    a_busy;
generate begin : p_busy
    case (SPEED)
    1:
        assign  a_busy    = queue_full;
    default:
        assign  a_busy    = queue_full ? (z_v_r ? 1'b0 : 1'b1) : 1'b0;
    endcase
end
endgenerate

`ifdef  CORY_EASY_WAVE
    assign  o_a_r   = i_a_v && (!a_busy);
`else   //  CORY_EASY_WAVE
    assign  o_a_r   = (!a_busy);
`endif  //  CORY_EASY_WAVE

//------------------------------------------------------------------------------

assign  o_z_v   = !queue_empty;
assign  o_z_d    = queue;

//------------------------------------------------------------------------------
`ifdef  SIM
    initial begin
        if (N == 0) begin
            $display ("ERROR:%m: N = %d", N);
            $finish;
        end
    end

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
