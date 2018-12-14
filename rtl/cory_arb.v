//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_ARB
    `define CORY_ARB

//------------------------------------------------------------------------------
module cory_arb # (
    parameter   N       = 8,                    // # of data bits
    parameter   R       = 2,                    // 2,3,4,8 supported
    parameter   ROUND   = 1,                    // 1:round, 0:port priority (0>1)
    parameter   D       = R * N,
    parameter   Q       = 0,
    parameter   S   = R <= 2 ? 1 :
                      R <= 4 ? 2 :
                      R <= 8 ? 3 :
                      R <= 16 ? 4 :
                      R <= 32 ? 5 : 1'bx
) (
    input           clk,

    input   [R-1:0] i_ax_v,
    input   [D-1:0] i_ax_d,
    output  [R-1:0] o_ax_r,

    output          o_z_v,
    output  [N-1:0] o_z_d,
    output  [S-1:0] o_z_s,
    input           i_z_r,

    input           reset_n
);

//------------------------------------------------------------------------------

wire            a_v [0:R-1];
wire    [N-1:0] a_d [0:R-1];
wire            a_r [0:R-1];

generate
begin : g_arb
    case (R)
    8: begin
        assign  {a_v[7], a_v[6], a_v[5], a_v[4], a_v[3], a_v[2], a_v[1], a_v[0]}    = i_ax_v;
        assign  {a_d[7], a_d[6], a_d[5], a_d[4], a_d[3], a_d[2], a_d[1], a_d[0]}    = i_ax_d;
        assign  o_ax_r  = {a_r[7], a_r[6], a_r[5], a_r[4], a_r[3], a_r[2], a_r[1], a_r[0]};

        cory_arb8 #(.N(N), .Q(Q)) u_arb (
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
            .o_z_v      (o_z_v),
            .o_z_d      (o_z_d),
            .o_z_s      (o_z_s),
            .i_z_r      (i_z_r),
            .reset_n    (reset_n)
        );
    end
    4: begin
        assign  {a_v[3], a_v[2], a_v[1], a_v[0]}    = i_ax_v;
        assign  {a_d[3], a_d[2], a_d[1], a_d[0]}    = i_ax_d;
        assign  o_ax_r  = {a_r[3], a_r[2], a_r[1], a_r[0]};

        cory_arb4 #(.N(N), .Q(Q)) u_arb (
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
            .o_z_v      (o_z_v),
            .o_z_d      (o_z_d),
            .o_z_s      (o_z_s),
            .i_z_r      (i_z_r),
            .reset_n    (reset_n)
        );
    end
    3: begin
        assign  {a_v[2], a_v[1], a_v[0]}    = i_ax_v;
        assign  {a_d[2], a_d[1], a_d[0]}    = i_ax_d;
        assign  o_ax_r  = {a_r[2], a_r[1], a_r[0]};

        cory_arb3 #(.N(N), .Q(Q)) u_arb (
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
            .o_z_v      (o_z_v),
            .o_z_d      (o_z_d),
            .o_z_s      (o_z_s),
            .i_z_r      (i_z_r),
            .reset_n    (reset_n)
        );
    end
    2: begin
        assign  {a_v[1], a_v[0]}    = i_ax_v;
        assign  {a_d[1], a_d[0]}    = i_ax_d;
        assign  o_ax_r  = {a_r[1], a_r[0]};

        cory_arb2 #(.N(N), .Q(Q)) u_arb (
            .clk        (clk),
            .i_a0_v     (a_v[0]),
            .i_a0_d     (a_d[0]),
            .o_a0_r     (a_r[0]),
            .i_a1_v     (a_v[1]),
            .i_a1_d     (a_d[1]),
            .o_a1_r     (a_r[1]),
            .o_z_v      (o_z_v),
            .o_z_d      (o_z_d),
            .o_z_s      (o_z_s),
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
