//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_MODEL_SPRAM
    `define CORY_MODEL_SPRAM

//------------------------------------------------------------------------------
module cory_model_spram #(
    parameter   A       = 8,
    parameter   D       = 8,
    parameter   SIZE    = 2**A
) (
    input           clk,
    input           csn,
    input           wen,
    input           oen,
    input   [A-1:0] addr,
    input   [D-1:0] wdata,
    output  [D-1:0] rdata
);

`ifdef  SIM

localparam  I   = 0;
//------------------------------------------------------------------------------
reg    [D-1: 0] rdata_p;

reg    [D-1: 0] mem [0:SIZE-1];

integer i;
integer error   = 0;
integer warning = 0;

integer seed;
initial begin
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
// Include initialization process for debug only....
always @(posedge clk)// or negedge reset_n)
begin
    if(csn == 1'b0 && wen == 1'b0)
    begin
        if(addr >= SIZE) begin
            $display("ERROR:%m: Write address range overflow @ %t", $time);
            error = error + 1;
        end
        else
            mem[addr] <= wdata;
        if (&addr === 1'bx) begin
            $display("ERROR:%m: Write address unknown (%x) @ %t", addr, $time);
            error = error + 1;
        end
        if (&wdata === 1'bx) begin
            $display("ERROR:%m: Write data unknown (%x) address (%x) @ %t", wdata, addr, $time);
            error = error + 1;
        end
    end
end

//------------------------------------------------------------------------------
// Read
always @(posedge clk)
begin
    if(csn == 1'b0 && wen == 1'b1)
    begin
        if(addr >= SIZE) begin
            $display("ERROR:%m: Read address range overflow @ %t", $time);
            error = error + 1;
        end
        else
            rdata_p <= mem[addr];
    end
end

assign  rdata   = (oen == 1'b0) ? rdata_p : {D{1'bx}};

//------------------------------------------------------------------------------
always @(posedge clk) begin
    if (error > 100) begin
        $display("ERROR:%m: too many errors %d @ %t", error, $time);
        $finish;
    end
    if ((oen == 1'b0) && (&rdata_p === 1'bx)) begin
            $display("WARNING:%m: Read data unknown (%x) address (%x) @ %t", rdata_p, addr, $time);
            warning = warning + 1;
    end
end

//------------------------------------------------------------------------------
initial begin
    if (SIZE > 2**A) begin
        $display ("ERROR:%m: 2^A(%1d) < SIZE(%1d)", A, SIZE);
        $finish;
    end

    $display ("WARNING:%m: using simulation model, you must replace with physical single-port memory");

end

`endif  //  SIM
endmodule
       
`endif  // CORY_MODEL_SPRAM
