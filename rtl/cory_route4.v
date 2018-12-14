//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_ROUTE4
    `define CORY_ROUTE4

//------------------------------------------------------------------------------
module cory_route4 # (
    parameter   N       = 8,
    parameter   S       = 2,                    // do not touch
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
    input           i_a2_v,
    input   [N-1:0] i_a2_d,
    output          o_a2_r,
    input           i_a3_v,
    input   [N-1:0] i_a3_d,
    output          o_a3_r,

    output          o_z0_v,
    output  [N-1:0] o_z0_d,
    input           i_z0_r,
    output          o_z1_v,
    output  [N-1:0] o_z1_d,
    input           i_z1_r,
    output          o_z2_v,
    output  [N-1:0] o_z2_d,
    input           i_z2_r,
    output          o_z3_v,
    output  [N-1:0] o_z3_d,
    input           i_z3_r,

    input   [S-1:0] i_z0_s,
    input   [S-1:0] i_z1_s,
    input   [S-1:0] i_z2_s,
    input   [S-1:0] i_z3_s,

    input           reset_n
);

//------------------------------------------------------------------------------
localparam  RATIO   = 2**S;

wire    [S-1:0] z0_s;
wire    [S-1:0] z1_s;
wire    [S-1:0] z2_s;
wire    [S-1:0] z3_s;

wire    no_valid    = (!i_a0_v) & (!i_a1_v) & (!i_a2_v) & (!i_a3_v) &
                      (!o_z0_v) & (!o_z1_v) & (!o_z2_v) & (!o_z3_v);

generate
begin : g_static
    case (QS)
    1: begin
        reg     [S-1:0] z0_s_reg;
        reg     [S-1:0] z1_s_reg;
        reg     [S-1:0] z2_s_reg;
        reg     [S-1:0] z3_s_reg;

        always @(posedge clk or negedge reset_n)
            if (!reset_n) begin
                z0_s_reg    <= 0;
                z1_s_reg    <= 0;
                z2_s_reg    <= 0;
                z3_s_reg    <= 0;
            end
            else if (no_valid) begin
                z0_s_reg    <= i_z0_s;
                z1_s_reg    <= i_z1_s;
                z2_s_reg    <= i_z2_s;
                z3_s_reg    <= i_z3_s;
            end

        assign  z0_s    = z0_s_reg;
        assign  z1_s    = z1_s_reg;
        assign  z2_s    = z2_s_reg;
        assign  z3_s    = z3_s_reg;
    end
    default: begin
        assign  z0_s    = i_z0_s;
        assign  z1_s    = i_z1_s;
        assign  z2_s    = i_z2_s;
        assign  z3_s    = i_z3_s;
    end
    endcase
end
endgenerate

wire    [S-1:0] a0_s    = z0_s == 0 ? 0 : z1_s == 0 ? 1 : z2_s == 0 ? 2 : z3_s == 0 ? 3 : {S{1'bx}};
wire    [S-1:0] a1_s    = z0_s == 1 ? 0 : z1_s == 1 ? 1 : z2_s == 1 ? 2 : z3_s == 1 ? 3 : {S{1'bx}};
wire    [S-1:0] a2_s    = z0_s == 2 ? 0 : z1_s == 2 ? 1 : z2_s == 2 ? 2 : z3_s == 2 ? 3 : {S{1'bx}};
wire    [S-1:0] a3_s    = z0_s == 3 ? 0 : z1_s == 3 ? 1 : z2_s == 3 ? 2 : z3_s == 3 ? 3 : {S{1'bx}};

//------------------------------------------------------------------------------
wire            x_a0_v[0:RATIO-1];
wire    [N-1:0] x_a0_d[0:RATIO-1];
wire            x_a0_r[0:RATIO-1];

cory_demux4 #(.N(N)) u_demux_a0 (
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
    .o_z2_v         (x_a0_v[2]),
    .o_z2_d         (x_a0_d[2]),
    .i_z2_r         (x_a0_r[2]),
    .o_z3_v         (x_a0_v[3]),
    .o_z3_d         (x_a0_d[3]),
    .i_z3_r         (x_a0_r[3]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a1_v[0:RATIO-1];
wire    [N-1:0] x_a1_d[0:RATIO-1];
wire            x_a1_r[0:RATIO-1];

cory_demux4 #(.N(N)) u_demux_a1 (
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
    .o_z2_v         (x_a1_v[2]),
    .o_z2_d         (x_a1_d[2]),
    .i_z2_r         (x_a1_r[2]),
    .o_z3_v         (x_a1_v[3]),
    .o_z3_d         (x_a1_d[3]),
    .i_z3_r         (x_a1_r[3]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a2_v[0:RATIO-1];
wire    [N-1:0] x_a2_d[0:RATIO-1];
wire            x_a2_r[0:RATIO-1];

cory_demux4 #(.N(N)) u_demux_a2 (
    .clk            (clk),
    .i_a_v          (i_a2_v),
    .i_a_d          (i_a2_d),
    .o_a_r          (o_a2_r),
    .i_s_v          (1'b1),
    .i_s_d          (a2_s),
    .o_s_r          (),
    .o_z0_v         (x_a2_v[0]),
    .o_z0_d         (x_a2_d[0]),
    .i_z0_r         (x_a2_r[0]),
    .o_z1_v         (x_a2_v[1]),
    .o_z1_d         (x_a2_d[1]),
    .i_z1_r         (x_a2_r[1]),
    .o_z2_v         (x_a2_v[2]),
    .o_z2_d         (x_a2_d[2]),
    .i_z2_r         (x_a2_r[2]),
    .o_z3_v         (x_a2_v[3]),
    .o_z3_d         (x_a2_d[3]),
    .i_z3_r         (x_a2_r[3]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a3_v[0:RATIO-1];
wire    [N-1:0] x_a3_d[0:RATIO-1];
wire            x_a3_r[0:RATIO-1];

cory_demux4 #(.N(N)) u_demux_a3 (
    .clk            (clk),
    .i_a_v          (i_a3_v),
    .i_a_d          (i_a3_d),
    .o_a_r          (o_a3_r),
    .i_s_v          (1'b1),
    .i_s_d          (a3_s),
    .o_s_r          (),
    .o_z0_v         (x_a3_v[0]),
    .o_z0_d         (x_a3_d[0]),
    .i_z0_r         (x_a3_r[0]),
    .o_z1_v         (x_a3_v[1]),
    .o_z1_d         (x_a3_d[1]),
    .i_z1_r         (x_a3_r[1]),
    .o_z2_v         (x_a3_v[2]),
    .o_z2_d         (x_a3_d[2]),
    .i_z2_r         (x_a3_r[2]),
    .o_z3_v         (x_a3_v[3]),
    .o_z3_d         (x_a3_d[3]),
    .i_z3_r         (x_a3_r[3]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z0_v[0:RATIO-1];
wire    [N-1:0] x_z0_d[0:RATIO-1];
wire            x_z0_r[0:RATIO-1];

cory_mux4 #(.N(N), .Q(Q)) u_mux_z0 (
    .clk            (clk),
    .i_a0_v         (x_z0_v[0]),
    .i_a0_d         (x_z0_d[0]),
    .o_a0_r         (x_z0_r[0]),
    .i_a1_v         (x_z0_v[1]),
    .i_a1_d         (x_z0_d[1]),
    .o_a1_r         (x_z0_r[1]),
    .i_a2_v         (x_z0_v[2]),
    .i_a2_d         (x_z0_d[2]),
    .o_a2_r         (x_z0_r[2]),
    .i_a3_v         (x_z0_v[3]),
    .i_a3_d         (x_z0_d[3]),
    .o_a3_r         (x_z0_r[3]),
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

cory_mux4 #(.N(N), .Q(Q)) u_mux_z1 (
    .clk            (clk),
    .i_a0_v         (x_z1_v[0]),
    .i_a0_d         (x_z1_d[0]),
    .o_a0_r         (x_z1_r[0]),
    .i_a1_v         (x_z1_v[1]),
    .i_a1_d         (x_z1_d[1]),
    .o_a1_r         (x_z1_r[1]),
    .i_a2_v         (x_z1_v[2]),
    .i_a2_d         (x_z1_d[2]),
    .o_a2_r         (x_z1_r[2]),
    .i_a3_v         (x_z1_v[3]),
    .i_a3_d         (x_z1_d[3]),
    .o_a3_r         (x_z1_r[3]),
    .i_s_v          (1'b1),
    .i_s_d          (z1_s),
    .o_s_r          (),
    .o_z_v          (o_z1_v),
    .o_z_d          (o_z1_d),
    .i_z_r          (i_z1_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z2_v[0:RATIO-1];
wire    [N-1:0] x_z2_d[0:RATIO-1];
wire            x_z2_r[0:RATIO-1];

cory_mux4 #(.N(N), .Q(Q)) u_mux_z2 (
    .clk            (clk),
    .i_a0_v         (x_z2_v[0]),
    .i_a0_d         (x_z2_d[0]),
    .o_a0_r         (x_z2_r[0]),
    .i_a1_v         (x_z2_v[1]),
    .i_a1_d         (x_z2_d[1]),
    .o_a1_r         (x_z2_r[1]),
    .i_a2_v         (x_z2_v[2]),
    .i_a2_d         (x_z2_d[2]),
    .o_a2_r         (x_z2_r[2]),
    .i_a3_v         (x_z2_v[3]),
    .i_a3_d         (x_z2_d[3]),
    .o_a3_r         (x_z2_r[3]),
    .i_s_v          (1'b1),
    .i_s_d          (z2_s),
    .o_s_r          (),
    .o_z_v          (o_z2_v),
    .o_z_d          (o_z2_d),
    .i_z_r          (i_z2_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z3_v[0:RATIO-1];
wire    [N-1:0] x_z3_d[0:RATIO-1];
wire            x_z3_r[0:RATIO-1];

cory_mux4 #(.N(N), .Q(Q)) u_mux_z3 (
    .clk            (clk),
    .i_a0_v         (x_z3_v[0]),
    .i_a0_d         (x_z3_d[0]),
    .o_a0_r         (x_z3_r[0]),
    .i_a1_v         (x_z3_v[1]),
    .i_a1_d         (x_z3_d[1]),
    .o_a1_r         (x_z3_r[1]),
    .i_a2_v         (x_z3_v[2]),
    .i_a2_d         (x_z3_d[2]),
    .o_a2_r         (x_z3_r[2]),
    .i_a3_v         (x_z3_v[3]),
    .i_a3_d         (x_z3_d[3]),
    .o_a3_r         (x_z3_r[3]),
    .i_s_v          (1'b1),
    .i_s_d          (z3_s),
    .o_s_r          (),
    .o_z_v          (o_z3_v),
    .o_z_d          (o_z3_d),
    .i_z_r          (i_z3_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
assign  x_z0_v [0]  = x_a0_v [0];
assign  x_z0_d [0]  = x_a0_d [0];
assign  x_a0_r [0]  = x_z0_r [0];

assign  x_z1_v [0]  = x_a0_v [1];
assign  x_z1_d [0]  = x_a0_d [1];
assign  x_a0_r [1]  = x_z1_r [0];

assign  x_z2_v [0]  = x_a0_v [2];
assign  x_z2_d [0]  = x_a0_d [2];
assign  x_a0_r [2]  = x_z2_r [0];

assign  x_z3_v [0]  = x_a0_v [3];
assign  x_z3_d [0]  = x_a0_d [3];
assign  x_a0_r [3]  = x_z3_r [0];

//------------------------------------------------------------------------------
assign  x_z0_v [1]  = x_a1_v [0];
assign  x_z0_d [1]  = x_a1_d [0];
assign  x_a1_r [0]  = x_z0_r [1];

assign  x_z1_v [1]  = x_a1_v [1];
assign  x_z1_d [1]  = x_a1_d [1];
assign  x_a1_r [1]  = x_z1_r [1];

assign  x_z2_v [1]  = x_a1_v [2];
assign  x_z2_d [1]  = x_a1_d [2];
assign  x_a1_r [2]  = x_z2_r [1];

assign  x_z3_v [1]  = x_a1_v [3];
assign  x_z3_d [1]  = x_a1_d [3];
assign  x_a1_r [3]  = x_z3_r [1];

//------------------------------------------------------------------------------
assign  x_z0_v [2]  = x_a2_v [0];
assign  x_z0_d [2]  = x_a2_d [0];
assign  x_a2_r [0]  = x_z0_r [2];

assign  x_z1_v [2]  = x_a2_v [1];
assign  x_z1_d [2]  = x_a2_d [1];
assign  x_a2_r [1]  = x_z1_r [2];

assign  x_z2_v [2]  = x_a2_v [2];
assign  x_z2_d [2]  = x_a2_d [2];
assign  x_a2_r [2]  = x_z2_r [2];

assign  x_z3_v [2]  = x_a2_v [3];
assign  x_z3_d [2]  = x_a2_d [3];
assign  x_a2_r [3]  = x_z3_r [2];

//------------------------------------------------------------------------------
assign  x_z0_v [3]  = x_a3_v [0];
assign  x_z0_d [3]  = x_a3_d [0];
assign  x_a3_r [0]  = x_z0_r [3];

assign  x_z1_v [3]  = x_a3_v [1];
assign  x_z1_d [3]  = x_a3_d [1];
assign  x_a3_r [1]  = x_z1_r [3];

assign  x_z2_v [3]  = x_a3_v [2];
assign  x_z2_d [3]  = x_a3_d [2];
assign  x_a3_r [2]  = x_z2_r [3];

assign  x_z3_v [3]  = x_a3_v [3];
assign  x_z3_d [3]  = x_a3_d [3];
assign  x_a3_r [3]  = x_z3_r [3];

//------------------------------------------------------------------------------

`ifdef  SIM
    always @(posedge clk)
        if ((i_z0_s == i_z1_s) || (i_z0_s == i_z2_s) || (i_z0_s == i_z3_s) ||
                                  (i_z1_s == i_z2_s) || (i_z1_s == i_z3_s) ||
                                                        (i_z2_s == i_z3_s)
        ) begin
            $display ("ERROR:%m: zx_s[0-3] = %d, %d, %d, %d @ %t",
                i_z0_s, i_z1_s, i_z2_s, i_z3_s,
                $time);
            $finish;
        end

`endif
endmodule

`endif
