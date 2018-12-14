//------------------------------------------------------------------------------
//  http://github.com/gulakim/cory
//  
//------------------------------------------------------------------------------
//  `ifndef CORY_FUNCTIONS
//      `define CORY_FUNCTIONS

//------------------------------------------------------------------------------
//  log2 function
//------------------------------------------------------------------------------
function integer cory_f_log2;
    input   integer value;
    begin
		     if(value <= 2)     cory_f_log2 = 1;
		else if(value <= 4)     cory_f_log2 = 2;
		else if(value <= 8)     cory_f_log2 = 3;
		else if(value <= 16)    cory_f_log2 = 4;
		else if(value <= 32)    cory_f_log2 = 5;
		else if(value <= 64)    cory_f_log2 = 6;
		else if(value <= 128)   cory_f_log2 = 7;
		else if(value <= 256)   cory_f_log2 = 8;
		else if(value <= 512)   cory_f_log2 = 9;
		else if(value <= 1024)  cory_f_log2 = 10;
		else if(value <= 2048)  cory_f_log2 = 11;
		else if(value <= 4096)  cory_f_log2 = 12;
		else if(value <= 8192)  cory_f_log2 = 13;
		else if(value <= 16384) cory_f_log2 = 14;
		else if(value <= 32768) cory_f_log2 = 15;
		else if(value <= 65536) cory_f_log2 = 16;
        else begin
            cory_f_log2 = 0;
`ifdef  SIM
            $display ("ERROR:%m: want log(%1d) ?, think over", value);
            $finish;
`endif  //  SIM
        end
    end
endfunction

//  `endif  // CORY_FUNCTIONS
