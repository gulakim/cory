//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_MODEL_SPROM
    `define CORY_MODEL_SPROM

    `ifndef CORY_FILENAME
        `define CORY_FILENAME   64
    `endif
    `ifndef CORY_STIM_DIR
        `define CORY_STIM_DIR   "."
    `endif

//------------------------------------------------------------------------------
module cory_model_sprom #(
    parameter   A       = 8,
    parameter   D       = 8,
    parameter   SIZE    = 2**A
) (
    input           clk,
    input           csn,
    input   [A-1:0] addr,
    output  [D-1:0] rdata
);

`ifdef  SIM

localparam  I   = 0;
//------------------------------------------------------------------------------
reg    [D-1: 0] rdata_p;

reg    [D-1: 0] mem [0:SIZE-1];

reg     [`CORY_FILENAME*8-1:0]  filename;

initial begin
    $sformat (filename, "%s/%m.rom", `CORY_STIM_DIR);    
    $readmemh (filename, mem);
    $display ("NOTE:%m: reading initial value from '%s'", filename);
end

//------------------------------------------------------------------------------
integer error   = 0;

always @(posedge clk)
begin
    if(csn == 1'b0)
    begin
        if(addr >= SIZE) begin
            $display("WARNING:%m: Read address range overflow @ %t", $time);
            error = error + 1;
        end
        else
            rdata_p <= mem[addr];
    end
end

assign  rdata   = rdata_p;

//------------------------------------------------------------------------------
always @(posedge clk) begin
    if (error > 100) begin
        $display("ERROR:%m: too many errors %d @ %t", error, $time);
        $finish;
    end
    if (&rdata_p === 1'bx) begin
            $display("WARNING:%m: Read data unknown (%x) address (%x) @ %t", rdata_p, addr, $time);
            error = error + 1;
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
       
`endif  // CORY_MODEL_SPROM
