//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------

`ifndef CORY_MASTER
    `define CORY_MASTER

    `ifndef CORY_FILENAME
        `define CORY_FILENAME  64
    `endif
    `ifndef CORY_STIM_DIR
        `define CORY_STIM_DIR   "."
    `endif

//------------------------------------------------------------------------------
//  master
//  N   : number of bits for data
//  T   : tick interval
//  V   : 0: incremental, 1: random, 2: from a file
//  I   : initial value for random data
//------------------------------------------------------------------------------
module cory_master # (
    parameter   N   = 64,
    parameter   T   = 0,
    parameter   V   = 1,
    parameter   I   = 0
) (
    input           clk,
    output          o_v,
    output  [N-1:0] o_d,
    input           i_r,
    input           reset_n
);

`ifdef  SIM
//------------------------------------------------------------------------------

reg     enabled;
reg     working;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        enabled <= 0;
    else
        enabled <= 1;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        working <= 0;
    else if (o_v)
        if (i_r)
            working <= 0;
        else
            working <= 1;

integer cnt;
wire    valid   = enabled && (cnt >= T);
assign  o_v = valid && (working ? 1 : 1);

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        cnt <= 0;
    else if (o_v && i_r)
        cnt <= 0;
    else if (!o_v)
        cnt <= cnt + 1;

//------------------------------------------------------------------------------

reg     [N-1:0] data;
assign  o_d  = data;

//------------------------------------------------------------------------------
reg     [`CORY_FILENAME*8-1:0] filename;

integer file = 0;

integer i;
initial begin
    if (V == 2) begin
        $sformat (filename, "%s/%m.bin", `CORY_STIM_DIR);
        file    = $fopen (filename, "rb");
        if (file)
            $display ("NOTE:%m: reading from '%s'", filename);
        else begin
            $display ("ERROR:%m: cannot read from '%s'", filename);
            $finish;
        end
    end
end

localparam  NUMBYTE = N/8;

initial begin
    integer d;
    if (V == 2)
        for (d=0; d<NUMBYTE; d=d+1)
            data[d*8+:8]   = $fgetc (file);
end

always @(posedge clk or negedge reset_n) begin
    integer j;
    if (!reset_n) begin
        if (V != 2)
            data    <= I;
    end
    else if (o_v && i_r) begin
        case (V)
            0:  data    <= data + 1;
            1:  data    <= data * 21 + 1;
            2:  begin
                for (j=0; j<NUMBYTE; j=j+1)
                    data[j*8+:8]    <= $fgetc (file);
            end
        endcase
    end
end

`ifdef  CORY_MON
    cory_monitor #(N) u_monitor (
        .clk        (clk),
        .i_v        (o_v),
        .i_d        (o_d),
        .i_r        (i_r),
        .reset_n    (reset_n)
    );
`endif                                          //  CORY_MON

initial begin
    if (V == 2 && (((N/NUMBYTE)*NUMBYTE) != N)) begin
        $display ("ERROR:%m: N = %d not supported", N);
        $finish;
    end
end

`endif                                          // SIM

endmodule

`endif
