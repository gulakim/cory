//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_DIST
    `define CORY_DIST

//------------------------------------------------------------------------------
//  distribute vr only to N vr, no data
//------------------------------------------------------------------------------
module cory_dist #(
    parameter   R   = 8,
    parameter   N   = R
) (
    input           clk,

    input           i_a_v,
    output          o_a_r,

    output  [N-1:0] o_zx_v,
    input   [N-1:0] i_zx_r,

    input           reset_n
);

//------------------------------------------------------------------------------

reg     [N-1:0] op_done_zx_hold;
wire    [N-1:0] op_done_zx;
wire    op_done     = op_done_zx == {N{1'b1}};

genvar i;
generate
    for (i=0; i<N; i=i+1) begin : p_op_done
        assign  op_done_zx[i]   = (o_zx_v[i] & i_zx_r[i]) || op_done_zx_hold[i];
    end
endgenerate

//------------------------------------------------------------------------------
always @(posedge clk or negedge reset_n)
    if (!reset_n) begin : p_init
        integer i;
        for (i=0; i<N; i=i+1)
            op_done_zx_hold[i] <= 0;
    end
    else begin
        if (op_done) begin : p_clear
            integer i;
            for (i=0; i<N; i=i+1)
                op_done_zx_hold[i] <= 0;
        end
        else begin : p_flag
            integer i;
            for (i=0; i<N; i=i+1)
                if (op_done_zx[i])
                    op_done_zx_hold[i] <= 1;
        end
    end

//------------------------------------------------------------------------------
genvar j;
generate
    for (j=0; j<N; j=j+1) begin : p_z
        assign  o_zx_v[j]    = i_a_v & (!op_done_zx_hold[j]);
    end
endgenerate

assign  o_a_r   = op_done;

`ifdef SIM
//------------------------------------------------------------------------------
`ifdef  CORY_MON
    genvar k;
    generate
        for (k=0; k<N; k=k+1) begin : p_monitor
            cory_monitor #(1) u_monitor_z (
                .clk        (clk),
                .i_v        (o_zx_v[k]),
                .i_d        (1'b0),
                .i_r        (i_zx_r[k]),
                .reset_n    (reset_n)
            );
        end
    endgenerate
`endif                                          //  CORY_MON
`endif
endmodule

`endif
