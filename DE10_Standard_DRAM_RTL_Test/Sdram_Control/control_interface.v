// This module is instantiated inside Sdram_Control.v
//
// This module goes through the SDRAM initialization process after power on.
// It produces the signals for commands to execute based on the step within the 
// initialization process but it does not execute the commands itself instead
// it only produces mathing outputs for other modules to pick up and execute the commands.
// The external module that really talks to the SDRAM chip and executes the commands is
// command.v (see Sdram_Control.v)
//
// After the initialization process, this module takes in abstract high level commands in CMD
// and translates them to NOP, READA and WRITEA commands signals so that other external
// modules can execute those commands.
//
// I think this module also manages timers for normal commands (NOP, READA and WRITEA)
module control_interface(

    //
    // inputs
    //

    CLK,        // clock
    RESET_N,    // reset signal
    CMD,        // the abstract, high-level command to execute (Command 01 == READA command, Command 10 == WRITEA command, Command 00 == NOP command)
    ADDR,       // this value is copied into SADDR so it can be kept internally 
    REF_ACK,
    INIT_ACK,
    CM_ACK,

    //
    // outputs
    //

    // commands
    NOP,        // a command that can be requested during normal operation via the CMD input
    READA,      // a command that can be requested during normal operation via the CMD input
    WRITEA,     // a command that can be requested during normal operation via the CMD input
    REFRESH,    // important during the SDRAM initialization process
    PRECHARGE,  // important during the SDRAM initialization process
    LOAD_MODE,  // important during the SDRAM initialization process

    SADDR,      // receives and stores the value of the ADDR input
    REF_REQ,
    INIT_REQ,
    CMD_ACK

);

