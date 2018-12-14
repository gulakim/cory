//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_DEMUX
    `define CORY_DEMUX

//------------------------------------------------------------------------------
module cory_demux # (
    parameter   N   = 8,
    parameter   R   = 2,            // 2,3,4,8,16
    parameter   D   = R * N,        // do not touch
    parameter   S   = R <= 2 ? 1 :
                      R <= 4 ? 2 :
                      R <= 8 ? 3 :
                      R <= 16 ? 4 :
                      R <= 32 ? 5 : 1'bx
) (
    input           clk,

    input           i_a_v,
    input   [N-1:0] i_a_d,
    output          o_a_r,

    input           i_s_v,
    input   [S-1:0] i_s_d,
    output          o_s_r,

    output  [R-1:0] o_zx_v,
    output  [D-1:0] o_zx_d,
    input   [R-1:0] i_zx_r,

    input           reset_n
);

//------------------------------------------------------------------------------

wire            z_v [0:R-1];
wire    [N-1:0] z_d [0:R-1];
wire            z_r [0:R-1];

generate
begin : g_demux
    case (R)
    16: begin
        assign  o_zx_v  = {z_v[15], z_v[14], z_v[13], z_v[12], z_v[11], z_v[10], z_v[9], z_v[8],
                           z_v[7], z_v[6], z_v[5], z_v[4], z_v[3], z_v[2], z_v[1], z_v[0]};
        assign  o_zx_d  = {z_d[15], z_d[14], z_d[13], z_d[12], z_d[11], z_d[10], z_d[9], z_d[8],
                           z_d[7], z_d[6], z_d[5], z_d[4], z_d[3], z_d[2], z_d[1], z_d[0]};
        assign  {z_r[15], z_r[14], z_r[13], z_r[12], z_r[11], z_r[10], z_r[9], z_r[8],
                 z_r[7], z_r[6], z_r[5], z_r[4], z_r[3], z_r[2], z_r[1], z_r[0]}    = i_zx_r;

        cory_demux16 #(.N(N)) u_demux (
            .clk        (clk),
            .i_a_v      (i_a_v),
            .i_a_d      (i_a_d),
            .o_a_r      (o_a_r),
            .i_s_v      (i_s_v),
            .i_s_d      (i_s_d),
            .o_s_r      (o_s_r),
            .o_z0_v     (z_v[0]),
            .o_z0_d     (z_d[0]),
            .i_z0_r     (z_r[0]),
            .o_z1_v     (z_v[1]),
            .o_z1_d     (z_d[1]),
            .i_z1_r     (z_r[1]),
            .o_z2_v     (z_v[2]),
            .o_z2_d     (z_d[2]),
            .i_z2_r     (z_r[2]),
            .o_z3_v     (z_v[3]),
            .o_z3_d     (z_d[3]),
            .i_z3_r     (z_r[3]),
            .o_z4_v     (z_v[4]),
            .o_z4_d     (z_d[4]),
            .i_z4_r     (z_r[4]),
            .o_z5_v     (z_v[5]),
            .o_z5_d     (z_d[5]),
            .i_z5_r     (z_r[5]),
            .o_z6_v     (z_v[6]),
            .o_z6_d     (z_d[6]),
            .i_z6_r     (z_r[6]),
            .o_z7_v     (z_v[7]),
            .o_z7_d     (z_d[7]),
            .i_z7_r     (z_r[7]),
            .o_z8_v     (z_v[8]),
            .o_z8_d     (z_d[8]),
            .i_z8_r     (z_r[8]),
            .o_z9_v     (z_v[9]),
            .o_z9_d     (z_d[9]),
            .i_z9_r     (z_r[9]),
            .o_za_v     (z_v[10]),
            .o_za_d     (z_d[10]),
            .i_za_r     (z_r[10]),
            .o_zb_v     (z_v[11]),
            .o_zb_d     (z_d[11]),
            .i_zb_r     (z_r[11]),
            .o_zc_v     (z_v[12]),
            .o_zc_d     (z_d[12]),
            .i_zc_r     (z_r[12]),
            .o_zd_v     (z_v[13]),
            .o_zd_d     (z_d[13]),
            .i_zd_r     (z_r[13]),
            .o_ze_v     (z_v[14]),
            .o_ze_d     (z_d[14]),
            .i_ze_r     (z_r[14]),
            .o_zf_v     (z_v[15]),
            .o_zf_d     (z_d[15]),
            .i_zf_r     (z_r[15]),
            .reset_n    (reset_n)
        );
    end
    8: begin
        assign  o_zx_v  = {z_v[7], z_v[6], z_v[5], z_v[4], z_v[3], z_v[2], z_v[1], z_v[0]};
        assign  o_zx_d  = {z_d[7], z_d[6], z_d[5], z_d[4], z_d[3], z_d[2], z_d[1], z_d[0]};
        assign  {z_r[7], z_r[6], z_r[5], z_r[4], z_r[3], z_r[2], z_r[1], z_r[0]}    = i_zx_r;

        cory_demux8 #(.N(N)) u_demux (
            .clk        (clk),
            .i_a_v      (i_a_v),
            .i_a_d      (i_a_d),
            .o_a_r      (o_a_r),
            .i_s_v      (i_s_v),
            .i_s_d      (i_s_d),
            .o_s_r      (o_s_r),
            .o_z0_v     (z_v[0]),
            .o_z0_d     (z_d[0]),
            .i_z0_r     (z_r[0]),
            .o_z1_v     (z_v[1]),
            .o_z1_d     (z_d[1]),
            .i_z1_r     (z_r[1]),
            .o_z2_v     (z_v[2]),
            .o_z2_d     (z_d[2]),
            .i_z2_r     (z_r[2]),
            .o_z3_v     (z_v[3]),
            .o_z3_d     (z_d[3]),
            .i_z3_r     (z_r[3]),
            .o_z4_v     (z_v[4]),
            .o_z4_d     (z_d[4]),
            .i_z4_r     (z_r[4]),
            .o_z5_v     (z_v[5]),
            .o_z5_d     (z_d[5]),
            .i_z5_r     (z_r[5]),
            .o_z6_v     (z_v[6]),
            .o_z6_d     (z_d[6]),
            .i_z6_r     (z_r[6]),
            .o_z7_v     (z_v[7]),
            .o_z7_d     (z_d[7]),
            .i_z7_r     (z_r[7]),
            .reset_n    (reset_n)
        );
    end
    4: begin
        assign  o_zx_v  = {z_v[3], z_v[2], z_v[1], z_v[0]};
        assign  o_zx_d  = {z_d[3], z_d[2], z_d[1], z_d[0]};
        assign  {z_r[3], z_r[2], z_r[1], z_r[0]}    = i_zx_r;

        cory_demux4 #(.N(N)) u_demux (
            .clk        (clk),
            .i_a_v      (i_a_v),
            .i_a_d      (i_a_d),
            .o_a_r      (o_a_r),
            .i_s_v      (i_s_v),
            .i_s_d      (i_s_d),
            .o_s_r      (o_s_r),
            .o_z0_v     (z_v[0]),
            .o_z0_d     (z_d[0]),
            .i_z0_r     (z_r[0]),
            .o_z1_v     (z_v[1]),
            .o_z1_d     (z_d[1]),
            .i_z1_r     (z_r[1]),
            .o_z2_v     (z_v[2]),
            .o_z2_d     (z_d[2]),
            .i_z2_r     (z_r[2]),
            .o_z3_v     (z_v[3]),
            .o_z3_d     (z_d[3]),
            .i_z3_r     (z_r[3]),
            .reset_n    (reset_n)
        );
    end
    3: begin
        assign  o_zx_v  = {z_v[2], z_v[1], z_v[0]};
        assign  o_zx_d  = {z_d[2], z_d[1], z_d[0]};
        assign  {z_r[2], z_r[1], z_r[0]}    = i_zx_r;

        cory_demux3 #(.N(N)) u_demux (
            .clk        (clk),
            .i_a_v      (i_a_v),
            .i_a_d      (i_a_d),
            .o_a_r      (o_a_r),
            .i_s_v      (i_s_v),
            .i_s_d      (i_s_d),
            .o_s_r      (o_s_r),
            .o_z0_v     (z_v[0]),
            .o_z0_d     (z_d[0]),
            .i_z0_r     (z_r[0]),
            .o_z1_v     (z_v[1]),
            .o_z1_d     (z_d[1]),
            .i_z1_r     (z_r[1]),
            .o_z2_v     (z_v[2]),
            .o_z2_d     (z_d[2]),
            .i_z2_r     (z_r[2]),
            .reset_n    (reset_n)
        );
    end
    2: begin
        assign  o_zx_v  = {z_v[1], z_v[0]};
        assign  o_zx_d  = {z_d[1], z_d[0]};
        assign  {z_r[1], z_r[0]}    = i_zx_r;

        cory_demux2 #(.N(N)) u_demux (
            .clk        (clk),
            .i_a_v      (i_a_v),
            .i_a_d      (i_a_d),
            .o_a_r      (o_a_r),
            .i_s_v      (i_s_v),
            .i_s_d      (i_s_d),
            .o_s_r      (o_s_r),
            .o_z0_v     (z_v[0]),
            .o_z0_d     (z_d[0]),
            .i_z0_r     (z_r[0]),
            .o_z1_v     (z_v[1]),
            .o_z1_d     (z_d[1]),
            .i_z1_r     (z_r[1]),
            .reset_n    (reset_n)
        );
    end
`ifdef  SIM
    default: begin
        initial begin
            $display ("ERROR:%m: R(%1d) not supported", R);
            $finish;
        end
    end
`endif  //  SIM
    endcase
end
endgenerate

endmodule

`endif
