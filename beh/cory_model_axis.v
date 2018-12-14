//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
`ifndef CORY_MODEL_AXIS
    `define CORY_MODEL_AXIS

//------------------------------------------------------------------------------
module cory_model_axis #(
    parameter   A   = 32,
    parameter   D   = 64,
    parameter   L   = 4,
    parameter   V   = 0,                    // 0: no-initial, 1: random, 2: load from a file
    parameter   I   = 0,                    // initial value for random
    parameter   NUM_FRAME   = 4             // NUM_FRAME * 1920*1080*1.5
)(
    input           clk,
    output          o_busy,

    input           i_aw_v,
    input   [A-1:0] i_aw_a,
    input   [L-1:0] i_aw_l,
    output          o_aw_r,
    input           i_w_v,
    input   [D-1:0] i_w_d,
    input           i_w_l,
    output          o_w_r,
    output          o_b_v,
    input           i_b_r,
    input           i_ar_v,
    input   [A-1:0] i_ar_a,
    input   [L-1:0] i_ar_l,
    output          o_ar_r,
    output          o_r_v,
    output  [D-1:0] o_r_d,
    output          o_r_l,
    input           i_r_r,

    input           reset_n
);

//------------------------------------------------------------------------------
`ifdef  SIM
localparam  NUM_BYTE        = D/8;
localparam  MEM_SIZE        = (1920 * 1080 * 15/10/NUM_BYTE) * NUM_FRAME;
localparam  BYTE_ADDR       = f_log2(NUM_BYTE);
localparam  MEM_SIZE_BYTE   = MEM_SIZE * NUM_BYTE;

//------------------------------------------------------------------------------

integer         error;
initial         error = 0;

reg     [D-1:0] mem [0:MEM_SIZE-1];

reg             o_r_busy;
reg             o_w_busy;
assign  o_busy  = o_r_busy && o_w_busy;

always @ (posedge clk or negedge reset_n)
    if (~reset_n)
        o_r_busy  <= 1'b0;
    else if (o_r_v && i_r_r && o_r_l)
        o_r_busy  <= 1'b0;
    else if (i_ar_v && o_ar_r)
        o_r_busy  <= 1'b1;
        
assign  o_ar_r   = (i_ar_v && (~o_r_busy)) ? 1'b1 : 1'b0;

reg [L-1:0] r_cnt;

always @ (posedge clk or negedge reset_n)
    if (~reset_n)
        r_cnt    <= {L{1'b0}};
    else if (i_ar_v && o_ar_r)
        r_cnt    <= i_ar_l;
    else if (o_r_v && i_r_r)
        r_cnt    <= r_cnt - 1'b1;

reg w_r_v;

always @ (posedge clk or negedge reset_n)
    if (~reset_n)
        w_r_v    <= 1'b0;
    else if (i_ar_v & o_ar_r)
        w_r_v    <= 1'b1;
    else if (o_r_v & i_r_r && r_cnt == 0)
        w_r_v    <= 1'b0;

assign  o_r_v   = w_r_v;
assign  o_r_l   = (o_r_v && r_cnt == 0) ? 1'b1 : 1'b0;

reg     [A:0]   r_addr;

always @ (posedge clk or negedge reset_n)
    if (~reset_n)
        r_addr  <= {A{1'b0}};
    else if (i_ar_v & o_ar_r)
        r_addr  <= i_ar_a;
    else if (o_r_v && i_r_r)
        case (BYTE_ADDR)
        1:  r_addr  <= r_addr + 2;
        2:  r_addr  <= r_addr + 4;
        3:  r_addr  <= r_addr + 8;
        4:  r_addr  <= r_addr + 16;
        5:  r_addr  <= r_addr + 32;
        6:  r_addr  <= r_addr + 64;
        7:  r_addr  <= r_addr + 128;
        8:  r_addr  <= r_addr + 256;
        default:  r_addr  <= r_addr + {A{1'bx}};
        endcase

localparam  W   = A - BYTE_ADDR;        // word addr

wire    [W-1:0] r_addr_word = r_addr[A-1:BYTE_ADDR];
assign          o_r_d     = o_r_v ? mem[r_addr_word] : {D{1'bx}};

//------------------------------------------------------------------------------

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        o_w_busy    <= 1'b0;
    else if (i_w_v && o_w_r && i_w_l)
        o_w_busy    <= 1'b0;
    else if (i_aw_v && o_aw_r)
        o_w_busy    <= 1'b1;

assign  o_aw_r   = (i_aw_v && (!o_w_busy)) ? 1'b1 : 1'b0;

reg [L-1:0] w_cnt;

always @ (posedge clk or negedge reset_n)
    if (!reset_n)
        w_cnt   <= 0;
    else if (i_aw_v && o_aw_r)
        w_cnt   <= i_aw_l;
    else if (i_w_v && o_w_r)
        w_cnt   <= w_cnt - 1'b1;

assign  o_w_r    = o_w_busy & i_w_v;

reg [A-1:0] w_addr;

always @ (posedge clk or negedge reset_n)
    if (!reset_n)
        w_addr   <= {A{1'b0}};
    else if (i_aw_v && o_aw_r)
        w_addr   <= i_aw_a;
    else if (i_w_v && o_w_r)
        w_addr   <= w_addr + NUM_BYTE;

wire    [W-1:0] w_addr_word = w_addr[A-1:BYTE_ADDR];

//------------------------------------------------------------------------------
integer i;
reg     [D-1:0] seed;

reg     [256*8-1:0] filename;
integer file = 0;
integer b;
reg     [D-1:0] buff;
reg     [7:0]   buff_byte[0:NUM_BYTE-1];
integer ch;

initial begin
    //  $display ("reading from 'avatar.yuv.hex'");
    //  $readmemh ("avatar.yuv.hex", mem);

    //  $display ("reading from 'park.rgb.hex'");
    //  $readmemh ("park.rgb.hex", mem);

    if (V==2) begin
        $sformat (filename, "%m.bin");
        file    = $fopen (filename, "rb");
        if (file)
            $display ("NOTE:%m: reading from '%s'", filename);
        else begin
            $display ("ERROR:%m: cannot read from '%s'", filename);
            $finish;
        end
        for (i=0; i<MEM_SIZE; i=i+1) begin
            for (b=0; b<NUM_BYTE; b=b+1) begin
                ch = $fgetc(file);
                if (ch == -1) begin
                    b   = 9;
                    i   = MEM_SIZE;
                end
                else begin
                    buff_byte[b]    = ch[7:0];
                end
            end
            //  for (b=0; b<NUM_BYTE; b=b+1) begin
            //      buff[b*8+7:b*8] = buff_byte[b];
            //  end
            mem[i]  = {buff_byte[7], buff_byte[6], buff_byte[5], buff_byte[4],
                       buff_byte[3], buff_byte[2], buff_byte[1], buff_byte[0]};
        end
    end
    else if (V==1) begin
        $display ("NOTE:%m: initializing with random value to the memory");
        seed    = I;
        for (i=0; i<MEM_SIZE; i=i+1) begin
            mem[i]  = seed;
            seed    = seed * 21 + 1;
        end
    end
end


always @(posedge clk or negedge reset_n)
    if (i_w_v && o_w_r)
        mem[w_addr_word] = i_w_d;

//  wire    [63:0]  mem0    = mem[0];
//  wire    [63:0]  mem1    = mem[1];
//  wire    [63:0]  mem2    = mem[2];
//  wire    [63:0]  mem3    = mem[3];
//  wire    [63:0]  mem4    = mem[4];
//  wire    [63:0]  mem5    = mem[5];
//  wire    [63:0]  mem6    = mem[6];
//  wire    [63:0]  mem7    = mem[7];
//  wire    [63:0]  mem8    = mem[8];
//  wire    [63:0]  mem9    = mem[9];

reg w_b_v;

always @(posedge clk or negedge reset_n)
    if (!reset_n)
        w_b_v    <= 1'b0;
    else if (i_w_v && o_w_r && i_w_l)
        w_b_v    <= 1'b1;
    else if (o_b_v && i_b_r)
        w_b_v    <= 1'b0;

assign  o_b_v    = w_b_v;

//------------------------------------------------------------------------------

always @(posedge clk) begin
    if (i_ar_v) begin
        if (&i_ar_a === 1'bx) begin
            $display ("ERROR:%m: ar_a unknown %d @ %t", i_ar_a, $time);
            error = error + 1;
        end
        if (i_ar_a > MEM_SIZE_BYTE) begin
            $display ("ERROR:%m: ar_a out of the range %d > %d @ %t", i_ar_a, MEM_SIZE_BYTE, $time);
            error = error + 1;
        end
    end
    if (i_aw_v) begin
        if (&i_aw_a === 1'bx) begin
            $display ("ERROR:%m: aw_a unknown %d @ %t", i_aw_a, $time);
            error = error + 1;
        end
        if (i_aw_a > MEM_SIZE_BYTE) begin
            $display ("ERROR:%m: aw_a out of the range %d > %d @ %t", i_aw_a, MEM_SIZE_BYTE, $time);
            error = error + 1;
        end
    end
    if (o_r_v) begin
        if (&o_r_d === 1'bx) begin
            $display ("ERROR:%m: r_d unknown %d @ %t", o_r_d, $time);
            error = error + 1;
        end
    end
    if (i_w_v) begin
        if (&i_w_d === 1'bx) begin
            $display ("ERROR:%m: w_d unknown %d @ %t", i_w_d, $time);
            error = error + 1;
        end
    end
    if (error > 10) begin
        $display ("ERROR:%m: too many error %d @ %t", error, $time);
        $finish;
    end
end

//------------------------------------------------------------------------------
task write_mem;
    input   [256*8-1:0] filename;
    input   integer     size;
    integer file;
    integer i, b;
    reg     [D-1:0] data;
    reg     [7:0]   byte_data[0:NUM_BYTE-1];
begin
    file    = $fopen (filename, "wb");
    if (file == -1) begin
        $display ("ERROR:%m: cannot write to '%s' @ %t", filename, $time);
        $finish;
    end
    for (i=0; i<size/NUM_BYTE; i=i+1) begin
        data    =  mem[i];
        {byte_data[7], byte_data[6], byte_data[5], byte_data[4],
         byte_data[3], byte_data[2], byte_data[1], byte_data[0]} = data;
        for (b=0; b<NUM_BYTE; b=b+1) begin
            //  byte_data[b]    = data[b*8+7:b*8];
            $fwrite (file, "%c", byte_data[b]);
        end
    end
    $display ("NOTE:%m:'%s' created with %d bytes @ %t", filename, size, $time);
end
endtask

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

`endif  //  SIM
endmodule
`endif  // CORY_MODEL_AXIS
