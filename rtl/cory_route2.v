//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_ROUTE2
    `define CORY_ROUTE2

//------------------------------------------------------------------------------
module cory_route2 # (
    parameter   N       = 8,
    parameter   S       = 1,                    // do not touch
    parameter   Q       = 0,
    parameter   QS      = 0                     // must be static selector when 0
) (
    input           clk,

    input           i_a0_v,
    input   [N-1:0] i_a0_d,
    output          o_a0_r,
    input           i_a1_v,
    input   [N-1:0] i_a1_d,
    output          o_a1_r,

    output          o_z0_v,
    output  [N-1:0] o_z0_d,
    input           i_z0_r,
    output          o_z1_v,
    output  [N-1:0] o_z1_d,
    input           i_z1_r,

    input   [S-1:0] i_z0_s,
    input   [S-1:0] i_z1_s,

    input           reset_n
);

//------------------------------------------------------------------------------
localparam  RATIO   = 2**S;

wire    [S-1:0] z0_s;
wire    [S-1:0] z1_s;

wire    no_valid    = (!i_a0_v) & (!i_a1_v) & (!o_z0_v) & (!o_z1_v);

generate
begin : g_static
    case (QS)
    1: begin
        reg     [S-1:0] z0_s_reg;
        reg     [S-1:0] z1_s_reg;

        always @(posedge clk or negedge reset_n)
            if (!reset_n) begin
                z0_s_reg    <= 0;
                z1_s_reg    <= 0;
            end
            else if (no_valid) begin
                z0_s_reg    <= i_z0_s;
                z1_s_reg    <= i_z1_s;
            end

        assign  z0_s    = z0_s_reg;
        assign  z1_s    = z1_s_reg;
    end
    default: begin
        assign  z0_s    = i_z0_s;
        assign  z1_s    = i_z1_s;
    end
    endcase
end
endgenerate

wire    [S-1:0] a0_s    = z0_s == 0 ? 0 : z1_s == 0 ? 1 : {S{1'bx}};
wire    [S-1:0] a1_s    = z0_s == 1 ? 0 : z1_s == 1 ? 1 : {S{1'bx}};

//------------------------------------------------------------------------------
wire            x_a0_v[0:RATIO-1];
wire    [N-1:0] x_a0_d[0:RATIO-1];
wire            x_a0_r[0:RATIO-1];

cory_demux2 #(.N(N)) u_demux_a0 (
    .clk            (clk),
    .i_a_v          (i_a0_v),
    .i_a_d          (i_a0_d),
    .o_a_r          (o_a0_r),
    .i_s_v          (1'b1),
    .i_s_d          (a0_s),
    .o_s_r          (),
    .o_z0_v         (x_a0_v[0]),
    .o_z0_d         (x_a0_d[0]),
    .i_z0_r         (x_a0_r[0]),
    .o_z1_v         (x_a0_v[1]),
    .o_z1_d         (x_a0_d[1]),
    .i_z1_r         (x_a0_r[1]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a1_v[0:RATIO-1];
wire    [N-1:0] x_a1_d[0:RATIO-1];
wire            x_a1_r[0:RATIO-1];

cory_demux2 #(.N(N)) u_demux_a1 (
    .clk            (clk),
    .i_a_v          (i_a1_v),
    .i_a_d          (i_a1_d),
    .o_a_r          (o_a1_r),
    .i_s_v          (1'b1),
    .i_s_d          (a1_s),
    .o_s_r          (),
    .o_z0_v         (x_a1_v[0]),
    .o_z0_d         (x_a1_d[0]),
    .i_z0_r         (x_a1_r[0]),
    .o_z1_v         (x_a1_v[1]),
    .o_z1_d         (x_a1_d[1]),
    .i_z1_r         (x_a1_r[1]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z0_v[0:RATIO-1];
wire    [N-1:0] x_z0_d[0:RATIO-1];
wire            x_z0_r[0:RATIO-1];

cory_mux2 #(.N(N), .Q(Q)) u_mux_z0 (
    .clk            (clk),
    .i_a0_v         (x_z0_v[0]),
    .i_a0_d         (x_z0_d[0]),
    .o_a0_r         (x_z0_r[0]),
    .i_a1_v         (x_z0_v[1]),
    .i_a1_d         (x_z0_d[1]),
    .o_a1_r         (x_z0_r[1]),
    .i_s_v          (1'b1),
    .i_s_d          (z0_s),
    .o_s_r          (),
    .o_z_v          (o_z0_v),
    .o_z_d          (o_z0_d),
    .i_z_r          (i_z0_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z1_v[0:RATIO-1];
wire    [N-1:0] x_z1_d[0:RATIO-1];
wire            x_z1_r[0:RATIO-1];

cory_mux2 #(.N(N), .Q(Q)) u_mux_z1 (
    .clk            (clk),
    .i_a0_v         (x_z1_v[0]),
    .i_a0_d         (x_z1_d[0]),
    .o_a0_r         (x_z1_r[0]),
    .i_a1_v         (x_z1_v[1]),
    .i_a1_d         (x_z1_d[1]),
    .o_a1_r         (x_z1_r[1]),
    .i_s_v          (1'b1),
    .i_s_d          (z1_s),
    .o_s_r          (),
    .o_z_v          (o_z0_v),
    .o_z_d          (o_z0_d),
    .i_z_r          (i_z0_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------

assign  x_z0_v [0]  = x_a0_v [0];
assign  x_z0_d [0]  = x_a0_d [0];
assign  x_a0_r [0]  = x_z0_r [0];

assign  x_z1_v [0]  = x_a0_v [1];
assign  x_z1_d [0]  = x_a0_d [1];
assign  x_a0_r [1]  = x_z1_r [0];

//------------------------------------------------------------------------------
assign  x_z0_v [1]  = x_a1_v [0];
assign  x_z0_d [1]  = x_a1_d [0];
assign  x_a1_r [0]  = x_z0_r [1];

assign  x_z1_v [1]  = x_a1_v [1];
assign  x_z1_d [1]  = x_a1_d [1];
assign  x_a1_r [1]  = x_z1_r [1];

//------------------------------------------------------------------------------

`ifdef  SIM
    always @(posedge clk)
        if ((i_z0_s == i_z1_s)
        ) begin
            $display ("ERROR:%m: zx_s[0-1] = %d, %d @ %t",
                i_z0_s, i_z1_s,
                $time);
            $finish;
        end

`endif
endmodule

`endif
