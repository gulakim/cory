//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------

`ifndef CORY_MONITOR
    `define CORY_MONITOR

    `ifndef CORY_FILENAME
        `define CORY_FILENAME  64
    `endif
    `ifndef CORY_DUMP_DIR
        `define CORY_DUMP_DIR   "dump"
    `endif

    `ifdef  CORY_MON
        `define CORY_MON_STAT
        `define CORY_MON_DUMP
    `endif

//------------------------------------------------------------------------------
//  monitor
//------------------------------------------------------------------------------

module cory_monitor # (
    parameter   N   = 64,
    parameter   V   = 0                         // 0: monitir only 2: mon+dump
) (
    input           clk,
    input           i_v,
    input   [N-1:0] i_d,
    input           i_r,
    input           reset_n
);

localparam  MAX_ERROR   = 10;
localparam  MAX_WARNING = 10;
localparam  MAX_LATENCY = 100;

`ifdef  SIM
`ifdef  CORY_MON
    integer n_error = 0;
    integer n_warning   = 0;

    reg     [N-1:0]  i_d_1d;

    always @(posedge clk or negedge reset_n)
        if (!reset_n)
            i_d_1d   <= 0;
        else if (i_v & !i_r)
            i_d_1d   <= i_d;

    reg             i_v_1d;
    always @(posedge clk or negedge reset_n)
        if (!reset_n)
            i_v_1d  <= 0;
        else if (i_v & !i_r)
            i_v_1d  <= 1;
        else
            i_v_1d  <= 0;

    always @(posedge clk or negedge reset_n) begin
        if (reset_n) begin
//------------------------------------------------------------------------------
//  valid shall not go unknown
//------------------------------------------------------------------------------
            if (i_v === 1'bx || i_v === 1'bz) begin
                n_error <= n_error + 1;
                $display ("ERROR:%m: valid = %x, data = %x, ready = %x @ %t", i_v, i_d, i_r, $time);
            end
//------------------------------------------------------------------------------
//  ready shall not go unknown when valid
//------------------------------------------------------------------------------
            if (i_v & (
                (i_r    === 1'bx || i_r === 1'bz))) begin
                n_error <= n_error + 1;
                $display ("ERROR:%m: valid = %x, data = %x, ready = %x @ %t", i_v, i_d, i_r, $time);
            end
            if (i_v & (
                (&i_d    === 1'bx || &i_d === 1'bz))) begin
                n_warning   <= n_warning + 1;
                $display ("WARNING:%m: valid = %x, data = %x, ready = %x @ %t", i_v, i_d, i_r, $time);
            end
//------------------------------------------------------------------------------
//  ready should not be 1 when not valid
//      ease timing view
//------------------------------------------------------------------------------
    `ifdef  CORY_EASY_WAVE
            if (i_v == 0 && i_r == 1) begin
                n_warning <= n_warning + 1;
                $display ("WARNING:%m: ready when no valid is not allowed, ready = %x, valid = %x @ %t", i_r, i_v, $time);
            end
    `endif  //  CORY_EASY_WAVE
//------------------------------------------------------------------------------
//  data shall not change during valid and not ready
//      data stability, exceptions for sram access & stack operation
//------------------------------------------------------------------------------
            if (i_v & i_v_1d & (i_d != i_d_1d)) begin
                n_error <= n_error + 1;
                $display ("ERROR:%m: data chaning during valid, prev data = %x, data = %x @ %t", i_d_1d, i_d, $time);
            end
        end
    end

//------------------------------------------------------------------------------
//  clk and reset_n must be stable, no need to mention
//------------------------------------------------------------------------------
//      always @(*)
//          if ((clk & reset_n) === 1'bx) begin
//              $display ("ERROR:%m: clk = %1x, reset_n = %1x, not supported @ %t", clk, reset_n, $time);
//              $finish;
//          end

//------------------------------------------------------------------------------
//  error/warning
//------------------------------------------------------------------------------

    always @(*) begin
        if (n_warning > MAX_WARNING) begin
            //  n_error <= n_error + 1;
            //  n_warning   <= 0;
            $display ("ERROR:%m: too many warnings (%1d) @ %t", n_warning, $time);
        end
        if (n_error > MAX_ERROR) begin
            $display ("ERROR:%m: too many errors (%1d) @ %t", n_error, $time);
            $finish;
        end
    end

