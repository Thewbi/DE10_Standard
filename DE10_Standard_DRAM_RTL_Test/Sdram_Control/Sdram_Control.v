// this module combines the logic that selects abstract commands
// and the logic that translates the abstract commands to concrete signals for the SDRAM chip
//
// It is instantiated in de10_standard_dram_rtl_test.v
module Sdram_Control(

    // HOST Side
    REF_CLK,
    RESET_N,
    CLK,
    
    // FIFO Write Side 
    WR_DATA,            // WR_DATA
    WR,                 // WR = Write Request, this signal is put into Sdram_WR_FIFO
    WR_ADDR,
    WR_MAX_ADDR,
    WR_LENGTH,
    WR_LOAD,
    WR_CLK,
    WR_FULL,
    WR_USE,
    
    // FIFO Read Side 
    RD_DATA,
    RD,                 // RD = Read Request, this signal is put into Sdram_RD_FIFO
    RD_ADDR,
    RD_MAX_ADDR,
    RD_LENGTH,
    RD_LOAD,
    RD_CLK,
    RD_EMPTY,
    RD_USE,
    
    // SDRAM Side
    SA,         // [output] SDRAM address output            - Connected to the physical DRAM_ADDR pins on the SDRAM (see de10_standard_dram_rtl_test.v)
    BA,         // [output] SDRAM bank address              - Connected to the physical DRAM_BA pins on the SDRAM
    CS_N,       // [output] SDRAM Chip Selects              - Connected to the physical DRAM_CS_N pins on the SDRAM
    CKE,        // [output] SDRAM clock enable              - Connected to the physical DRAM_CKE
    RAS_N,      // [output] SDRAM Row address Strobe        - Connected to the physical SDRAM Row address Strobe
    CAS_N,      // [output] SDRAM Column address Strobe     - Connected to the physical SDRAM Column address Strobe
    WE_N,       // [output] SDRAM write enable              - Connected to the physical DRAM_WE_N
    DQ,         // [input]  SDRAM data bus                  - Connected to the physical DRAM_DQ
    DQM,        // [output] SDRAM data mask lines           - Connected to the physical {DRAM_UDQM, DRAM_LDQM}
    SDR_CLK     // [output] SDRAM clock                     - Connected to the physical DRAM_CLK
);

    `include        "Sdram_Params.h"

    // HOST Side
    input                               REF_CLK;            // System Clock
    input                               RESET_N;            // System Reset

    // FIFO Write Side 1
    input       [`DSIZE-1:0]            WR_DATA;            // Data input
    input                               WR;                 // Write Request
    input       [`ASIZE-1:0]            WR_ADDR;            // Write start address
    input       [`ASIZE-1:0]            WR_MAX_ADDR;        // Write max address
    input       [8:0]                   WR_LENGTH;          // Write length
    input                               WR_LOAD;            // Write register load & fifo clear
    input                               WR_CLK;             // Write fifo clock
    output                              WR_FULL;            // Write fifo full
    output      [15:0]                  WR_USE;             // Write fifo usedw

    // FIFO Read Side 1
    output      [`DSIZE-1:0]            RD_DATA;            // Data output
    input                               RD;                 // Read Request
    input       [`ASIZE-1:0]            RD_ADDR;            // Read start address
    input       [`ASIZE-1:0]            RD_MAX_ADDR;        // Read max address
    input       [8:0]                   RD_LENGTH;          // Read length
    input                               RD_LOAD;            // Read register load & fifo clear
    input                               RD_CLK;             // Read fifo clock
    output                              RD_EMPTY;           // Read fifo empty
    output      [15:0]                  RD_USE;             // Read fifo usedw

    // SDRAM Side
    output      [`SASIZE-1:0]           SA;                 // SDRAM address output
    output      [1:0]                   BA;                 // SDRAM bank address
    output      [1:0]                   CS_N;               // SDRAM Chip Selects
    output                              CKE;                // SDRAM clock enable
    output                              RAS_N;              // SDRAM Row address Strobe
    output                              CAS_N;              // SDRAM Column address Strobe
    output                              WE_N;               // SDRAM write enable
    inout       [`DSIZE-1:0]            DQ;                 // SDRAM data bus, 16 bit databus for read or write (Therefore inout)
    output      [`DSIZE/8-1:0]          DQM;                // SDRAM data mask lines
    output                              SDR_CLK;            // SDRAM clock

    //
    // Internal Registers/Wires
    //
    
    // Controller
    reg         [`ASIZE-1:0]            mADDR;              // Internal address
    reg         [8:0]                   mLENGTH;            // Internal length
    reg         [`ASIZE-1:0]            rWR_ADDR;           // Register write address
    reg         [`ASIZE-1:0]            rRD_ADDR;           // Register read address
    reg                                 WR_MASK;            // Write port active mask
    reg                                 RD_MASK;            // Read port active mask
    reg                                 mWR_DONE;           // Flag write done, 1 pulse SDR_CLK
    reg                                 mRD_DONE;           // Flag read done, 1 pulse SDR_CLK
    reg                                 mWR, Pre_WR;        // Internal WR edge capture
    reg                                 mRD, Pre_RD;        // Internal RD edge capture
    reg         [9:0]                   ST;                 // Controller status
    reg         [1:0]                   CMD;                // Controller command (This internal flag is passed into the control_interface instance!)
    // page mode
    reg                                 PM_STOP;            // Flag page mode stop
    reg                                 PM_DONE;            // Flag page mode done
    // read, write ongoing
    reg                                 Read;               // Flag read active
    reg                                 Write;              // Flag write active
    reg         [`DSIZE-1:0]            mDATAOUT;           // Controller Data output
    wire        [`DSIZE-1:0]            mDATAIN;            // Controller Data input 2
    wire                                CMDACK;             // Controller command acknowledgement

    // DRAM Control
    reg         [`DSIZE/8-1:0]          DQM;                // SDRAM data mask lines
    reg         [`SASIZE-1:0]           SA;                 // SDRAM address output (Why is this signal called exactly the same as an output?)
    reg         [1:0]                   BA;                 // SDRAM bank address
    reg         [1:0]                   CS_N;               // SDRAM Chip Selects
    reg                                 CKE;                // SDRAM clock enable
    reg                                 RAS_N;              // SDRAM Row address Strobe
    reg                                 CAS_N;              // SDRAM Column address Strobe
    reg                                 WE_N;               // SDRAM write enable
    wire        [`DSIZE-1:0]            DQOUT;              // SDRAM data out link
    wire        [`DSIZE/8-1:0]          IDQM;               // SDRAM data mask lines
    wire        [`SASIZE-1:0]           ISA;                // SDRAM address output (output from command.v written into SA. ISA is just glue between the command.v and the SA signal)
    wire        [1:0]                   IBA;                // SDRAM bank address
    wire        [1:0]                   ICS_N;              // SDRAM Chip Selects
    wire                                ICKE;               // SDRAM clock enable
    wire                                IRAS_N;             // SDRAM Row address Strobe
    wire                                ICAS_N;             // SDRAM Column address Strobe
    wire                                IWE_N;              // SDRAM write enable

    // FIFO Control
    reg                                 OUT_VALID;                  // Output data request to read side fifo
    reg                                 IN_REQ;                     // Input data request to write side fifo
    wire        [15:0]                  write_side_fifo_rusedw;     // used in the Sdram_WR_FIFO IP block
    wire        [15:0]                  read_side_fifo_wusedw;      // used in the Sdram_RD_FIFO IP block

    // DRAM Internal Control
    wire        [`ASIZE-1:0]            saddr;
    wire                                load_mode;
    wire                                nop;
    wire                                reada;
    wire                                writea;
    wire                                refresh;
    wire                                precharge;
    wire                                oe;
    wire                                ref_ack;
    wire                                ref_req;
    wire                                init_req;
    wire                                cm_ack;
    wire                                active;
    output                              CLK;

    // PLL
    sdram_pll0 sdram_pll0_inst(
        .refclk(REF_CLK),           // refclk.clk
        .rst(1'b0),                 // reset.reset
        .outclk_0(CLK),             // outclk0.clk
        .outclk_1(SDR_CLK),         // outclk1.clk
        .locked()                   // locked.export
    );

    // control_interface is defined in control_interface.v
    //
    // After the Sdram_Control.v file (this module) has decided wich address to read of write
    // the resulting configuration data is put into this control_interface.v module.
    control_interface control1 (
    
        //
        // inputs
        //
    
        // clock and reset
        .CLK(CLK),
        .RESET_N(RESET_N),
        
        .CMD(CMD), // CMD is passed in here!
        .ADDR(mADDR), // this is the addr to either read or write  (see Auto Read / Write Control further down)
        .REF_ACK(ref_ack),
        .CM_ACK(cm_ack),
        
        //
        // outputs
        //
        
        // commands (outputs) - determine which command to execute using the command entity instance below
        .NOP(nop),
        .READA(reada),
        .WRITEA(writea),
        .REFRESH(refresh),
        .PRECHARGE(precharge),
        .LOAD_MODE(load_mode), // output for activating the LOAD_MODE command
        
        .SADDR(saddr),
        .REF_REQ(ref_req),
        .INIT_REQ(init_req),
        .CMD_ACK(CMDACK)
    );

    // the Command is defined in command.v
    // I think command.v takes in actions that the controller wants to perform wheres
    // these actions are defined on an abstract level. command.v then breaks the abstract
    // commands down to control signals and timing for the SDRAM chip so that the commands
    // are then actually executed
    command command1(

        //
        // intputs to the control
        //

        .CLK(CLK),
        .RESET_N(RESET_N),

        .SADDR(saddr),
        // commands end - these are the commands to execute
        .NOP(nop),              // nop is output by the control_interface which decodes it from CMD
        .READA(reada),          // reada is output by the control_interface which decodes it from CMD
        .WRITEA(writea),        // writea is output by the control_interface which decodes it from CMD
        .REFRESH(refresh),      // refresh command
        .LOAD_MODE(load_mode),  // load mode command
        .PRECHARGE(precharge),  // precharge command
        // commands end
        .REF_REQ(ref_req),      // Hidden refresh request
        .INIT_REQ(init_req),    // Hidden initialize request
        .PM_STOP(PM_STOP),      // Page mode stop
        .PM_DONE(PM_DONE),      // Page mode done

        //
        // Ouptuts - these are outputs of this instance
        //

        .REF_ACK(ref_ack),      // Refresh request acknowledge
        .CM_ACK(cm_ack),        // Command acknowledge ??? 
        .OE(oe),                // OE signal for data path module

        .SA(ISA),               // SDRAM address
        .BA(IBA),               // SDRAM bank address
        .CS_N(ICS_N),           // SDRAM chip selects
        .CKE(ICKE),             // SDRAM clock enable
        .RAS_N(IRAS_N),         // SDRAM RAS, Row Address Strobe Command
        .CAS_N(ICAS_N),         // SDRAM CAS, Column Address Strobe Command
        .WE_N(IWE_N)            // SDRAM WE_N, Write Enable
    );

    // defined in sdr_data_path.v
    //
    // What does this entity do?
    sdr_data_path data_path1(
        .CLK(CLK),
        .RESET_N(RESET_N),
        .DATAIN(mDATAIN),
        .DM(2'b00),
        .DQOUT(DQOUT),
        .DQM(IDQM)
    );

    // IP Block SDRAM fifo - It is a predefined IP block by Quartus.
    // It is a FIFO queue backed by SDRAM
    //
    // defined in Sdram_WR_FIFO.v
    Sdram_WR_FIFO write_fifo1(
        .data(WR_DATA),
        .wrreq(WR),
        .wrclk(WR_CLK),
        .aclr(WR_LOAD),
        .rdreq(IN_REQ & WR_MASK),
        .rdclk(CLK),
        .q(mDATAIN),
        .wrfull(WR_FULL),
        .wrusedw(WR_USE),
        .rdusedw(write_side_fifo_rusedw)
    );

    // What does this flag do?
    // only when the flag is set to 1 will a read or write operation get configured (see Auto Read / Write Control further down)
    reg flag;
    always@(posedge CLK or negedge RESET_N)
    begin
        if (!RESET_N)
            flag <= 0;
        else
        begin
            // when the FIFO space is used up, set the flag. The flag causes the data to be written into SDRAM
            if (write_side_fifo_rusedw == WR_LENGTH)
                flag <= 1;
        end
    end

    // IP Block SDRAM fifo - It is a predefined IP block by Quartus.
    // It is a FIFO queue backed by SDRAM
    //
    // defined in Sdram_RD_FIFO.v
    Sdram_RD_FIFO read_fifo1(
        .data(mDATAOUT), // mDATAOUT gets the 16 bit word assign that is read from the SDRAM
        .wrreq(OUT_VALID & RD_MASK),
        .wrclk(CLK),
        .aclr(RD_LOAD),
        .rdreq(RD),
        .rdclk(RD_CLK),
        .q(RD_DATA),
        .wrusedw(read_side_fifo_wusedw),
        .rdempty(RD_EMPTY),
        .rdusedw(RD_USE)
    );

    // ST is Controller status
    //
    // SC_CL is a parameter defined inside the Sdram_Params.h 
    // (C:\aaa_se\fpga\DE10-Standard_v.1.3.0_SystemCD_original\Demonstration\FPGA\DE10_Standard_DRAM_RTL_Test\Sdram_Control\Sdram_Params.h)
    always @(posedge CLK)
    begin
        // SA == SDRAM address output
        SA          <= (ST == SC_CL + mLENGTH) ? 13'h200 : ISA;
        // BA == SDRAM bank address
        BA          <= IBA;
        CS_N        <= ICS_N;
        CKE         <= ICKE;
        RAS_N       <= (ST == SC_CL + mLENGTH) ? 1'b0 : IRAS_N;
        CAS_N       <= (ST == SC_CL + mLENGTH) ? 1'b1 : ICAS_N;
        WE_N        <= (ST == SC_CL + mLENGTH) ? 1'b0 : IWE_N;
        
        // page mode
        PM_STOP     <= (ST == SC_CL + mLENGTH) ? 1'b1 : 1'b0;
        PM_DONE     <= (ST == SC_CL + SC_RCD + mLENGTH + 2) ? 1'b1 : 1'b0;
        
        DQM         <= ( active && (ST >= SC_CL) ) ? (((ST == SC_CL + mLENGTH) && Write) ? 2'b11 : 2'b00) : 2'b11;
        mDATAOUT    <= DQ; // data from the SDRAM chip (DQ = databus directly connected to the SDRAM chip) is copied into the mDATAOUT signal
    end

    // I think here the data to write is assigned to the (DQ = databus directly connected to the SDRAM chip)
    // DQOUT is ????
    assign  DQ = oe ? DQOUT : `DSIZE'hzzzz;
    
    assign  active = Read | Write;

    // this determines which CMD to execute based on the current (ST = Controller Status)
    // The controller status
    always @(posedge CLK or negedge RESET_N)
    begin
        if (RESET_N == 0)
        begin
            CMD             <= 0;
            ST              <= 0;
            Pre_RD          <= 0;
            Pre_WR          <= 0;
            Read            <= 0;
            Write           <= 0;
            OUT_VALID       <= 0;
            IN_REQ          <= 0;
            mWR_DONE        <= 0;
            mRD_DONE        <= 0;
        end
        else
        begin
            Pre_RD  <= mRD;
            Pre_WR  <= mWR;
            
            // ST is controller status
            case(ST)
            
            0:  begin
                if({Pre_RD, mRD} == 2'b01)
                    begin
                        Read        <= 1;
                        Write       <= 0;
                        CMD         <= 2'b01; // Command 01 == READA command
                        ST          <= 1;
                    end
                else if({Pre_WR, mWR} == 2'b01)
                    begin
                        Read        <= 0;
                        Write       <= 1;
                        CMD         <= 2'b10; // Command 10 == WRITEA command
                        ST          <= 1;
                    end
                end
                
            1:  begin
                if(CMDACK == 1)
                    begin
                        CMD         <= 2'b00; // Command 00 == NOP command
                        ST          <= 2;
                    end
                end
                
            default:
                begin
                    if (ST != SC_CL + SC_RCD + mLENGTH + 1)
                        ST <= ST + 1;
                    else
                        ST <= 0;
                end
            endcase

            //
            // READ
            //
            if(Read)
                begin
                    if (ST == SC_CL + SC_RCD + 1)
                        OUT_VALID           <= 1;
                    else 
                    if(ST == SC_CL + SC_RCD+mLENGTH+1)
                        begin
                            OUT_VALID       <= 0;
                            Read            <= 0;
                            mRD_DONE        <= 1;
                        end
                end
            else
                mRD_DONE    <=  0;

            //
            // WRITE
            //
            if (Write)
                begin
                    if ( ST == SC_CL-1)
                        IN_REQ  <=  1;
                    else 
                    if (ST == SC_CL + mLENGTH-1)
                        IN_REQ  <=  0;
                    else 
                    if (ST== SC_CL + SC_RCD + mLENGTH)
                    begin
                        Write       <= 0;
                        mWR_DONE    <= 1;
                    end
                end
            else
                mWR_DONE<=  0;

        end
    end

    // Internal Address & Length Control
    //
    // This is the location where the internal flags mWR
    always@(posedge CLK or negedge RESET_N)
    begin
        if(!RESET_N)
            begin
                rWR_ADDR        <=  WR_ADDR;
                rRD_ADDR        <=  RD_ADDR;
            end
        else
            begin
            
                // Write Side 
                if (WR_LOAD)
                    rWR_ADDR    <=  WR_ADDR;
                else 
                if (mWR_DONE & WR_MASK)
                    begin
                        if (rWR_ADDR < WR_MAX_ADDR - WR_LENGTH)
                            rWR_ADDR    <=  rWR_ADDR + WR_LENGTH;
                        else
                            rWR_ADDR    <=  WR_ADDR;
                    end

                // Read Side 
                if(RD_LOAD)
                    rRD_ADDR    <=  RD_ADDR;
                else if(mRD_DONE & RD_MASK)
                    begin
                        if (rRD_ADDR < RD_MAX_ADDR - RD_LENGTH)
                            rRD_ADDR    <=  rRD_ADDR + RD_LENGTH;
                        else
                            rRD_ADDR    <=  RD_ADDR;
                    end
                
            end
    end

    // Auto Read / Write Control
    always @(posedge CLK or negedge RESET_N)
    begin
        if(!RESET_N)
        begin
            mWR         <=  0;
            mRD         <=  0;
            mADDR       <=  0;
            mLENGTH     <=  0;
            WR_MASK     <=  0;
            RD_MASK     <=  0;
        end
        else
        begin
        
            if(
                (mWR == 0) && 
                (mRD == 0) && 
                (ST == 0) &&
                (WR_MASK == 0) && 
                (RD_MASK == 0) &&
                (WR_LOAD == 0) && 
                (RD_LOAD == 0) && 
                (flag == 1) // only when flag is set, will the 
                )
            begin
            
                // this section loads the signals with configuration data either for reading or writing
                // the configuration data is read by the control_interface instance entity
                // the configuration data determines which abstract command to execute
                // the abstract command is translated to concrete signals to the SDRAM chip by the command.v
            
                // Write Side
                //
                // If the write_side_fifo space is all used up, write the data into SDRAM
                if ( (write_side_fifo_rusedw >= WR_LENGTH) && (WR_LENGTH != 0) )
                    begin
                        mADDR   <= rWR_ADDR;    // rWR_ADDR comes from ??? and is copied to mADDR
                        mLENGTH <= WR_LENGTH;
                        WR_MASK <= 1'b1;        // write
                        RD_MASK <= 1'b0;        // do not read
                        mWR     <= 1;           // write
                        mRD     <= 0;
                    end
                // Read Side 
                else if ( (read_side_fifo_wusedw < RD_LENGTH) )
                    begin
                        mADDR   <= rRD_ADDR;
                        mLENGTH <= RD_LENGTH;
                        WR_MASK <= 1'b0;        // do not write
                        RD_MASK <= 1'b1;        // read
                        mWR     <= 0;
                        mRD     <= 1;           // read
                    end

            end

            if(mWR_DONE)
            begin
                WR_MASK <=  0;
                mWR     <=  0;
            end

            if(mRD_DONE)
            begin
                RD_MASK <=  0;
                mRD     <=  0;
            end
            
        end
    end

endmodule