`include        "Sdram_Params.h"

    //
    // Inputs
    //

    input                           CLK;                    // System Clock
    input                           RESET_N;                // System Reset
    input   [2:0]                   CMD;                    // Command input
    input   [`ASIZE-1:0]            ADDR;                   // Address
    input                           REF_ACK;                // Refresh request acknowledge
    input                           INIT_ACK;               // Initial request acknowledge
    input                           CM_ACK;                 // Command acknowledge

    //
    // Outputs
    //

    // command outputs
    output                          NOP;                    // Decoded NOP command
    output                          READA;                  // Decoded READA command
    output                          WRITEA;                 // Decoded WRITEA command
    output                          REFRESH;                // Decoded REFRESH command
    output                          PRECHARGE;              // Decoded PRECHARGE command
    output                          LOAD_MODE;              // Decoded LOAD_MODE command
    
    output  [`ASIZE-1:0]            SADDR;                  // Registered version of ADDR
    output                          REF_REQ;                // Hidden refresh request
    output                          INIT_REQ;               // Hidden initial request
    output                          CMD_ACK;                // Command acknowledge

    reg                             NOP;
    reg                             READA;
    reg                             WRITEA;
    reg                             REFRESH;
    reg                             PRECHARGE;
    reg                             LOAD_MODE;
    reg     [`ASIZE-1:0]            SADDR;
    reg                             REF_REQ;
    reg                             INIT_REQ;
    reg                             CMD_ACK;

    // Internal signals
    reg     [15:0]                  timer;
    reg     [15:0]                  init_timer;



    // Command decode and ADDR register
    always @(posedge CLK or negedge RESET_N)
    begin
        if (RESET_N == 0) 
            begin
                NOP             <= 0;
                READA           <= 0;
                WRITEA          <= 0;
                SADDR           <= 0;
            end
        else
            begin

                // register the address to keep proper
                // alignment with the command
                SADDR <= ADDR;

                // NOP command
                if (CMD == 3'b000)
                    NOP <= 1;
                else
                    NOP <= 0;
                
                // READA command
                if (CMD == 3'b001)
                    READA <= 1;
                else
                    READA <= 0;

                // WRITEA command
                if (CMD == 3'b010)
                    WRITEA <= 1;
                else
                    WRITEA <= 0;
                        
            end
    end

    // Generate CMD_ACK
    always @(posedge CLK or negedge RESET_N)
    begin
        if (RESET_N == 0)
            CMD_ACK <= 0;
        else
            if ((CM_ACK == 1) & (CMD_ACK == 0))
                CMD_ACK <= 1;
            else
                CMD_ACK <= 0;
    end

    // refresh timer
    //
    // This constantly sends refresh commands to keep the memory powered
    always @(posedge CLK or negedge RESET_N) 
    begin

        if (RESET_N == 0) 
            begin
                timer           <= 0;
                REF_REQ         <= 0;
            end        
        else 
            begin
            
                // REF_ACK (= Refresh request acknowledge)
                if (REF_ACK == 1)
                    begin
                        timer <= REF_PER;
                        REF_REQ <= 0;
                    end
                else
                // INIT_REQ (= Hidden initial request)
                if (INIT_REQ == 1)
                    begin
                        timer <= REF_PER + 200;
                        REF_REQ <= 0;
                    end
                else
                    timer <= timer - 1'b1;

                if (timer == 0)
                    REF_REQ <= 1;
            end

    end

    // initial timer
    // 
    // INIT_PER (INITialization PERiod) is a parameter defined inside Sdram_Params.h
    // 
    // INIT_PER is set to 24000 for 100Mhz in Sdram_Params.h
    // The code below works as follow. 
    // The init_timer variable is incremented from 0 to INIT_PER + 201
    //
    // After the initialization process, the SDRAM is ready for reading and writing
    always @(posedge CLK or negedge RESET_N) begin
        if (RESET_N == 0) 
            begin
                init_timer      <= 0;
                REFRESH         <= 0;
                PRECHARGE       <= 0; 
                LOAD_MODE       <= 0;
                INIT_REQ        <= 0;
            end
        else 
            begin

                // INIT_PER (INITialization PERiod) is a parameter defined inside Sdram_Params.h
                // the init_timer is increment from 0 to INIT_PER + 201, the it stops
                if (init_timer < (INIT_PER + 201)) 
                    init_timer <= init_timer + 1;                    

                // init_timer within [0, INIT_PER] => execute the INIT_REQ command
                if (init_timer < INIT_PER)
                    begin
                        REFRESH     <= 0;
                        PRECHARGE   <= 0;
                        LOAD_MODE   <= 0;
                        INIT_REQ    <= 1; // there really is no init command defined for SDRAM so this actually triggers ???
                    end

                // init_timer within [INIT_PER, INIT_PER + 20] => execute precharge
                else if (init_timer == (INIT_PER + 20))
                    begin
                        REFRESH     <= 0;
                        PRECHARGE   <= 1; // precharge command
                        LOAD_MODE   <= 0;
                        INIT_REQ    <= 0;
                    end

                // init_timer within [INIT_PER + 20, INIT_PER + 180]
                // init_timer takes on exact values INIT_PER + 40, 60, 80, 100, 120, 140, 160, 180 => refresh
                else if ((init_timer == (INIT_PER + 40))    ||
                         (init_timer == (INIT_PER + 60))    ||
                         (init_timer == (INIT_PER + 80))    ||
                         (init_timer == (INIT_PER + 100))   ||
                         (init_timer == (INIT_PER + 120))   ||
                         (init_timer == (INIT_PER + 140))   ||
                         (init_timer == (INIT_PER + 160))   ||
                         (init_timer == (INIT_PER + 180)))
                    begin
                        REFRESH     <= 1; // refresh command
                        PRECHARGE   <= 0;
                        LOAD_MODE   <= 0;
                        INIT_REQ    <= 0;
                    end

                // init_timer takes on exact values INIT_PER + 200 => Start LOAD
                else if (init_timer == (INIT_PER + 200))
                    begin
                        REFRESH     <= 0;
                        PRECHARGE   <= 0;
                        LOAD_MODE   <= 1; // start the load mode command (Mode Write: S=00, RAS=0, CAS=0, WE=0)
                        INIT_REQ    <= 0;
                    end
                else
                    begin
                        REFRESH     <= 0;
                        PRECHARGE   <= 0;
                        LOAD_MODE   <= 0;
                        INIT_REQ    <= 0;
                    end
            end
    end

endmodule

