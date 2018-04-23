//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_QUEUE
    `define CORY_QUEUE

//------------------------------------------------------------------------------
//  a->z queue, with Q depth 
//------------------------------------------------------------------------------
module cory_queue # (
    parameter   N   = 8,
    parameter   Q   = 2
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

generate
begin : g_queue
    case (Q)
    0: begin
        assign  o_z_v   = i_a_v;
        assign  o_z_d   = i_a_d;
        assign  o_a_r   = i_z_r;
    end
    1:
        cory_flop #(.N(N)) u_queue (
            .clk            (clk),
            .i_a_v          (i_a_v),
            .i_a_d          (i_a_d),
            .o_a_r          (o_a_r),
            .o_z_v          (o_z_v),
            .o_z_d          (o_z_d),
            .i_z_r          (i_z_r),
            .reset_n        (reset_n)
        );
    default:
        cory_queue_cnt #(.N(N), .Q(Q)) u_queue (
            .clk            (clk),
            .i_a_v          (i_a_v),
            .i_a_d          (i_a_d),
            .o_a_r          (o_a_r),
            .o_z_v          (o_z_v),
            .o_z_d          (o_z_d),
            .i_z_r          (i_z_r),
            .o_z_cnt        (),
            .reset_n        (reset_n)
        );
    endcase
end
endgenerate

endmodule

`endif

