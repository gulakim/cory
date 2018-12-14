//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_DEC2
    `define CORY_DEC2

//-----------------------------------------------------------------------------------
//  decimation by 2, 3-tap weighted filtering
//-----------------------------------------------------------------------------------
module cory_dec2 #(
    parameter   N   = 8,
    parameter   Q   = 0
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    input           i_a_first,
    output          o_a_r,
    output          o_z_v,
    output  [N-1:0] o_z_d,
    input           i_z_r,

    input           reset_n
);

//-----------------------------------------------------------------------------------
wire            int_v;
wire    [N-1:0] int_d;
wire            int_r;

//-----------------------------------------------------------------------------------
reg     [1:0]   cnt;
wire            cnt_full    = cnt >= 2;         // actually only when 2

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        cnt <= 0;
    else
        case ({i_a_v & o_a_r, int_v & int_r})
        2'b10: cnt <= cnt + 1;
        2'b01: cnt <= cnt - 2;
        2'b11: cnt <= cnt - 1;
        endcase

//-----------------------------------------------------------------------------------
reg     [N-1:0] p0, p1, p2;

always @(posedge clk or negedge reset_n)
    if (!reset_n) begin
        p0  <= 0;
        p1  <= 0;
        p2  <= 0;
    end
    else if (i_a_v & o_a_r) begin
        if (i_a_first) begin
            p0  <= 0;
            p1  <= i_a_d;
            p2  <= i_a_d;
        end
        else begin
            p0  <= p1;
            p1  <= p2;
            p2  <= i_a_d;
        end
    end

assign  o_a_r   = i_a_v & (!cnt_full || (cnt_full & int_v & int_r));        // z->a ready prop.

wire    [N+1:0] sum     = p0 + {p1, 1'b0} + p2;
wire    [N-1:0] mean    = sum[N+1:2] + sum[1];  // 2 bit cut & round

//-----------------------------------------------------------------------------------

assign  int_v   = cnt_full;
assign  int_d   = mean;

//-----------------------------------------------------------------------------------
cory_queue #(.N(N), .Q(Q)) u_queue (
    .clk        (clk),
    .i_a_v      (int_v),
    .i_a_d      (int_d),
    .o_a_r      (int_r),
    .o_z_v      (o_z_v),
    .o_z_d      (o_z_d),
    .i_z_r      (i_z_r),
    .reset_n    (reset_n)
);

endmodule



`endif