`ifdef  CORY_MON_STAT
//------------------------------------------------------------------------------
//  statistics
//------------------------------------------------------------------------------
    integer stat_cycle;
    integer stat_cycle_v;
    integer stat_cycle_vr;
    integer stat_latency_max;
    integer stat_latency;
    real    stat_latency_average;
    integer stat_latency_count;

    always @(posedge clk or negedge reset_n)
        if (!reset_n) begin
            stat_cycle          <= 0;
            stat_cycle_v        <= 0;
            stat_cycle_vr       <= 0;
            stat_latency_max    <= 0;
            stat_latency        <= 0;
            stat_latency_count  <= 0;
            stat_latency_average<= 0;
        end
        else begin
            stat_cycle  <= stat_cycle + 1;

            if (i_v)            stat_cycle_v        <= stat_cycle_v + 1;
            if (i_v && i_r)     stat_cycle_vr       <= stat_cycle_vr + 1;

            if (i_v && i_r)     stat_latency        <= 0;
            if (i_v && !i_r)    stat_latency        <= stat_latency + 1;

            if (stat_latency > stat_latency_max)  
                                stat_latency_max    <= stat_latency;

            if (i_v && i_r) begin
                stat_latency_average    <= (stat_latency_count * stat_latency_average + stat_latency)/(stat_latency_count + 1);
                stat_latency_count        <= stat_latency_count + 1;
            end
        end

    real    stat_percentage_ready;
    real    stat_percentage_util;

    always @(*) begin
        stat_percentage_ready   <= stat_cycle_v ? 100.0 * stat_cycle_vr / stat_cycle_v : 0;
        stat_percentage_util    <= stat_cycle ? 100.0 * stat_cycle_vr / stat_cycle : 0;
    end

//------------------------------------------------------------------------------
//  built-in tasks
//------------------------------------------------------------------------------
task t_init;
begin
    #1;
    stat_cycle          = 0;
    stat_cycle_v        = 0;
    stat_cycle_vr       = 0;
    stat_latency_max    = 0;
    stat_latency        = 0;
    stat_latency_count  = 0;
    stat_latency_average= 0;
    $display ("NOTE:%m://------------------------------------------------------------------------------");
    $display ("NOTE:%m:// restart calculation @ %t", $time);
end
endtask

task t_report;
begin
    $display ("NOTE:%m://------------------------------------------------------------------------------");
    $display ("NOTE:%m:// percentage of data utilization  = %2.1f @ %t", stat_percentage_util, $time);
    $display ("NOTE:%m:// percentage of ready for valid   = %2.1f @ %t", stat_percentage_ready, $time);
    $display ("NOTE:%m:// average latency                 = %2.1f @ %t", stat_latency_average, $time);
    $display ("NOTE:%m:// maximum latency                 = %2.1f @ %t", stat_latency_max, $time);
    t_analyze;
    t_init;
end
endtask

task t_analyze;
begin
    if (stat_percentage_util < 50.0) begin
        $display ("WARNING:%m: data utilization is lower than 50 percent, check if there is an error in the architecture");
        n_warning   <= n_warning + 1;
    end
    if (stat_percentage_ready < 50.0)
        $display ("WARNING:%m: data through-put is lower than 50 percent, check if there is an error in the architecture");
        n_warning   <= n_warning + 1;
    if (stat_latency_max > MAX_LATENCY)
        $display ("WARNING:%m: maximum latency is more than %1d, check if there is an error in the architecture", MAX_LATENCY);
        n_warning   <= n_warning + 1;
end
endtask

`endif                                          //  CORY_MON_STAT

`ifdef  CORY_MON_DUMP
//------------------------------------------------------------------------------
//  dump to a file
//------------------------------------------------------------------------------
    reg     [`CORY_FILENAME*8-1:0]   filename;
    integer file     = 0;

    initial begin
        if (V == 2) begin
            $sformat (filename, "%s/%m.bin", `CORY_DUMP_DIR);
            file    = $fopen (filename, "wb");
            if (file)
                $display ("NOTE:%m: opening '%s' for write", filename);
            else begin
                $display ("ERROR:%m: cannot write to %s", filename);
                $finish;
            end
        end
    end

    localparam  NUMBYTE    = N / 8;
    wire    [7:0]   d_byte[0:NUMBYTE-1];

    genvar j;
    generate
        for (j=0; j<NUMBYTE; j=j+1)
            assign d_byte[j] = i_d[j*8+:8];
    endgenerate

    always @(posedge clk) begin : p_fputc
        integer i;
        if ((V == 2) & i_v & i_r) begin
            for (i=0; i<NUMBYTE; i=i+1) begin
                t_fputc (file, d_byte[i]);
            end
        end
    end

    task t_fputc;
        input integer file;
        input [7:0] data;
    begin
        $fwrite (file, "%c", data);
    end
    endtask

    initial
        if ((V == 2) & ((N / 8) * 8) != N) begin
            $display ("ERROR:%m: N = %d does not support dump to file", N);
            $finish;
        end
`endif                                          //  CORY_MON_DUMP
`endif                                          //  CORY_MON
`endif                                          //  SIM

endmodule

`endif                                          //  CORY_MONITOR
