//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_ROUTE8
    `define CORY_ROUTE8

//------------------------------------------------------------------------------
module cory_route8 # (
    parameter   N       = 8,
    parameter   S       = 3,                    // do not touch
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
    input           i_a4_v,
    input   [N-1:0] i_a4_d,
    output          o_a4_r,
    input           i_a5_v,
    input   [N-1:0] i_a5_d,
    output          o_a5_r,
    input           i_a6_v,
    input   [N-1:0] i_a6_d,
    output          o_a6_r,
    input           i_a7_v,
    input   [N-1:0] i_a7_d,
    output          o_a7_r,

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
    output          o_z4_v,
    output  [N-1:0] o_z4_d,
    input           i_z4_r,
    output          o_z5_v,
    output  [N-1:0] o_z5_d,
    input           i_z5_r,
    output          o_z6_v,
    output  [N-1:0] o_z6_d,
    input           i_z6_r,
    output          o_z7_v,
    output  [N-1:0] o_z7_d,
    input           i_z7_r,

    input   [S-1:0] i_z0_s,
    input   [S-1:0] i_z1_s,
    input   [S-1:0] i_z2_s,
    input   [S-1:0] i_z3_s,
    input   [S-1:0] i_z4_s,
    input   [S-1:0] i_z5_s,
    input   [S-1:0] i_z6_s,
    input   [S-1:0] i_z7_s,

    input           reset_n
);

//------------------------------------------------------------------------------
localparam  RATIO   = 2**S;

wire    [S-1:0] z0_s;
wire    [S-1:0] z1_s;
wire    [S-1:0] z2_s;
wire    [S-1:0] z3_s;
wire    [S-1:0] z4_s;
wire    [S-1:0] z5_s;
wire    [S-1:0] z6_s;
wire    [S-1:0] z7_s;

wire    no_valid    = (!i_a0_v) & (!i_a1_v) & (!i_a2_v) & (!i_a3_v) & (!i_a4_v) & (!i_a5_v) & (!i_a6_v) & (!i_a7_v) &
                      (!o_z0_v) & (!o_z1_v) & (!o_z2_v) & (!o_z3_v) & (!o_z4_v) & (!o_z5_v) & (!o_z6_v) & (!o_z7_v);

generate
begin : g_static
    case (QS)
    1: begin
        reg     [S-1:0] z0_s_reg;
        reg     [S-1:0] z1_s_reg;
        reg     [S-1:0] z2_s_reg;
        reg     [S-1:0] z3_s_reg;
        reg     [S-1:0] z4_s_reg;
        reg     [S-1:0] z5_s_reg;
        reg     [S-1:0] z6_s_reg;
        reg     [S-1:0] z7_s_reg;

        always @(posedge clk or negedge reset_n)
            if (!reset_n) begin
                z0_s_reg    <= 0;
                z1_s_reg    <= 0;
                z2_s_reg    <= 0;
                z3_s_reg    <= 0;
                z4_s_reg    <= 0;
                z5_s_reg    <= 0;
                z6_s_reg    <= 0;
                z7_s_reg    <= 0;
            end
            else if (no_valid) begin
                z0_s_reg    <= i_z0_s;
                z1_s_reg    <= i_z1_s;
                z2_s_reg    <= i_z2_s;
                z3_s_reg    <= i_z3_s;
                z4_s_reg    <= i_z4_s;
                z5_s_reg    <= i_z5_s;
                z6_s_reg    <= i_z6_s;
                z7_s_reg    <= i_z7_s;
            end

        assign  z0_s    = z0_s_reg;
        assign  z1_s    = z1_s_reg;
        assign  z2_s    = z2_s_reg;
        assign  z3_s    = z3_s_reg;
        assign  z4_s    = z4_s_reg;
        assign  z5_s    = z5_s_reg;
        assign  z6_s    = z6_s_reg;
        assign  z7_s    = z7_s_reg;
    end
    default: begin
        assign  z0_s    = i_z0_s;
        assign  z1_s    = i_z1_s;
        assign  z2_s    = i_z2_s;
        assign  z3_s    = i_z3_s;
        assign  z4_s    = i_z4_s;
        assign  z5_s    = i_z5_s;
        assign  z6_s    = i_z6_s;
        assign  z7_s    = i_z7_s;
    end
    endcase
end
endgenerate

wire    [S-1:0] a0_s    = z0_s == 0 ? 0 : z1_s == 0 ? 1 : z2_s == 0 ? 2 : z3_s == 0 ? 3 : z4_s == 0 ? 4 : z5_s == 0 ? 5 : z6_s == 0 ? 6 : z7_s == 0 ? 7 : {S{1'bx}};
wire    [S-1:0] a1_s    = z0_s == 1 ? 0 : z1_s == 1 ? 1 : z2_s == 1 ? 2 : z3_s == 1 ? 3 : z4_s == 1 ? 4 : z5_s == 1 ? 5 : z6_s == 1 ? 6 : z7_s == 1 ? 7 : {S{1'bx}};
wire    [S-1:0] a2_s    = z0_s == 2 ? 0 : z1_s == 2 ? 1 : z2_s == 2 ? 2 : z3_s == 2 ? 3 : z4_s == 2 ? 4 : z5_s == 2 ? 5 : z6_s == 2 ? 6 : z7_s == 2 ? 7 : {S{1'bx}};
wire    [S-1:0] a3_s    = z0_s == 3 ? 0 : z1_s == 3 ? 1 : z2_s == 3 ? 2 : z3_s == 3 ? 3 : z4_s == 3 ? 4 : z5_s == 3 ? 5 : z6_s == 3 ? 6 : z7_s == 3 ? 7 : {S{1'bx}};
wire    [S-1:0] a4_s    = z0_s == 4 ? 0 : z1_s == 4 ? 1 : z2_s == 4 ? 2 : z3_s == 4 ? 3 : z4_s == 4 ? 4 : z5_s == 4 ? 5 : z6_s == 4 ? 6 : z7_s == 4 ? 7 : {S{1'bx}};
wire    [S-1:0] a5_s    = z0_s == 5 ? 0 : z1_s == 5 ? 1 : z2_s == 5 ? 2 : z3_s == 5 ? 3 : z4_s == 5 ? 4 : z5_s == 5 ? 5 : z6_s == 5 ? 6 : z7_s == 5 ? 7 : {S{1'bx}};
wire    [S-1:0] a6_s    = z0_s == 6 ? 0 : z1_s == 6 ? 1 : z2_s == 6 ? 2 : z3_s == 6 ? 3 : z4_s == 6 ? 4 : z5_s == 6 ? 5 : z6_s == 6 ? 6 : z7_s == 6 ? 7 : {S{1'bx}};
wire    [S-1:0] a7_s    = z0_s == 7 ? 0 : z1_s == 7 ? 1 : z2_s == 7 ? 2 : z3_s == 7 ? 3 : z4_s == 7 ? 4 : z5_s == 7 ? 5 : z6_s == 7 ? 6 : z7_s == 7 ? 7 : {S{1'bx}};

//------------------------------------------------------------------------------
wire            x_a0_v[0:RATIO-1];
wire    [N-1:0] x_a0_d[0:RATIO-1];
wire            x_a0_r[0:RATIO-1];

cory_demux8 #(.N(N)) u_demux_a0 (
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
    .o_z4_v         (x_a0_v[4]),
    .o_z4_d         (x_a0_d[4]),
    .i_z4_r         (x_a0_r[4]),
    .o_z5_v         (x_a0_v[5]),
    .o_z5_d         (x_a0_d[5]),
    .i_z5_r         (x_a0_r[5]),
    .o_z6_v         (x_a0_v[6]),
    .o_z6_d         (x_a0_d[6]),
    .i_z6_r         (x_a0_r[6]),
    .o_z7_v         (x_a0_v[7]),
    .o_z7_d         (x_a0_d[7]),
    .i_z7_r         (x_a0_r[7]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a1_v[0:RATIO-1];
wire    [N-1:0] x_a1_d[0:RATIO-1];
wire            x_a1_r[0:RATIO-1];

cory_demux8 #(.N(N)) u_demux_a1 (
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
    .o_z4_v         (x_a1_v[4]),
    .o_z4_d         (x_a1_d[4]),
    .i_z4_r         (x_a1_r[4]),
    .o_z5_v         (x_a1_v[5]),
    .o_z5_d         (x_a1_d[5]),
    .i_z5_r         (x_a1_r[5]),
    .o_z6_v         (x_a1_v[6]),
    .o_z6_d         (x_a1_d[6]),
    .i_z6_r         (x_a1_r[6]),
    .o_z7_v         (x_a1_v[7]),
    .o_z7_d         (x_a1_d[7]),
    .i_z7_r         (x_a1_r[7]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a2_v[0:RATIO-1];
wire    [N-1:0] x_a2_d[0:RATIO-1];
wire            x_a2_r[0:RATIO-1];

cory_demux8 #(.N(N)) u_demux_a2 (
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
    .o_z4_v         (x_a2_v[4]),
    .o_z4_d         (x_a2_d[4]),
    .i_z4_r         (x_a2_r[4]),
    .o_z5_v         (x_a2_v[5]),
    .o_z5_d         (x_a2_d[5]),
    .i_z5_r         (x_a2_r[5]),
    .o_z6_v         (x_a2_v[6]),
    .o_z6_d         (x_a2_d[6]),
    .i_z6_r         (x_a2_r[6]),
    .o_z7_v         (x_a2_v[7]),
    .o_z7_d         (x_a2_d[7]),
    .i_z7_r         (x_a2_r[7]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a3_v[0:RATIO-1];
wire    [N-1:0] x_a3_d[0:RATIO-1];
wire            x_a3_r[0:RATIO-1];

cory_demux8 #(.N(N)) u_demux_a3 (
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
    .o_z4_v         (x_a3_v[4]),
    .o_z4_d         (x_a3_d[4]),
    .i_z4_r         (x_a3_r[4]),
    .o_z5_v         (x_a3_v[5]),
    .o_z5_d         (x_a3_d[5]),
    .i_z5_r         (x_a3_r[5]),
    .o_z6_v         (x_a3_v[6]),
    .o_z6_d         (x_a3_d[6]),
    .i_z6_r         (x_a3_r[6]),
    .o_z7_v         (x_a3_v[7]),
    .o_z7_d         (x_a3_d[7]),
    .i_z7_r         (x_a3_r[7]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a4_v[0:RATIO-1];
wire    [N-1:0] x_a4_d[0:RATIO-1];
wire            x_a4_r[0:RATIO-1];

cory_demux8 #(.N(N)) u_demux_a4 (
    .clk            (clk),
    .i_a_v          (i_a4_v),
    .i_a_d          (i_a4_d),
    .o_a_r          (o_a4_r),
    .i_s_v          (1'b1),
    .i_s_d          (a4_s),
    .o_s_r          (),
    .o_z0_v         (x_a4_v[0]),
    .o_z0_d         (x_a4_d[0]),
    .i_z0_r         (x_a4_r[0]),
    .o_z1_v         (x_a4_v[1]),
    .o_z1_d         (x_a4_d[1]),
    .i_z1_r         (x_a4_r[1]),
    .o_z2_v         (x_a4_v[2]),
    .o_z2_d         (x_a4_d[2]),
    .i_z2_r         (x_a4_r[2]),
    .o_z3_v         (x_a4_v[3]),
    .o_z3_d         (x_a4_d[3]),
    .i_z3_r         (x_a4_r[3]),
    .o_z4_v         (x_a4_v[4]),
    .o_z4_d         (x_a4_d[4]),
    .i_z4_r         (x_a4_r[4]),
    .o_z5_v         (x_a4_v[5]),
    .o_z5_d         (x_a4_d[5]),
    .i_z5_r         (x_a4_r[5]),
    .o_z6_v         (x_a4_v[6]),
    .o_z6_d         (x_a4_d[6]),
    .i_z6_r         (x_a4_r[6]),
    .o_z7_v         (x_a4_v[7]),
    .o_z7_d         (x_a4_d[7]),
    .i_z7_r         (x_a4_r[7]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a5_v[0:RATIO-1];
wire    [N-1:0] x_a5_d[0:RATIO-1];
wire            x_a5_r[0:RATIO-1];

cory_demux8 #(.N(N)) u_demux_a5 (
    .clk            (clk),
    .i_a_v          (i_a5_v),
    .i_a_d          (i_a5_d),
    .o_a_r          (o_a5_r),
    .i_s_v          (1'b1),
    .i_s_d          (a5_s),
    .o_s_r          (),
    .o_z0_v         (x_a5_v[0]),
    .o_z0_d         (x_a5_d[0]),
    .i_z0_r         (x_a5_r[0]),
    .o_z1_v         (x_a5_v[1]),
    .o_z1_d         (x_a5_d[1]),
    .i_z1_r         (x_a5_r[1]),
    .o_z2_v         (x_a5_v[2]),
    .o_z2_d         (x_a5_d[2]),
    .i_z2_r         (x_a5_r[2]),
    .o_z3_v         (x_a5_v[3]),
    .o_z3_d         (x_a5_d[3]),
    .i_z3_r         (x_a5_r[3]),
    .o_z4_v         (x_a5_v[4]),
    .o_z4_d         (x_a5_d[4]),
    .i_z4_r         (x_a5_r[4]),
    .o_z5_v         (x_a5_v[5]),
    .o_z5_d         (x_a5_d[5]),
    .i_z5_r         (x_a5_r[5]),
    .o_z6_v         (x_a5_v[6]),
    .o_z6_d         (x_a5_d[6]),
    .i_z6_r         (x_a5_r[6]),
    .o_z7_v         (x_a5_v[7]),
    .o_z7_d         (x_a5_d[7]),
    .i_z7_r         (x_a5_r[7]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a6_v[0:RATIO-1];
wire    [N-1:0] x_a6_d[0:RATIO-1];
wire            x_a6_r[0:RATIO-1];

cory_demux8 #(.N(N)) u_demux_a6 (
    .clk            (clk),
    .i_a_v          (i_a6_v),
    .i_a_d          (i_a6_d),
    .o_a_r          (o_a6_r),
    .i_s_v          (1'b1),
    .i_s_d          (a6_s),
    .o_s_r          (),
    .o_z0_v         (x_a6_v[0]),
    .o_z0_d         (x_a6_d[0]),
    .i_z0_r         (x_a6_r[0]),
    .o_z1_v         (x_a6_v[1]),
    .o_z1_d         (x_a6_d[1]),
    .i_z1_r         (x_a6_r[1]),
    .o_z2_v         (x_a6_v[2]),
    .o_z2_d         (x_a6_d[2]),
    .i_z2_r         (x_a6_r[2]),
    .o_z3_v         (x_a6_v[3]),
    .o_z3_d         (x_a6_d[3]),
    .i_z3_r         (x_a6_r[3]),
    .o_z4_v         (x_a6_v[4]),
    .o_z4_d         (x_a6_d[4]),
    .i_z4_r         (x_a6_r[4]),
    .o_z5_v         (x_a6_v[5]),
    .o_z5_d         (x_a6_d[5]),
    .i_z5_r         (x_a6_r[5]),
    .o_z6_v         (x_a6_v[6]),
    .o_z6_d         (x_a6_d[6]),
    .i_z6_r         (x_a6_r[6]),
    .o_z7_v         (x_a6_v[7]),
    .o_z7_d         (x_a6_d[7]),
    .i_z7_r         (x_a6_r[7]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_a7_v[0:RATIO-1];
wire    [N-1:0] x_a7_d[0:RATIO-1];
wire            x_a7_r[0:RATIO-1];

cory_demux8 #(.N(N)) u_demux_a7 (
    .clk            (clk),
    .i_a_v          (i_a7_v),
    .i_a_d          (i_a7_d),
    .o_a_r          (o_a7_r),
    .i_s_v          (1'b1),
    .i_s_d          (a7_s),
    .o_s_r          (),
    .o_z0_v         (x_a7_v[0]),
    .o_z0_d         (x_a7_d[0]),
    .i_z0_r         (x_a7_r[0]),
    .o_z1_v         (x_a7_v[1]),
    .o_z1_d         (x_a7_d[1]),
    .i_z1_r         (x_a7_r[1]),
    .o_z2_v         (x_a7_v[2]),
    .o_z2_d         (x_a7_d[2]),
    .i_z2_r         (x_a7_r[2]),
    .o_z3_v         (x_a7_v[3]),
    .o_z3_d         (x_a7_d[3]),
    .i_z3_r         (x_a7_r[3]),
    .o_z4_v         (x_a7_v[4]),
    .o_z4_d         (x_a7_d[4]),
    .i_z4_r         (x_a7_r[4]),
    .o_z5_v         (x_a7_v[5]),
    .o_z5_d         (x_a7_d[5]),
    .i_z5_r         (x_a7_r[5]),
    .o_z6_v         (x_a7_v[6]),
    .o_z6_d         (x_a7_d[6]),
    .i_z6_r         (x_a7_r[6]),
    .o_z7_v         (x_a7_v[7]),
    .o_z7_d         (x_a7_d[7]),
    .i_z7_r         (x_a7_r[7]),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z0_v[0:RATIO-1];
wire    [N-1:0] x_z0_d[0:RATIO-1];
wire            x_z0_r[0:RATIO-1];

cory_mux8 #(.N(N), .Q(Q)) u_mux_z0 (
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
    .i_a4_v         (x_z0_v[4]),
    .i_a4_d         (x_z0_d[4]),
    .o_a4_r         (x_z0_r[4]),
    .i_a5_v         (x_z0_v[5]),
    .i_a5_d         (x_z0_d[5]),
    .o_a5_r         (x_z0_r[5]),
    .i_a6_v         (x_z0_v[6]),
    .i_a6_d         (x_z0_d[6]),
    .o_a6_r         (x_z0_r[6]),
    .i_a7_v         (x_z0_v[7]),
    .i_a7_d         (x_z0_d[7]),
    .o_a7_r         (x_z0_r[7]),
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

cory_mux8 #(.N(N), .Q(Q)) u_mux_z1 (
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
    .i_a4_v         (x_z1_v[4]),
    .i_a4_d         (x_z1_d[4]),
    .o_a4_r         (x_z1_r[4]),
    .i_a5_v         (x_z1_v[5]),
    .i_a5_d         (x_z1_d[5]),
    .o_a5_r         (x_z1_r[5]),
    .i_a6_v         (x_z1_v[6]),
    .i_a6_d         (x_z1_d[6]),
    .o_a6_r         (x_z1_r[6]),
    .i_a7_v         (x_z1_v[7]),
    .i_a7_d         (x_z1_d[7]),
    .o_a7_r         (x_z1_r[7]),
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

cory_mux8 #(.N(N), .Q(Q)) u_mux_z2 (
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
    .i_a4_v         (x_z2_v[4]),
    .i_a4_d         (x_z2_d[4]),
    .o_a4_r         (x_z2_r[4]),
    .i_a5_v         (x_z2_v[5]),
    .i_a5_d         (x_z2_d[5]),
    .o_a5_r         (x_z2_r[5]),
    .i_a6_v         (x_z2_v[6]),
    .i_a6_d         (x_z2_d[6]),
    .o_a6_r         (x_z2_r[6]),
    .i_a7_v         (x_z2_v[7]),
    .i_a7_d         (x_z2_d[7]),
    .o_a7_r         (x_z2_r[7]),
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

cory_mux8 #(.N(N), .Q(Q)) u_mux_z3 (
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
    .i_a4_v         (x_z3_v[4]),
    .i_a4_d         (x_z3_d[4]),
    .o_a4_r         (x_z3_r[4]),
    .i_a5_v         (x_z3_v[5]),
    .i_a5_d         (x_z3_d[5]),
    .o_a5_r         (x_z3_r[5]),
    .i_a6_v         (x_z3_v[6]),
    .i_a6_d         (x_z3_d[6]),
    .o_a6_r         (x_z3_r[6]),
    .i_a7_v         (x_z3_v[7]),
    .i_a7_d         (x_z3_d[7]),
    .o_a7_r         (x_z3_r[7]),
    .i_s_v          (1'b1),
    .i_s_d          (z3_s),
    .o_s_r          (),
    .o_z_v          (o_z3_v),
    .o_z_d          (o_z3_d),
    .i_z_r          (i_z3_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z4_v[0:RATIO-1];
wire    [N-1:0] x_z4_d[0:RATIO-1];
wire            x_z4_r[0:RATIO-1];

cory_mux8 #(.N(N), .Q(Q)) u_mux_z4 (
    .clk            (clk),
    .i_a0_v         (x_z4_v[0]),
    .i_a0_d         (x_z4_d[0]),
    .o_a0_r         (x_z4_r[0]),
    .i_a1_v         (x_z4_v[1]),
    .i_a1_d         (x_z4_d[1]),
    .o_a1_r         (x_z4_r[1]),
    .i_a2_v         (x_z4_v[2]),
    .i_a2_d         (x_z4_d[2]),
    .o_a2_r         (x_z4_r[2]),
    .i_a3_v         (x_z4_v[3]),
    .i_a3_d         (x_z4_d[3]),
    .o_a3_r         (x_z4_r[3]),
    .i_a4_v         (x_z4_v[4]),
    .i_a4_d         (x_z4_d[4]),
    .o_a4_r         (x_z4_r[4]),
    .i_a5_v         (x_z4_v[5]),
    .i_a5_d         (x_z4_d[5]),
    .o_a5_r         (x_z4_r[5]),
    .i_a6_v         (x_z4_v[6]),
    .i_a6_d         (x_z4_d[6]),
    .o_a6_r         (x_z4_r[6]),
    .i_a7_v         (x_z4_v[7]),
    .i_a7_d         (x_z4_d[7]),
    .o_a7_r         (x_z4_r[7]),
    .i_s_v          (1'b1),
    .i_s_d          (z4_s),
    .o_s_r          (),
    .o_z_v          (o_z4_v),
    .o_z_d          (o_z4_d),
    .i_z_r          (i_z4_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z5_v[0:RATIO-1];
wire    [N-1:0] x_z5_d[0:RATIO-1];
wire            x_z5_r[0:RATIO-1];

cory_mux8 #(.N(N), .Q(Q)) u_mux_z5 (
    .clk            (clk),
    .i_a0_v         (x_z5_v[0]),
    .i_a0_d         (x_z5_d[0]),
    .o_a0_r         (x_z5_r[0]),
    .i_a1_v         (x_z5_v[1]),
    .i_a1_d         (x_z5_d[1]),
    .o_a1_r         (x_z5_r[1]),
    .i_a2_v         (x_z5_v[2]),
    .i_a2_d         (x_z5_d[2]),
    .o_a2_r         (x_z5_r[2]),
    .i_a3_v         (x_z5_v[3]),
    .i_a3_d         (x_z5_d[3]),
    .o_a3_r         (x_z5_r[3]),
    .i_a4_v         (x_z5_v[4]),
    .i_a4_d         (x_z5_d[4]),
    .o_a4_r         (x_z5_r[4]),
    .i_a5_v         (x_z5_v[5]),
    .i_a5_d         (x_z5_d[5]),
    .o_a5_r         (x_z5_r[5]),
    .i_a6_v         (x_z5_v[6]),
    .i_a6_d         (x_z5_d[6]),
    .o_a6_r         (x_z5_r[6]),
    .i_a7_v         (x_z5_v[7]),
    .i_a7_d         (x_z5_d[7]),
    .o_a7_r         (x_z5_r[7]),
    .i_s_v          (1'b1),
    .i_s_d          (z5_s),
    .o_s_r          (),
    .o_z_v          (o_z5_v),
    .o_z_d          (o_z5_d),
    .i_z_r          (i_z5_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z6_v[0:RATIO-1];
wire    [N-1:0] x_z6_d[0:RATIO-1];
wire            x_z6_r[0:RATIO-1];

cory_mux8 #(.N(N), .Q(Q)) u_mux_z6 (
    .clk            (clk),
    .i_a0_v         (x_z6_v[0]),
    .i_a0_d         (x_z6_d[0]),
    .o_a0_r         (x_z6_r[0]),
    .i_a1_v         (x_z6_v[1]),
    .i_a1_d         (x_z6_d[1]),
    .o_a1_r         (x_z6_r[1]),
    .i_a2_v         (x_z6_v[2]),
    .i_a2_d         (x_z6_d[2]),
    .o_a2_r         (x_z6_r[2]),
    .i_a3_v         (x_z6_v[3]),
    .i_a3_d         (x_z6_d[3]),
    .o_a3_r         (x_z6_r[3]),
    .i_a4_v         (x_z6_v[4]),
    .i_a4_d         (x_z6_d[4]),
    .o_a4_r         (x_z6_r[4]),
    .i_a5_v         (x_z6_v[5]),
    .i_a5_d         (x_z6_d[5]),
    .o_a5_r         (x_z6_r[5]),
    .i_a6_v         (x_z6_v[6]),
    .i_a6_d         (x_z6_d[6]),
    .o_a6_r         (x_z6_r[6]),
    .i_a7_v         (x_z6_v[7]),
    .i_a7_d         (x_z6_d[7]),
    .o_a7_r         (x_z6_r[7]),
    .i_s_v          (1'b1),
    .i_s_d          (z6_s),
    .o_s_r          (),
    .o_z_v          (o_z6_v),
    .o_z_d          (o_z6_d),
    .i_z_r          (i_z6_r),
    .reset_n        (reset_n)
);

//------------------------------------------------------------------------------
wire            x_z7_v[0:RATIO-1];
wire    [N-1:0] x_z7_d[0:RATIO-1];
wire            x_z7_r[0:RATIO-1];

cory_mux8 #(.N(N), .Q(Q)) u_mux_z7 (
    .clk            (clk),
    .i_a0_v         (x_z7_v[0]),
    .i_a0_d         (x_z7_d[0]),
    .o_a0_r         (x_z7_r[0]),
    .i_a1_v         (x_z7_v[1]),
    .i_a1_d         (x_z7_d[1]),
    .o_a1_r         (x_z7_r[1]),
    .i_a2_v         (x_z7_v[2]),
    .i_a2_d         (x_z7_d[2]),
    .o_a2_r         (x_z7_r[2]),
    .i_a3_v         (x_z7_v[3]),
    .i_a3_d         (x_z7_d[3]),
    .o_a3_r         (x_z7_r[3]),
    .i_a4_v         (x_z7_v[4]),
    .i_a4_d         (x_z7_d[4]),
    .o_a4_r         (x_z7_r[4]),
    .i_a5_v         (x_z7_v[5]),
    .i_a5_d         (x_z7_d[5]),
    .o_a5_r         (x_z7_r[5]),
    .i_a6_v         (x_z7_v[6]),
    .i_a6_d         (x_z7_d[6]),
    .o_a6_r         (x_z7_r[6]),
    .i_a7_v         (x_z7_v[7]),
    .i_a7_d         (x_z7_d[7]),
    .o_a7_r         (x_z7_r[7]),
    .i_s_v          (1'b1),
    .i_s_d          (z7_s),
    .o_s_r          (),
    .o_z_v          (o_z7_v),
    .o_z_d          (o_z7_d),
    .i_z_r          (i_z7_r),
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

assign  x_z4_v [0]  = x_a0_v [4];
assign  x_z4_d [0]  = x_a0_d [4];
assign  x_a0_r [4]  = x_z4_r [0];

assign  x_z5_v [0]  = x_a0_v [5];
assign  x_z5_d [0]  = x_a0_d [5];
assign  x_a0_r [5]  = x_z5_r [0];

assign  x_z6_v [0]  = x_a0_v [6];
assign  x_z6_d [0]  = x_a0_d [6];
assign  x_a0_r [6]  = x_z6_r [0];

assign  x_z7_v [0]  = x_a0_v [7];
assign  x_z7_d [0]  = x_a0_d [7];
assign  x_a0_r [7]  = x_z7_r [0];

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

assign  x_z4_v [1]  = x_a1_v [4];
assign  x_z4_d [1]  = x_a1_d [4];
assign  x_a1_r [4]  = x_z4_r [1];

assign  x_z5_v [1]  = x_a1_v [5];
assign  x_z5_d [1]  = x_a1_d [5];
assign  x_a1_r [5]  = x_z5_r [1];

assign  x_z6_v [1]  = x_a1_v [6];
assign  x_z6_d [1]  = x_a1_d [6];
assign  x_a1_r [6]  = x_z6_r [1];

assign  x_z7_v [1]  = x_a1_v [7];
assign  x_z7_d [1]  = x_a1_d [7];
assign  x_a1_r [7]  = x_z7_r [1];

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

assign  x_z4_v [2]  = x_a2_v [4];
assign  x_z4_d [2]  = x_a2_d [4];
assign  x_a2_r [4]  = x_z4_r [2];

assign  x_z5_v [2]  = x_a2_v [5];
assign  x_z5_d [2]  = x_a2_d [5];
assign  x_a2_r [5]  = x_z5_r [2];

assign  x_z6_v [2]  = x_a2_v [6];
assign  x_z6_d [2]  = x_a2_d [6];
assign  x_a2_r [6]  = x_z6_r [2];

assign  x_z7_v [2]  = x_a2_v [7];
assign  x_z7_d [2]  = x_a2_d [7];
assign  x_a2_r [7]  = x_z7_r [2];

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

assign  x_z4_v [3]  = x_a3_v [4];
assign  x_z4_d [3]  = x_a3_d [4];
assign  x_a3_r [4]  = x_z4_r [3];

assign  x_z5_v [3]  = x_a3_v [5];
assign  x_z5_d [3]  = x_a3_d [5];
assign  x_a3_r [5]  = x_z5_r [3];

assign  x_z6_v [3]  = x_a3_v [6];
assign  x_z6_d [3]  = x_a3_d [6];
assign  x_a3_r [6]  = x_z6_r [3];

assign  x_z7_v [3]  = x_a3_v [7];
assign  x_z7_d [3]  = x_a3_d [7];
assign  x_a3_r [7]  = x_z7_r [3];

//------------------------------------------------------------------------------
assign  x_z0_v [4]  = x_a4_v [0];
assign  x_z0_d [4]  = x_a4_d [0];
assign  x_a4_r [0]  = x_z0_r [4];

assign  x_z1_v [4]  = x_a4_v [1];
assign  x_z1_d [4]  = x_a4_d [1];
assign  x_a4_r [1]  = x_z1_r [4];

assign  x_z2_v [4]  = x_a4_v [2];
assign  x_z2_d [4]  = x_a4_d [2];
assign  x_a4_r [2]  = x_z2_r [4];

assign  x_z3_v [4]  = x_a4_v [3];
assign  x_z3_d [4]  = x_a4_d [3];
assign  x_a4_r [3]  = x_z3_r [4];

assign  x_z4_v [4]  = x_a4_v [4];
assign  x_z4_d [4]  = x_a4_d [4];
assign  x_a4_r [4]  = x_z4_r [4];

assign  x_z5_v [4]  = x_a4_v [5];
assign  x_z5_d [4]  = x_a4_d [5];
assign  x_a4_r [5]  = x_z5_r [4];

assign  x_z6_v [4]  = x_a4_v [6];
assign  x_z6_d [4]  = x_a4_d [6];
assign  x_a4_r [6]  = x_z6_r [4];

assign  x_z7_v [4]  = x_a4_v [7];
assign  x_z7_d [4]  = x_a4_d [7];
assign  x_a4_r [7]  = x_z7_r [4];

//------------------------------------------------------------------------------
assign  x_z0_v [5]  = x_a5_v [0];
assign  x_z0_d [5]  = x_a5_d [0];
assign  x_a5_r [0]  = x_z0_r [5];

assign  x_z1_v [5]  = x_a5_v [1];
assign  x_z1_d [5]  = x_a5_d [1];
assign  x_a5_r [1]  = x_z1_r [5];

assign  x_z2_v [5]  = x_a5_v [2];
assign  x_z2_d [5]  = x_a5_d [2];
assign  x_a5_r [2]  = x_z2_r [5];

assign  x_z3_v [5]  = x_a5_v [3];
assign  x_z3_d [5]  = x_a5_d [3];
assign  x_a5_r [3]  = x_z3_r [5];

assign  x_z4_v [5]  = x_a5_v [4];
assign  x_z4_d [5]  = x_a5_d [4];
assign  x_a5_r [4]  = x_z4_r [5];

assign  x_z5_v [5]  = x_a5_v [5];
assign  x_z5_d [5]  = x_a5_d [5];
assign  x_a5_r [5]  = x_z5_r [5];

assign  x_z6_v [5]  = x_a5_v [6];
assign  x_z6_d [5]  = x_a5_d [6];
assign  x_a5_r [6]  = x_z6_r [5];

assign  x_z7_v [5]  = x_a5_v [7];
assign  x_z7_d [5]  = x_a5_d [7];
assign  x_a5_r [7]  = x_z7_r [5];

//------------------------------------------------------------------------------
assign  x_z0_v [6]  = x_a6_v [0];
assign  x_z0_d [6]  = x_a6_d [0];
assign  x_a6_r [0]  = x_z0_r [6];

assign  x_z1_v [6]  = x_a6_v [1];
assign  x_z1_d [6]  = x_a6_d [1];
assign  x_a6_r [1]  = x_z1_r [6];

assign  x_z2_v [6]  = x_a6_v [2];
assign  x_z2_d [6]  = x_a6_d [2];
assign  x_a6_r [2]  = x_z2_r [6];

assign  x_z3_v [6]  = x_a6_v [3];
assign  x_z3_d [6]  = x_a6_d [3];
assign  x_a6_r [3]  = x_z3_r [6];

assign  x_z4_v [6]  = x_a6_v [4];
assign  x_z4_d [6]  = x_a6_d [4];
assign  x_a6_r [4]  = x_z4_r [6];

assign  x_z5_v [6]  = x_a6_v [5];
assign  x_z5_d [6]  = x_a6_d [5];
assign  x_a6_r [5]  = x_z5_r [6];

assign  x_z6_v [6]  = x_a6_v [6];
assign  x_z6_d [6]  = x_a6_d [6];
assign  x_a6_r [6]  = x_z6_r [6];

assign  x_z7_v [6]  = x_a6_v [7];
assign  x_z7_d [6]  = x_a6_d [7];
assign  x_a6_r [7]  = x_z7_r [6];

//------------------------------------------------------------------------------
assign  x_z0_v [7]  = x_a7_v [0];
assign  x_z0_d [7]  = x_a7_d [0];
assign  x_a7_r [0]  = x_z0_r [7];

assign  x_z1_v [7]  = x_a7_v [1];
assign  x_z1_d [7]  = x_a7_d [1];
assign  x_a7_r [1]  = x_z1_r [7];

assign  x_z2_v [7]  = x_a7_v [2];
assign  x_z2_d [7]  = x_a7_d [2];
assign  x_a7_r [2]  = x_z2_r [7];

assign  x_z3_v [7]  = x_a7_v [3];
assign  x_z3_d [7]  = x_a7_d [3];
assign  x_a7_r [3]  = x_z3_r [7];

assign  x_z4_v [7]  = x_a7_v [4];
assign  x_z4_d [7]  = x_a7_d [4];
assign  x_a7_r [4]  = x_z4_r [7];

assign  x_z5_v [7]  = x_a7_v [5];
assign  x_z5_d [7]  = x_a7_d [5];
assign  x_a7_r [5]  = x_z5_r [7];

assign  x_z6_v [7]  = x_a7_v [6];
assign  x_z6_d [7]  = x_a7_d [6];
assign  x_a7_r [6]  = x_z6_r [7];

assign  x_z7_v [7]  = x_a7_v [7];
assign  x_z7_d [7]  = x_a7_d [7];
assign  x_a7_r [7]  = x_z7_r [7];

//------------------------------------------------------------------------------

`ifdef  SIM
    always @(posedge clk)
        if ((i_z0_s == i_z1_s) || (i_z0_s == i_z2_s) || (i_z0_s == i_z3_s) || (i_z0_s == i_z4_s) || (i_z0_s == i_z5_s) || (i_z0_s == i_z6_s) || (i_z0_s == i_z7_s) ||
                                  (i_z1_s == i_z2_s) || (i_z1_s == i_z3_s) || (i_z1_s == i_z4_s) || (i_z1_s == i_z5_s) || (i_z1_s == i_z6_s) || (i_z1_s == i_z7_s) ||
                                                        (i_z2_s == i_z3_s) || (i_z2_s == i_z4_s) || (i_z2_s == i_z5_s) || (i_z2_s == i_z6_s) || (i_z2_s == i_z7_s) ||
                                                                              (i_z3_s == i_z4_s) || (i_z3_s == i_z5_s) || (i_z3_s == i_z6_s) || (i_z3_s == i_z7_s) ||
                                                                                                    (i_z4_s == i_z5_s) || (i_z4_s == i_z6_s) || (i_z4_s == i_z7_s) ||
                                                                                                                          (i_z5_s == i_z6_s) || (i_z5_s == i_z7_s) ||
                                                                                                                                                (i_z6_s == i_z7_s)
        ) begin
            $display ("ERROR:%m: zx_s[0-7] = %d, %d, %d, %d, %d, %d, %d, %d @ %t",
                i_z0_s, i_z1_s, i_z2_s, i_z3_s, i_z4_s, i_z5_s, i_z6_s, i_z7_s,
                $time);
            $finish;
        end

`endif
endmodule

`endif
