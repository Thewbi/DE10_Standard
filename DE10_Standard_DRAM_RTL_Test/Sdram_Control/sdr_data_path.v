// What does this module do?
module sdr_data_path(

    // input
    CLK,
    RESET_N,
    DATAIN,
    DM,
    
    // output
    DQOUT,
    DQM         // DQM = 

);

`include        "Sdram_Params.h"

    //
    // input
    //

    input                           CLK;                    // System Clock
    input                           RESET_N;                // System Reset
    input   [`DSIZE-1:0]            DATAIN;                 // Data input from the host
    input   [`DSIZE/8-1:0]          DM;                     // byte data masks
    
    //
    // output
    //
    
    output  [`DSIZE-1:0]            DQOUT;
    output  [`DSIZE/8-1:0]          DQM;                    // SDRAM data mask ouputs
    
    //
    // internal
    // 
    
    reg     [`DSIZE/8-1:0]          DQM;                    // same name as the output DQM! SDRAM DataMask

    // Allign the input and output data to the SDRAM control path
    always @(posedge CLK or negedge RESET_N)
    begin
        if (RESET_N == 0) 
            DQM     <= `DSIZE/8-1'hF;
        else
            DQM     <=  DM;                 
    end

    assign DQOUT = DATAIN;

endmodule
