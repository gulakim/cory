//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_S2S
    `define CORY_S2S

//------------------------------------------------------------------------------
//  width conversion
//------------------------------------------------------------------------------
module cory_s2s # (
    parameter   N   = 8,                // # bits in common for A and Z
    parameter   A   = 8*N,              // input width
    parameter   Z   = 3*N,              // output width
    parameter   Q   = A/N + 2 * Z/N     // queue size in N, do not touch
) (
    input           clk,

    input           i_a_v,
    input   [A-1:0] i_a_d,
    output          o_a_r,

    output          o_z_v,
    output  [Z-1:0] o_z_d,
    input           i_z_r,

    input           reset_n

);

//------------------------------------------------------------------------------
wire    a_vr       = i_a_v & o_a_r;
wire    z_vr       = o_z_v & i_z_r;

localparam  NA  = A/N;
localparam  NZ  = Z/N;
localparam  MQ  = f_log2 (Q);

wire    [N-1:0] a_byte[0:NA-1];

genvar a;
generate
begin : g_a_byte
    for (a=0; a<NA; a=a+1) begin : p_a_byte
        assign  a_byte[a]   = i_a_d[a*N+N-1:a*N];
    end
end
endgenerate

//------------------------------------------------------------------------------
reg     [N-1:0]     queue [0:Q-1];
reg     [MQ:0]      queue_cnt;              // byte count
reg     [MQ-1:0]    queue_rptr;
reg     [MQ-1:0]    queue_wptr;
wire    [MQ:0]      queue_rptr_NA;
wire    [MQ:0]      queue_wptr_NZ;

wire    queue_full  = queue_cnt > Q-NA;
wire    queue_empty = queue_cnt < NZ;

always @(posedge clk or negedge reset_n) begin : p_queue
    integer i;
    if (!reset_n) begin
        for (i=0; i<Q; i=i+1)
            queue[i]    <= 0;
        queue_cnt   <= 0;
        queue_wptr  <= 0;
        queue_rptr  <= 0;
    end
    else begin
        if (a_vr) begin
            for (i=0; i<NA; i=i+1)
                queue[f_wrap(queue_wptr+i, Q)] <= a_byte[i];
            queue_wptr  <= f_wrap (queue_wptr + NA, Q);
        end
        if (z_vr) begin
            queue_rptr  <= f_wrap (queue_rptr + NZ, Q);
        end
        case ({a_vr, z_vr})
            2'b10:  queue_cnt   <= queue_cnt + NA;
            2'b01:  queue_cnt   <= queue_cnt - NZ;
            2'b11:  queue_cnt   <= queue_cnt + NA - NZ;
        endcase
    end
end

//------------------------------------------------------------------------------
//  local shift
//------------------------------------------------------------------------------
wire    a_busy    = queue_full;               // no z->a path
assign  o_a_r   = i_a_v && (!a_busy);

assign  o_z_v   = !queue_empty;
//  assign  o_z_d    = queue[Z-1:0];
genvar z;
generate
begin : g_z_byte
    for (z=0; z<NZ; z=z+1) begin : p_z_byte
        assign  o_z_d[z*N+N-1:z*N]    = queue[f_wrap(queue_rptr+z, Q)];
    end
end
endgenerate

//------------------------------------------------------------------------------
`ifdef  SIM

    //  initial begin
    //      $display ("NOTE:%m: (A(%1d),Z(%1d),Q(%1d),N(%1d),NA(%1d),NZ(%1d))",A,Z,Q,N,NA,NZ);
    //  end

    initial begin
        if ((A % N != 0) || (Z % N != 0)) begin
            $display ("ERROR:%m: (A,Z,N) = (%d,%d,%d), must be multiple of N", A, Z, N);
            $finish;
        end
        if (Q < NA || Q < NZ) begin
            $display ("ERROR:%m: (NA,NZ,Q) = (%d,%d,%d), Q must be bigger", NA, NZ, Q);
            $finish;
        end
    end

    always @(posedge clk)
        if (queue_cnt >= Q) begin
            $display ("ERROR:%m: queue_cnt(%d) >= Q(%d)", queue_cnt, Q);
            $finish;
        end

`ifdef  CORY_MON
    cory_monitor #(.N(Z)) u_monitor_z (
        .clk        (clk),
        .i_v        (o_z_v),
        .i_d        (o_z_d),
        .i_r        (i_z_r),
        .reset_n    (reset_n)
    );

`endif                                          //  CORY_MON
`endif                                          // SIM

//------------------------------------------------------------------------------
function integer f_log2;
    input   integer value;
    begin
		     if(value <= 2) f_log2= 1;
		else if(value <= 4) f_log2= 2;
		else if(value <= 8) f_log2= 3;
		else if(value <= 16) f_log2= 4;
		else if(value <= 32) f_log2= 5;
		else if(value <= 64) f_log2= 6;
		else if(value <= 128) f_log2= 7;
		else if(value <= 256) f_log2= 8;
		else if(value <= 512) f_log2= 9;
		else if(value <= 1024) f_log2= 10;
		else if(value <= 2048) f_log2= 11;
		else if(value <= 4096) f_log2= 12;
		else if(value <= 8192) f_log2= 13;
		else if(value <= 16384) f_log2= 14;
		else if(value <= 32768) f_log2= 15;
		else if(value <= 65536) f_log2= 16;
    end
endfunction

function [MQ-1:0] f_wrap;
    input   [MQ:0]  addr;
    input   [MQ:0]  size;
    begin
        if (addr >= size)
            f_wrap  = addr - size;
        else
            f_wrap  = addr;
    end
endfunction
endmodule

`endif
