// Address Space Parameters

`define ROWSTART        10          
`define ROWSIZE         13

`define COLSTART        0
`define COLSIZE         10

`define BANKSTART       23
`define BANKSIZE        2


// Address and Data Bus Sizes
`define  SASIZE          13

`define  ASIZE           25      // total address width of the SDRAM
`define  DSIZE           16      // Width of data bus to SDRAMS

//parameter	INIT_PER	=	100;		//	For Simulation

//	Controller Parameter
////////////	133 MHz	///////////////
/*
parameter	INIT_PER	=	32000;
parameter	REF_PER		=	1536;
parameter	SC_CL		=	3;
parameter	SC_RCD		=	3;
parameter	SC_RRD		=	7;
parameter	SC_PM		=	1;
parameter	SC_BL		=	1;
*/
///////////////////////////////////////
////////////	100 MHz	///////////////
parameter	INIT_PER	=	24000;
parameter	REF_PER		=	1024;
parameter	SC_CL		=	3; // CAS LATENCY
parameter	SC_RCD		=	3;
parameter	SC_RRD		=	7;
parameter	SC_PM		=	1; // PAGE MODE (if 1 writes entire page. Burst length is set to entire page.)
parameter	SC_BL		=	1; // BURST LENGTH (If PAGE MODE is disabled (SC_PM == 0), then a BURST_LENGTH can be configured) (If PAGE MODE is enabled (SC_PM == 0), then the burst is always one entire page)
///////////////////////////////////////
////////////	50 MHz	///////////////
/*
parameter	INIT_PER	=	12000;
parameter	REF_PER		=	512;
parameter	SC_CL		=	3;
parameter	SC_RCD		=	3;
parameter	SC_RRD		=	7;
parameter	SC_PM		=	1;
parameter	SC_BL		=	1;
*/
///////////////////////////////////////

// SDRAM Parameter
// For writing into the mode register during initialization to configure SDRAM behaviour

// SDR_BL == SDRAM Burst Length (3 bit) 
parameter	SDR_BL		=	(SC_PM == 1)?	3'b111	: // First branch is used for page mode (SC_PM == 1), which means the burst length is one entire page. If SDR_BT == 0, then 111 means full page.
							(SC_BL == 1)?	3'b000	:
							(SC_BL == 2)?	3'b001	:
							(SC_BL == 4)?	3'b010	:
											3'b011	;
// BT = Burst Type (has an effect on full page mode too)							
parameter	SDR_BT		=	1'b0;	//	Sequential
							//	1'b1:	//	Interleave
							
// CL = CAS Latency
parameter	SDR_CL		=	(SC_CL == 2)?	3'b10	: // CAS LATENCY set to 2
											3'b11	; // CAS LATENCY set to 3
 	
