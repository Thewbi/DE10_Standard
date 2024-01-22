# SDRAM Tester

## Application Structure

The top-level entity is C:\aaa_se\fpga\DE10_Standard\DE10_Standard_DRAM_RTL_Test\DE10_Standard_DRAM_RTL_Test.v.

The rest of the files are stored inside the folder C:/aaa_se/fpga/DE10_Standard/DE10_Standard_DRAM_RTL_Test/v

### de10_standard_dram_rtl_test.v

The top-level entity. It contains the list of inputs and outputs that connect the design to the pyhsical devices on the PCB board such
as clocks, LEDs, buttons, SDRAM. It instantiates a PLL and forwards the clock to the other instantiated modules:

* Sdram_Control
* RW_Test

### RW_Test.v

RW_Test is the test driver. It is the module that produces the signals that control the Sdram_Control module to perform the steps
that are necessary to perform an SDRAM test.

The SDRAM test starts when the user presses a push button on the board. The clock count when the push button is pressed is used
to compute a test value. That value is written into all the addresses of the SDRAM defined for the address space in the test. (I am not sure if the entire SDRAM is filled).

Then the RW_Test module starts a state machine. The state machine starts in an idle state where the start address is set to 0x00.
At the same time, the idle state gives the system enough time to setup the SDRAM which has to go through a initialization process 
which happens during the  INIT_PER (INITialization PERiod) (see control_interface.v)

After the idle state, the state machine performs the write operations to all the addresses.

After the write, the data is read back and compared to the test value.

### Sdram_Control.v

The job if Sdram_Control is to take the address to read from or write to and the data to write into the SDRAM from the RW_Test module
and to execute the SDRAM commands that make the requested operation happen.

SDRAM commands is the protocol that has to be used to talk to the SDRAM chip.
Before commands can be sent to the SDRAM, the SDRAM chip has to go through a INITialization PERiod.
After the initializeation is done, commands can be sent.

The WR write request and write data from the RW_Test module is placed into a FIFO (Sdram_WR_FIFO write_fifo1).
When the FIFO is full of data, a flag is set. When the flag is set, the Sdram_Control starts to assemble a configuration (See // Auto Read / Write Control).
This configuration is then used here: always @(posedge CLK or negedge RESET_N) which sets the CMD signal for example.

CMD is a high-level abstract command. This command has to be translated into signals for the SDRAM commands that the SDRAM chip understand.

CMD is placed into the control_interface module instance.

### control_interface.v

This module goes through the SDRAM initialization process after power on.

It produces the signals for commands to execute based on each step within the 
initialization process but it does not execute the commands itself instead
it only produces mathing outputs for other modules to pick up and execute the commands.

The external module that really talks to the SDRAM chip and executes the commands is
command.v (instantiated in Sdram_Control.v)

After the initialization process, this module takes in abstract high level commands in CMD
and translates them to NOP, READA and WRITEA commands signals so that other external
modules can execute those commands.

I think this module also manages timers for normal commands (NOP, READA and WRITEA)

### command.v

command.v is the module that knows the protocol to talk to the SDRAM.
In a sense it is the SDRAM driver.

### sdr_data_path.value

The sdr_data_path 
