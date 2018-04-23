//------------------------------------------------------------------------------
//  http://cafe.naver.com/corilog
//  http://cory.blog.com
//------------------------------------------------------------------------------
`ifndef CORY_MODEL_TPRAM
    `define CORY_MODEL_TPRAM

//------------------------------------------------------------------------------
module cory_model_tpram #(
    parameter   A       = 8,
    parameter   D       = 8,
    parameter   SIZE    = 2**A
) (
    input           wclk,
    input           wen,
    input   [A-1:0] waddr,
    input   [D-1:0] wdata,
    input           rclk,
    input           ren,
    input   [A-1:0] raddr,
    output  [D-1:0] rdata
);

`ifdef SIM

localparam  I   = 0;
//------------------------------------------------------------------------------
reg    [D-1: 0] rdata_p;

reg    [D-1: 0] mem [0:SIZE-1];

integer i;
integer error   = 0;
integer warning = 0;


integer seed;
initial begin : init
    integer i;
    if (I==1) begin
        for (i=0; i<SIZE; i=i+1)
            mem[i]  <= i;
    end
    else if (I==2) begin
        seed    = 0;
        for (i=0; i<SIZE; i=i+1) begin
            seed    <= seed * 21 + 1;
            mem[i]  <= seed;
        end
    end
end

//------------------------------------------------------------------------------
// Write
always @(posedge wclk)// or negedge reset_n)
begin
    if(wen == 1'b0)
    begin
        if(waddr >= SIZE) begin
            $display("ERROR:%m: Write address range overflow @ %t", $time);
            error = error + 1;
        end
        else
            mem[waddr] <= wdata;
        if (&waddr === 1'bx) begin
            $display("ERROR:%m: Write address unknown (%x) @ %t", waddr, $time);
            error = error + 1;
        end
        if (&wdata === 1'bx) begin
            $display("ERROR:%m: Write data unknown (%x) address (%x) @ %t", wdata, waddr, $time);
            error = error + 1;
        end
    end
end

//------------------------------------------------------------------------------
// Read
always @(posedge rclk)
begin
    if(ren == 1'b0)
    begin
        if(raddr >= SIZE) begin
            $display("ERROR:%m: Read address range overflow @ %t", $time);
            error = error + 1;
        end
        else
            rdata_p <= mem[raddr];
    end
end

assign  rdata   = rdata_p;

//------------------------------------------------------------------------------
reg     ren_1d;

always @(posedge rclk)
    ren_1d  <= ren;

always @(posedge rclk) begin
    if (error > 100) begin
        $display("ERROR:%m: too many errors %d @ %t", error, $time);
        $finish;
    end
    if (ren_1d == 0 && (&rdata === 1'bx)) begin
        $display("WARNING:%m: Read data unknown (%x) address (%x) @ %t", rdata, raddr, $time);
        warning = warning + 1;
    end
end

//------------------------------------------------------------------------------
initial begin
    if (SIZE > 2**A) begin
        $display ("ERROR:%m: 2^A(%1d) < SIZE(%1d)", A, SIZE);
        $finish;
    end

    $display ("WARNING:%m: using simulation model, you must replace with physical two-port memory");

end
`endif  // SIM
endmodule
`endif  // CORY_MODEL_TPRAM
       
