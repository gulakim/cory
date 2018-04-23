//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_DELAY
    `define CORY_DELAY

//------------------------------------------------------------------------------
//  N cycle delay
//------------------------------------------------------------------------------
module cory_delay #(
    parameter   N   = 8,
    parameter   D   = 1
) (
    input           clk,
    input   [N-1:0] i_a,
    output  [N-1:0] o_z,
    input           reset_n
);

reg     [N-1:0] delay[0:D-1];

always @(posedge clk or negedge reset_n) begin : p_delay
    integer i;
    if (!reset_n)
        for (i=0; i<D; i=i+1)
            delay[i]    <= {N{1'b0}};
    else begin
        for (i=D-1; i>0; i=i-1)
            delay[i]    <= delay[i-1];
        delay[0]    <= i_a;
    end
end

assign  o_z     = D == 0 ? i_a : delay[D-1];

//  `ifdef SIM
//      initial
//          if (D < 1) begin
//              $display ("ERROR:%m:D = %d not supported", D);
//              $finish;
//          end
//  `endif

endmodule

`endif
