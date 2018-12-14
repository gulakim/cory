//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_QUEUE_CNT
    `define CORY_QUEUE_CNT

//------------------------------------------------------------------------------
//  queue with count output
//------------------------------------------------------------------------------
module cory_queue_cnt # (
    parameter   N   = 8,
    parameter   Q   = 2,
    parameter   MQ  =  (Q <= 2) ? 1 :
		               (Q <= 4) ? 2 :
		               (Q <= 8) ? 3 :
		               (Q <= 16) ? 4 :
		               (Q <= 32) ? 5 :
		               (Q <= 64) ? 6 :
		               (Q <= 128) ? 7 :
		               (Q <= 256) ? 8 :
		               (Q <= 512) ? 9 :
		               (Q <= 1024) ? 10 :
		               (Q <= 2048) ? 11 :
		               (Q <= 4096) ? 12 :
		               (Q <= 8192) ? 13 :
		               (Q <= 16384) ? 14 :
		               (Q <= 32768) ? 15 :
		               (Q <= 65536) ? 16 : 1'bx
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    output  [N-1:0] o_z_d,
    output          o_z_v,
    input           i_z_r,
    output  [MQ:0]  o_z_cnt,

    input           reset_n

);

//------------------------------------------------------------------------------
wire    a_vr       = i_a_v & o_a_r;
wire    z_vr       = o_z_v & i_z_r;

//------------------------------------------------------------------------------
reg     [N-1:0]     queue [0:Q-1];
reg     [MQ:0]      queue_cnt;
reg     [MQ-1:0]    queue_rptr;
reg     [MQ-1:0]    queue_wptr;

wire    queue_full  = queue_cnt == Q;
wire    queue_empty = queue_cnt == 0;

assign  o_z_cnt     = queue_cnt;

always @(posedge clk or negedge reset_n) begin : q
    integer i;
    if (!reset_n) begin
        for (i=0; i<Q; i=i+1)
            queue[i]    <= 0;
        queue_wptr  <= 0;
        queue_cnt   <= 0;
        queue_rptr  <= 0;
    end
    else begin
        if (a_vr) begin
            queue[queue_wptr]   <= i_a_d;
            if (queue_wptr == Q-1)
                queue_wptr  <= 0;
            else
                queue_wptr  <= queue_wptr + 1;
        end
        if (z_vr) begin
            if (queue_rptr == Q-1)
                queue_rptr  <= 0;
            else
                queue_rptr  <= queue_rptr + 1;
        end
        case ({a_vr, z_vr})
            2'b10:  queue_cnt   <= queue_cnt + 1;
            2'b01:  queue_cnt   <= queue_cnt - 1;
        endcase
    end
end

//------------------------------------------------------------------------------
//  local shift
//------------------------------------------------------------------------------
wire      a_busy    = queue_full;               // no z->a path

//------------------------------------------------------------------------------
//  NO local shift
//------------------------------------------------------------------------------
//wire      a_busy    = queue_full ? (z_vr ? 1'b0 : 1'b1) : 1'b0;     // z->a path, timing issue ?

`ifdef  CORY_EASY_WAVE
    assign  o_a_r   = i_a_v && (!a_busy);
`else   //  CORY_EASY_WAVE
    assign  o_a_r   = (!a_busy);
`endif  //  CORY_EASY_WAVE

//------------------------------------------------------------------------------

assign  o_z_v   = !queue_empty;
assign  o_z_d    = queue[queue_rptr];

//------------------------------------------------------------------------------
`ifdef  SIM
    initial begin
        if (Q <= 1 || Q > 65536) begin
            $display ("ERROR:%m: Q = %d, not supported", Q);
            $finish;
        end
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
