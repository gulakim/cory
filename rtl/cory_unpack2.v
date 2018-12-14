//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_UNPACK2
    `define CORY_UNPACK2

//------------------------------------------------------------------------------
module cory_unpack2 #(
    parameter   N   = 8,
    parameter   Z0  = N,
    parameter   Z1  = N,
    parameter   A   = Z0 + Z1,
    parameter   Q   = 0,
    parameter   Q0  = Q,
    parameter   Q1  = Q
) (
    input           clk,
    input           i_a_v,
    input   [A-1:0] i_a_d,
    output          o_a_r,

    output          o_z0_v,
    output  [Z0-1:0]o_z0_d,
    input           i_z0_r,
    output          o_z1_v,
    output  [Z1-1:0]o_z1_d,
    input           i_z1_r,
    input           reset_n
);

//------------------------------------------------------------------------------
wire            int_z0_v;
wire    [Z0-1:0]int_z0_d;
wire            int_z0_r;
wire            int_z1_v;
wire    [Z1-1:0]int_z1_d;
wire            int_z1_r;

//------------------------------------------------------------------------------

wire    [A-1:0]     op_a    = i_a_d;
wire    [Z0-1:0]    op_z0;
wire    [Z1-1:0]    op_z1;

assign  {op_z1, op_z0}    = op_a;

//------------------------------------------------------------------------------
reg     op_done_d_z0;
reg     op_done_d_z1;

wire    op_r    = i_a_v;
wire    op_done_z0  = (int_z0_v & int_z0_r) || op_done_d_z0;
wire    op_done_z1  = (int_z1_v & int_z1_r) || op_done_d_z1;
wire    op_done     = op_done_z0 & op_done_z1;

always @(posedge clk or negedge reset_n)
    if (!reset_n) begin
        op_done_d_z0 <= 0;
        op_done_d_z1 <= 0;
    end
    else
        case ({op_done_z0, op_done_z1})
            2'b10:  op_done_d_z0 <= 1;
            2'b01:  op_done_d_z1 <= 1;
            2'b11:  {op_done_d_z0, op_done_d_z1}  <= 0;
        endcase

//------------------------------------------------------------------------------
assign  int_z0_v  = op_r && (!op_done_d_z0);
assign  int_z0_d  = op_z0;
assign  int_z1_v  = op_r && (!op_done_d_z1);
assign  int_z1_d  = op_z1;
assign  o_a_r   = op_done;

//------------------------------------------------------------------------------
cory_queue #(.N(Z0), .Q(Q0)) u_queue_z0 (
    .clk        (clk),
    
    .i_a_v      (int_z0_v),
    .i_a_d      (int_z0_d),
    .o_a_r      (int_z0_r),

    .o_z_v      (o_z0_v),
    .o_z_d      (o_z0_d),
    .i_z_r      (i_z0_r),

    .reset_n    (reset_n)
);

cory_queue #(.N(Z1), .Q(Q1)) u_queue_z1 (
    .clk        (clk),
    
    .i_a_v      (int_z1_v),
    .i_a_d      (int_z1_d),
    .o_a_r      (int_z1_r),

    .o_z_v      (o_z1_v),
    .o_z_d      (o_z1_d),
    .i_z_r      (i_z1_r),

    .reset_n    (reset_n)
);

endmodule

`endif
