//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_SRAM_ARB2
    `define CORY_SRAM_ARB2

//------------------------------------------------------------------------------
//  sram based arbiter
//------------------------------------------------------------------------------
module cory_sram_arb2 # (
    parameter   A       = 8,
    parameter   D       = 16,
    parameter   C       = 2,
    parameter   R       = D * C,
    parameter   ROUND   = 1
) (
    input           clk,

    input   [C-1:0] i_a0_cen,
    input   [C-1:0] i_a0_wen,
    input   [C-1:0] i_a0_oen,
    input   [A-1:0] i_a0_addr,
    input   [D-1:0] i_a0_wdata,
    output  [R-1:0] o_a0_rdata,
    output          o_a0_r,

    input   [C-1:0] i_a1_cen,
    input   [C-1:0] i_a1_wen,
    input   [C-1:0] i_a1_oen,
    input   [A-1:0] i_a1_addr,
    input   [D-1:0] i_a1_wdata,
    output  [R-1:0] o_a1_rdata,
    output          o_a1_r,

    output  [C-1:0] o_z_cen,
    output  [C-1:0] o_z_wen,
    output  [C-1:0] o_z_oen,
    output  [A-1:0] o_z_addr,
    output  [D-1:0] o_z_wdata,
    input   [R-1:0] i_z_rdata,
    input           i_z_r,

    input           reset_n
);

wire    sel;
reg     sel_1d;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        sel_1d  <= 0;
    else
        sel_1d  <= sel;

generate
begin : g_sel
    case (ROUND)
    1: begin

        wire    a0_v    = &i_a0_cen == 0 ? 1'b1 : 1'b0;
        wire    a1_v    = &i_a1_cen == 0 ? 1'b1 : 1'b0;
        wire    z_v     = &o_z_cen == 0 ? 1'b1 : 1'b0;
        wire    a0_vr   = a0_v & o_a0_r;
        wire    a1_vr   = a0_v & o_a1_r;
        wire    z_vr    = z_v & i_z_r;

        reg     pri;
        always @(posedge clk or negedge reset_n)
            if (!reset_n)
                pri <= 0;
            else if (z_vr)
                if (a1_vr)
                    pri <= 0;
                else if (a0_vr)
                    pri <= 1;

        assign  sel = a0_v ? 0 : a1_v ? 1 : pri;
    end

    0: begin

        wire    a0_cen_exist    = &i_a0_cen == 0 ? 1'b1 : 1'b0;

        assign  sel = !a0_cen_exist;        

    end
    endcase
end
endgenerate

assign  o_z_cen     = sel == 0    ? i_a0_cen   : i_a1_cen;
assign  o_z_wen     = sel == 0    ? i_a0_wen   : i_a1_wen;
assign  o_z_oen     = sel_1d == 0 ? i_a0_oen   : i_a1_oen;
assign  o_z_addr    = sel == 0    ? i_a0_addr  : i_a1_addr;
assign  o_z_wdata   = sel == 0    ? i_a0_wdata : i_a1_wdata;
assign  o_a0_rdata  = sel_1d == 0 ? i_z_rdata  : {D{1'bx}};
assign  o_a1_rdata  = sel_1d == 0 ? {D{1'bx}}  : i_z_rdata;
assign  o_a0_r      = sel == 0    ? i_z_r      : 1'b0;
assign  o_a1_r      = sel == 0    ? 1'b0       : i_z_r;

`ifdef  CORY_MON
//  'data changes during valid' may happen on the output port
`endif

endmodule


`endif
