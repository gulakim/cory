//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_MUX
    `define CORY_MUX

//------------------------------------------------------------------------------
module cory_mux # (
    parameter   N   = 8,                        // # of data bits
    parameter   R   = 2,
    parameter   Q   = 0,
    parameter   D   = R * N,                    // do not touch
    parameter   S   = R <= 2 ? 1 :
                      R <= 4 ? 2 :
                      R <= 8 ? 3 :
                      R <= 16 ? 4 :
                      R <= 32 ? 5 : 1'bx
) (
    input           clk,

    input   [R-1:0] i_ax_v,
    input   [N-1:0] i_ax_d,
    output  [R-1:0] o_ax_r,

    input           i_s_v,
    input   [S-1:0] i_s_d,
    output          o_s_r,

    output          o_z_v,
    output  [N-1:0] o_z_d,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------

wire            a_v [0:R-1];
wire    [N-1:0] a_d [0:R-1];
wire            a_r [0:R-1];

generate
begin : g_mux
    case (R)
    16: begin
        assign  {a_v[15], a_v[14], a_v[13], a_v[12], a_v[11], a_v[10], a_v[9], a_v[8],
                 a_v[7], a_v[6], a_v[5], a_v[4], a_v[3], a_v[2], a_v[1], a_v[0]}    = i_ax_v;
        assign  {a_d[15], a_d[14], a_d[13], a_d[12], a_d[11], a_d[10], a_d[9], a_d[8],
                 a_d[7], a_d[6], a_d[5], a_d[4], a_d[3], a_d[2], a_d[1], a_d[0]}    = i_ax_d;
        assign  o_ax_r  = {a_r[15], a_r[14], a_r[13], a_r[12], a_r[11], a_r[10], a_r[9], a_r[8],
                           a_r[7], a_r[6], a_r[5], a_r[4], a_r[3], a_r[2], a_r[1], a_r[0]};

        cory_mux16 #(.N(N), .Q(Q)) u_mux (
            .clk        (clk),
            .i_a0_v     (a_v[0]),
            .i_a0_d     (a_d[0]),
            .o_a0_r     (a_r[0]),
            .i_a1_v     (a_v[1]),
            .i_a1_d     (a_d[1]),
            .o_a1_r     (a_r[1]),
            .i_a2_v     (a_v[2]),
            .i_a2_d     (a_d[2]),
            .o_a2_r     (a_r[2]),
            .i_a3_v     (a_v[3]),
            .i_a3_d     (a_d[3]),
            .o_a3_r     (a_r[3]),
            .i_a4_v     (a_v[4]),
            .i_a4_d     (a_d[4]),
            .o_a4_r     (a_r[4]),
            .i_a5_v     (a_v[5]),
            .i_a5_d     (a_d[5]),
            .o_a5_r     (a_r[5]),
            .i_a6_v     (a_v[6]),
            .i_a6_d     (a_d[6]),
            .o_a6_r     (a_r[6]),
            .i_a7_v     (a_v[7]),
            .i_a7_d     (a_d[7]),
            .o_a7_r     (a_r[7]),
            .i_a8_v     (a_v[8]),
            .i_a8_d     (a_d[8]),
            .o_a8_r     (a_r[8]),
            .i_a9_v     (a_v[9]),
            .i_a9_d     (a_d[9]),
            .o_a9_r     (a_r[9]),
            .i_aa_v     (a_v[10]),
            .i_aa_d     (a_d[10]),
            .o_aa_r     (a_r[10]),
            .i_ab_v     (a_v[11]),
            .i_ab_d     (a_d[11]),
            .o_ab_r     (a_r[11]),
            .i_ac_v     (a_v[12]),
            .i_ac_d     (a_d[12]),
            .o_ac_r     (a_r[12]),
            .i_ad_v     (a_v[13]),
            .i_ad_d     (a_d[13]),
            .o_ad_r     (a_r[13]),
            .i_ae_v     (a_v[14]),
            .i_ae_d     (a_d[14]),
            .o_ae_r     (a_r[14]),
            .i_af_v     (a_v[15]),
            .i_af_d     (a_d[15]),
            .o_af_r     (a_r[15]),
            .i_s_v      (i_s_v),
            .i_s_d      (i_s_d),
            .o_s_r      (o_s_r),
            .o_z_v      (o_z_v),
            .o_z_d      (o_z_d),
            .i_z_r      (i_z_r),
            .reset_n    (reset_n)
        );
    end
    8: begin
        assign  {a_v[7], a_v[6], a_v[5], a_v[4], a_v[3], a_v[2], a_v[1], a_v[0]}    = i_ax_v;
        assign  {a_d[7], a_d[6], a_d[5], a_d[4], a_d[3], a_d[2], a_d[1], a_d[0]}    = i_ax_d;
        assign  o_ax_r  = {a_r[7], a_r[6], a_r[5], a_r[4], a_r[3], a_r[2], a_r[1], a_r[0]};

        cory_mux8 #(.N(N), .Q(Q)) u_mux (
            .clk        (clk),
            .i_a0_v     (a_v[0]),
            .i_a0_d     (a_d[0]),
            .o_a0_r     (a_r[0]),
            .i_a1_v     (a_v[1]),
            .i_a1_d     (a_d[1]),
            .o_a1_r     (a_r[1]),
            .i_a2_v     (a_v[2]),
            .i_a2_d     (a_d[2]),
            .o_a2_r     (a_r[2]),
            .i_a3_v     (a_v[3]),
            .i_a3_d     (a_d[3]),
            .o_a3_r     (a_r[3]),
            .i_a4_v     (a_v[4]),
            .i_a4_d     (a_d[4]),
            .o_a4_r     (a_r[4]),
            .i_a5_v     (a_v[5]),
            .i_a5_d     (a_d[5]),
            .o_a5_r     (a_r[5]),
            .i_a6_v     (a_v[6]),
            .i_a6_d     (a_d[6]),
            .o_a6_r     (a_r[6]),
            .i_a7_v     (a_v[7]),
            .i_a7_d     (a_d[7]),
            .o_a7_r     (a_r[7]),
            .i_s_v      (i_s_v),
            .i_s_d      (i_s_d),
            .o_s_r      (o_s_r),
            .o_z_v      (o_z_v),
            .o_z_d      (o_z_d),
            .i_z_r      (i_z_r),
            .reset_n    (reset_n)
        );
    end
    4: begin
        assign  {a_v[3], a_v[2], a_v[1], a_v[0]}    = i_ax_v;
        assign  {a_d[3], a_d[2], a_d[1], a_d[0]}    = i_ax_d;
        assign  o_ax_r  = {a_r[3], a_r[2], a_r[1], a_r[0]};

        cory_mux4 #(.N(N), .Q(Q)) u_mux (
            .clk        (clk),
            .i_a0_v     (a_v[0]),
            .i_a0_d     (a_d[0]),
            .o_a0_r     (a_r[0]),
            .i_a1_v     (a_v[1]),
            .i_a1_d     (a_d[1]),
            .o_a1_r     (a_r[1]),
            .i_a2_v     (a_v[2]),
            .i_a2_d     (a_d[2]),
            .o_a2_r     (a_r[2]),
            .i_a3_v     (a_v[3]),
            .i_a3_d     (a_d[3]),
            .o_a3_r     (a_r[3]),
            .i_s_v      (i_s_v),
            .i_s_d      (i_s_d),
            .o_s_r      (o_s_r),
            .o_z_v      (o_z_v),
            .o_z_d      (o_z_d),
            .i_z_r      (i_z_r),
            .reset_n    (reset_n)
        );
    end
    3: begin
        assign  {a_v[2], a_v[1], a_v[0]}    = i_ax_v;
        assign  {a_d[2], a_d[1], a_d[0]}    = i_ax_d;
        assign  o_ax_r  = {a_r[2], a_r[1], a_r[0]};

        cory_mux3 #(.N(N), .Q(Q)) u_mux (
            .clk        (clk),
            .i_a0_v     (a_v[0]),
            .i_a0_d     (a_d[0]),
            .o_a0_r     (a_r[0]),
            .i_a1_v     (a_v[1]),
            .i_a1_d     (a_d[1]),
            .o_a1_r     (a_r[1]),
            .i_a2_v     (a_v[2]),
            .i_a2_d     (a_d[2]),
            .o_a2_r     (a_r[2]),
            .i_s_v      (i_s_v),
            .i_s_d      (i_s_d),
            .o_s_r      (o_s_r),
            .o_z_v      (o_z_v),
            .o_z_d      (o_z_d),
            .i_z_r      (i_z_r),
            .reset_n    (reset_n)
        );
    end
    2: begin
        assign  {a_v[1], a_v[0]}    = i_ax_v;
        assign  {a_d[1], a_d[0]}    = i_ax_d;
        assign  o_ax_r  = {a_r[1], a_r[0]};

        cory_mux2 #(.N(N), .Q(Q)) u_mux (
            .clk        (clk),
            .i_a0_v     (a_v[0]),
            .i_a0_d     (a_d[0]),
            .o_a0_r     (a_r[0]),
            .i_a1_v     (a_v[1]),
            .i_a1_d     (a_d[1]),
            .o_a1_r     (a_r[1]),
            .i_s_v      (i_s_v),
            .i_s_d      (i_s_d),
            .o_s_r      (o_s_r),
            .o_z_v      (o_z_v),
            .o_z_d      (o_z_d),
            .i_z_r      (i_z_r),
            .reset_n    (reset_n)
        );
    end
`ifdef  SIM
    default: begin
        initial begin
            $display ("ERROR:%m: R=%1d not supported", R);
            $finish;
        end
    end
`endif  //  SIM
    endcase
end
endgenerate

endmodule


`endif
