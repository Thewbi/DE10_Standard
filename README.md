# DE10_Standard
DE10 Standard projects



# Links

* https://github.com/zangman/de10-nano
* https://github.com/zangman/de10-nano/blob/master/docs/Configuring-the-Device-Tree.md

## Avalon
* https://www.youtube.com/watch?v=Vw2_1pqa2h0



# Terasic DE 10

## General

DE stands for Development and Education (https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=163)



## Boards

* DE0 Nano - small board without ethernet port
* DE10 Nano - https://www.mouser.de/ProductDetail/Terasic-Technologies/P0496?qs=%2FacZuiyY%252B4ZdDLJqTxdJ5w%3D%3D
* DE10 Standard - 

* DE1-SoC - https://people.ece.cornell.edu/land/courses/ece5760/DE1_SOC/DE1-SoC_User_manualv.1.2.2_revE.pdf





# Terminology / Glossary

https://www.intel.com/content/www/us/en/programmable/quartushelp/17.0/reference/glossary/glosslist.htm

DE10_NANO_SoC_GHRD - Golden Hardware Reference Designs (GHRD) (see ug_soc_eds-19-1-standard-and-19-3-pro-683187-705474.pdf)
https://github.com/altera-opensource
Also Chapter: (6.2 Golden Hardware Reference Design (GHRD) and system circuit) of https://matheo.uliege.be/bitstream/2268.2/11612/7/Implementing%20the%20beta%20machine%20on%20a%20Terasic%20DE10%20SoC%20%2b%20FPGA%20development%20board.pdf

* .sof - FPGA hardware SRAM Object File (.sof) file. A SRAM object file is used
* .sof files can be converted to .rbf files using Quartus.
* Quartus II project file (.qpf)
* Quartus II setting file (.qsf)
* Top-level design file (.v or .vhd)
* Synopsis design constraints file (.sdc)
* Pin assignment document (.htm)

.rbf - https://www.intel.com/content/www/us/en/programmable/quartushelp/17.0/reference/glossary/def_rbf.htm
A binary file (with the extension .rbf) containing configuration data for use outside the Quartus® Prime software. 
A Raw Binary File contains the binary equivalent of a Tabular Text File (.ttf).
Copy the .rbf file on the FAT partition of the memory card of the DE10-NANO.




## golden_top Quartus project

See DE10-Standard_User_manual.pdf

Is a template project for Quartus to start projects for the DE10 standard from.
It is contained on the CD.




## DE10 Standard System Builder

See DE10-Standard_User_manual.pdf

The System Builder is an application that outputs Quartus projects based on options
that the user selects inside the system builder tool.

Additionally, developers can use the System Builder software utility to create their Quartus project.

The SystemBuilder is part of the DE10 Standard System CD:
* https://github.com/Insper/DE10-Standard-v.1.3.0-SystemCD
* https://github.com/Insper/DE10-Standard-v.1.3.0-SystemCD/tree/master/Tool/SystemBuilder
* https://github.com/Insper/DE10-Standard-v.1.3.0-SystemCD/blob/master/Tool/SystemBuilder/DE10_Standard_SystemBuilder.exe





## FPGA Startup/Configuration Mode

Info: The startup mode has nothing to do with loading a bitstream onto the DE10-Standard during
Quartus development. During development a bitstream is loaded directly into the Cyclone V FPGA and
is retained there until power is turned off which is when the FPGA looses it's configuration. Another
option is to load a bitstream into the EPCS, from which the FPGA will load it's configuration if 
the startup mode AS is choosen. The bitstream once loaded into the EPCS is keept across power cycles.

The startup mode determines from where the FPGA loads its configuration when powered on.

Based on the settings of the SW10 6-pin Dip-Switch (aka. MSEL) on the DE10-Standard board,
the FPGA is started from EPCS or HPS.

EPCS - (EPCS128) quad serial configuration device

HPS - Hard-Processor System. (Configure the FPGA using software provided on the Linux System)

To start from EPCS, configure the AS mode/configuration scheme.
AS = Active Serial
AS mode is set with 
SW10.1 = MSEL0 = 1
SW10.2 = MSEL1 = 0
SW10.3 = MSEL2 = 0
SW10.4 = MSEL3 = 1
SW10.5 = MSEL4 = 0
SW10.6 = N/A

To configure the FPGA from the Hard-Processor system, activate the FPPx32 mode/configuration scheme.
SW10.1 = MSEL0 = 0
SW10.2 = MSEL1 = 1
SW10.3 = MSEL2 = 0
SW10.4 = MSEL3 = 1
SW10.5 = MSEL4 = 0
SW10.6 = N/A






## Programming the FPGA

Programming refers to uploading a bit stream to the FPGA using Quartus.
Quartus can program directly into the FGPA where the bitsream is only kept
temporarily until a power cycle takes place. This is usefull during development.
Quartus also can program bitstream into the EPCS where the bitstream replaces
the current bitstream and stays persisted across power cycles. When the DE10 Standard
is programmed to use AS Configuration Mode, it will load the bitstream from the EPCS
into the FPGA on power-on.







# .tcl (ticcle) scripts

Run tcl scripts from within Quartus:

Go to the View > Utility Windows -> Tcl Console.
The ticcle console opens inside the Quartus UI.
Inside the ticcle console type:

```
source pin_assignment_DE1_SoC.tcl
```






# qsys

qsys has been renamed to Platform Designer. 
Platform Designer can be started from within Quartus: Tools > Platform Designer

# Baseline Pinout

In this tutorial https://people.ece.cornell.edu/land/courses/ece5760/DE1_SOC/SoC-FPGA%20Design%20Guide_EPFL.pdf
chapter 9 outlines the design of a system for the Cyclone V FPGA.

I found the baseline pinout for the DE10-Standard here:
https://www.intel.com/content/www/us/en/support/programmable/support-resources/design-examples/design-store.html?f:guidetm83741EA404664A899395C861EDA3D38B=%5BIntel%C2%AE%20Cyclone%C2%AE%3BCyclone%C2%AE%20V%20FPGAs%20and%20SoC%20FPGAs%5D
The download is a .par file (DE10_Standard_Golden_Top.par), which is a design template file for quartus prime.
When double clicking the .par file, quartus opens and allows you to create a new project from the project template.







# NIOS ii SoftProcessor / DE10-Standard Computer System with Nios® II

## Intel FPGA Monitor Program

It provides an easy way to assemble/compile Nios II programs written in either assembly language or the C language.

https://fpgacademy.org/tools.html

Download the version 21.1 - https://fpgacademy.org/Downloads/21.1/intel_fpga_upds_setup.exe

I installed the Monitor Program 21.1 into an existing Quartus 22.1 installation.

C:\intelFPGA_lite\22.1std






## NIOS ii, UART over JTAG

C:\intelFPGA_lite\22.1std\University_Program\Monitor_Program\amp\lib\src\niosII_jtag_uart.c




## UART over GPIO pins

https://community.intel.com/t5/FPGA-SoC-And-CPLD-Boards-And/DE10-Nano-IP-UART-GPIO-pins/m-p/1518223

The answer in the post above states, that it is indeed possible to attach a UART to the GPIO pins.

Section 5 in DE10-Standard_Computer_NiosII.pdf explains how to extend the NIOS ii processor.

```
5 Modifying the DE10-Standard Computer
It is possible to modify the DE10-Standard Computer by using Intel’s Quartus® Prime software and Qsys tool.
Tutorials that introduce this software are provided in the University Program section of Intel’s web site. To modify
the system it is first necessary to make an editable copy of the DE10-Standard Computer are installed as part of the 
Monitor Program installation. Locate these files, copy them to a working directory, and
then use the Quartus Prime and Qsys software to make any desired changes.
```

C:\intelFPGA_lite\22.1std\University_Program\Monitor_Program

Here is the project (Maybe install Intel FPGA Monitor Program first):
C:\intelFPGA_lite\22.1std\University_Program\Computer_Systems\DE10-Standard\DE10-Standard_Computer\verilog\DE10_Standard_Computer.qpf



The steps needed to modify the system are:
1. Install the University Program IP Cores from Intel’s FPGA University Program web site
2. Copy the design source files for the DE10-Standard Computer from the University Program web site. These
	files can be found in the Design Examples section of the web site
3. Open the DE10-Standard_Computer.qpf project in the Quartus Prime software
4. Open the Qsys System Integration tool in the Quartus Prime software, and modify the system as desired
5. Generate the modified system by using the Qsys System Integration tool
6. It may be necessary to modify the Verilog or VHDL code in the top-level module, DE10-Standard_Computer.v/vhd,
	if any I/O peripherals have been added or removed from the system
7. Compile the project in the Quartus Prime software
8. Download the modified system into the DE10-Standard board






## Error Upgrading

https://community.intel.com/t5/Intel-FPGA-Software-Installation/Can-t-Open-Encrypted-VHDL-File/m-p/1446219

Error upgrading Platform Designer File "Computer_System.qsys"

Go to Tools -> Platform Designer -> Load Computer_System.qsys -> Generate HDL (right-bottom) -> Recompile



https://community.intel.com/t5/Intel-Quartus-Prime-Software/Qsys-Platform-Designer-seq-add-fileset-file-No-such-file-hps-AC/td-p/696800

- uninstalled Ubuntu 18.04 (If you have)
- uninstalled wsl  
- re-installed wsl
- downloaded latest Ubuntu 18.04 from Microsoft Shop & installed it
- executed following on Ubuntu shell :   
	sudo apt-get update
	sudo apt install wsl 
	sudo apt install dos2unix
	sudo apt install make 
	sudo apt-get upgrade 
  
  
  
Does not compile on windows 10 with upgrades and Quartus 22.1
It should work on linux.
Create a large linux system and use Quartus 18.1

Use Ubuntu 18.04 (https://releases.ubuntu.com/18.04/) since this Ubuntu version has to most wide support for even the most modern
versions of Quartus Prime. According to reports from the internet it does support the installation of Quartus Prime 18.1.



## Error compiling the DE10-Standard Computer

https://community.intel.com/t5/Intel-Quartus-Prime-Software/I-keep-getting-this-error-when-i-try-and-compile-and-havent-been/td-p/721211

MenuBar > Assignment > Settings > Library (Category Field) > Add your library path, then apply it.

Click "Add All" > Apply > Close.

Error (12006): Node instance "c0" instantiates undefined entity 
"altera_mem_if_hard_memory_controller_top_cyclonev". 
Ensure that required library paths are specified correctly, define the specified entity, 
or change the instantiation. If this entity represents Intel FPGA or third-party IP, 
generate the synthesis files for the IP.

Error (12006): Node instance "error_adapter_0" instantiates undefined entity 
"Computer_System_mm_interconnect_0_avalon_st_adapter_error_adapter_0". 
Ensure that required library paths are specified correctly, define the specified entity, 
or change the instantiation. If this entity represents Intel FPGA or third-party IP, 
generate the synthesis files for the IP.




# AXI and Avalon

Communication between the HPS and the FPGA fabric.








# ModelSim

ModelSim might not be installed on your system. You can download it from here:
https://www.intel.com/content/www/us/en/software-kit/750666/modelsim-intel-fpgas-standard-edition-software-version-20-1-1.html

Once it is installed, it can be run from the start menu.

ModelSim first has to create a project to which the DUT module and the testbench is added for simulation.
Create a folder called "sim" to create the ModelSim project inside.
File > New > Project...
Project Name: "project"
Select the "sim" folder.

A new dialog opens. Select "Add Existing File" > Browse
Select the files switches_to_LEDs.v and tb_switches_to_LEDs.v.
OK

Compile the files:
MenuBar > Compile > Compile All

Start the simulation
MenuBar > Simulate > Start Simulation > Select the work library > Select the testbench file: tb_switches_to_LEDs.v

To show the wave form viewer:
View > Wave

In the objects viewer, select all signals, you want to simulate and drag them into the wave form viewer.

Click the very, very small button at the bottom called "Toggle leaf names <-> full names".

Click MenuBar > Simulate > Run > Run -All

Ctrl + MouseWheel to zoom.

You should see the signals in the wave form viewer.
You can also use the zoom full button to put all signal changes onto the screen.




# Upload bitstream to the DE10 Standard directly into the FPGA (not into EPCS)

https://www.intel.com/content/www/us/en/docs/programmable/683769/17-1/step-5-configure-your-design-on-the-board.html

Processing > Start Compilation > Wait until compilation is done.

Connect the USB cable between the PC and the DE10 standard.
Apply power to the DE10 Standard.

Tools > programmer 
Click the "Hardware Setup" button
Add Hardware > Auto Detect

If nothing is auto detected, click the "Add Device" button.
Manually select 

The chip on the DE10 Standard is: 5CSXFC6D6F31   (SE 5CSXFC6D6F31C6N)
Mode: JTAG

Processing > Auto Detect > Select: 5CSXFC6D6

Q: "Start" Button is deactivated!
A: Make sure you have the right USB cable plugged in! Sometimes there are that many USB cables on the table that it gets confusing.
In the Windows Device Manager, when you plug in the cable, a node called "JTAG cables" has to appear.
Within the "JTAB cables" node there has to be a Altera USB Blaster II JTAG node!
When this node exists, the start button is not grayed out any longer.

https://www.youtube.com/watch?v=erYag9zr0ek
There will be a warning about non-matching something, click OK and ignore it.

Select the FPGA in the graphical JTAG chain > On the left hand side, select "Change file" > Select the .sof file.

In the list of JTAG devices, find the line for the 5CSXFC6D6.
In this line, set the checkmark in the checkbox "Program/Configure"
In the columns, set the checkbox called "Program/Configure" 

Click "Start" on the left side

Device Manager > JTAG Cables





# Blink LEDs

Start Quartus

File > New > New Quartus Prime Project

On the Device Selection wizard, select Family: Cyclone V (E / GX / GT / SX / SE / ST)
Device: Cyclone V SX Extended edition features

In the available device list, select 5CSXFC6D6F31C6 > Finish the wizard.
Altera Cyclone® V SE 5CSXFC6D6F31C6N

Create a toplevel schematic file.
File > New > Block Diagram / Schematic File > OK > Save it as blinky.bdf

File > New > Verilog HDL File >

```
module counter(rst, clk, led);

input rst, clk;
output led;
reg led;
reg [31:0] cnt;

always @(posedge clk or negedge rst)
begin
	if (rst == 0)
	begin
		cnt <= 0;
		led <= 0;
	end
	else
	begin
		if (cnt < 500000)
			cnt <= cnt + 1;
		else
		begin
			cnt <= 0;
			led <= ~led;
		end
	end
end

endmodule
```

Save it as counter.v

While the counter.v is selected, File > Create / Update > Create Symbol files for current file.

Insert the counter module into the top-level block diagram.

Double click the empty area > Project > Under "Libraries" unfold the project node 
> Select the counter node > Click > OK.

Open the IP catalog to pull in a PLL clock into the top level design.
Libraries > Basic Functions > Clocks > PLL > PLL Intel FPGA IP
IP Variation Filename: baudrate_pll

Select PLL Intel FPGA IP. >  The MegaWizard will load.
Reference Clock Frequency: 50 Mhz. (Reading: https://ftp.intel.com/Public/Pub/fpgaup/pub/Intel_Material/Boards/DE10-Standard/DE10_Standard_User_Manual.pdf, the DE10-Standard has 50 Mhz clocks connected to the FPGA fabric)
Desired Frequency: 2 MHz.
Remove the checkbox at the lock output.
Finish.

A quartus prime IP file (.qip) is generated.

After the generation is done, double click an empty spot on the block diagram, from the project node, select
the pll_clock. Place it onto the schematic. Connect outclk0 to clk of the counter.

Add a reset push button:
double click an empty spot on the block diagram
From the primitives > select logic > not
place the not on the schematic.

Add three pins (like you added the not gate) > You need two input pins and one output pin.
One of the inputs is called clk and it is connected to the PLL Block as reference clock.
The other input is called reset and it is connected to the Not gate.

The output pin is called LED and it is connected to the LED output of the counter module.

Start the compilation. Once it is done, we can assign pins.
Assignments > pin planner.

Clock Pin_af14
led   PIN_AA24
reset pin_Aj4

change I/O Standard to "3.3-V LVTTL" for all pins

Just close the pin planner without saving!

Start the compilation again

Tools > Programmer > Auto Detect > Choose: 5CSXFC6D6 > OK > Ignore the warning and click ok.

Select the FPGA in the graphical JTAG chain > On the left hand side, select "Change file" > Select the output_files/blinky.sof file.

In the columns, set the checkbox called "Program/Configure" > Click "Start" on the left side

Click Start



# Quartus Prime, find top level verilog file

To figure out which file is currently used as the top level module in a project, 
switch the mode in the project navigator to "Hierarchy".

Open the context menu on the entity that is shown in the hierarchy.
Select Settings which opens up the Settings Dialog.
Click the node "General". The general node shows the top-level entity.

You can also change the mode of the project navigator to "Files" then open 
the context menu on the verilog file you want to set as top-level entity and then
select "Set as Top-Level entity" from the context menu.



# Parameters to the top level entity

Where do the parameters of the top level entity come from?
Who and where is the top-level entity instantiated?





# Use a 50 Mhz clock as a parameter to the top level entity

One idea is to use the SystemBuilder application from the SystemCD if you do have the DE10 Standard board.
The SystemBuilder will allows you to select the Clock peripheral (and also GPIO pins) and it will generate
a project for you so you can take a look at the generated project in Quartus Prime.

SystemBuilder generates this TopLevel entity

```
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module uart(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// GPIO, GPIO connect to GPIO Default //////////
	inout 		    [35:0]		GPIO
);



//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================



endmodule
```


Is a .sdc file really necessary????

Why we need a SDC File? To give the TimeQuest Timing Analyzer the possibility 
to check if the timing of the design will fit in the FPGA, some "parameters" 
for the calculation are needed. This "parameters" are stored in the SDC file. 
For example you will find the following line in the file:

I think the .sdc file is necessary for the compilation process.

File > New > Synopsys Design Constraint File.
A .sdc file is created. Add the text:

```
create_clock -period "50.0 MHz" [get_ports CLOCK_50]
create_clock -period "50.0 MHz" [get_ports CLOCK2_50]
create_clock -period "10.0 MHz" [get_ports CLOCK_ADC_10]
create_clock -period "100.0 MHz" [get_ports DRAM_CLK]
derive_pll_clocks
derive_clock_uncertainty
```





# Instantiating IP cores in verilog top level module.

Some tutorials show how to make the top-level design unit a block diagram and
the tutorials show how to drag in IP blocks onto that block diagram.

But what if instead of a block diagram, you want to use a verilog file as the
base design unit?

https://www.intel.com/content/www/us/en/docs/programmable/683463/22-1/instantiating-ip-cores-in-hdl.html






# UART

This section explains approaches on how to implement a UART connection using the FPGA fabric 
(no predefined IP blocks, except a PLL clock) and the GPIO pins on the DE10-Standard board.

## First Version

The first version is able to receive and echo back a single character.
It is flawed in the sense that when sending an entire sentence (several characters in rapid succesion)
It will not correctly echo back all the characters, in fact it will consume and loose every second character!
The flaw is corrected in future versions.

The YAT Terminal application is used on a PC. A USB UART adapter is used to connect to GPIO pins on the DE10-Standard.
A 8N1 connection is established.

The code use as an example is taken from here: https://www.fpga4fun.com/SerialInterface1.html

The approach is to use a 50Mhz clock which is present on the DE10-Standard board as an input to a PLL
that is defined using the IP Library inside Quartus Prime. The PLL will output a 25 Mhz.

The 25 Mhz clock is used because it is a prerequisit for the tutorial: https://www.fpga4fun.com/SerialInterface1.html
The tutorial contains verilog modules that define a UART receiver and a UART sender.

The UART sender/receiver each need a single pin over which they sample incoming UART bytes and over which
the sender outputs a byte for transmission. To use the GPIO header on the DE10-Standard, a variable called GPIO is defined:

```
inout 		    [35:0]		GPIO,
```

Using the Pin Planner, the GPIO pins are then automatically assigned to the pins on the FPGA. 
In the Pin Planner, you have to set the voltage level to 3.3-V LVTTL. 
The handbook says that the GPIO are 3v3: https://ftp.intel.com/Public/Pub/fpgaup/pub/Intel_Material/Boards/DE10-Standard/DE10_Standard_User_Manual.pdf
Then, make sure that you 
use a 3v3 FPGA UART TTL adapter or if your adapter can be configured using PIN headers, configure
the adapter to use 3v3 (and not 5V, otherwise you damage the board).

It is quite confusing to figure out which physical PINS on the GPIO header have which index inside the GPIO variable.
But it works when using GPIO pin 33 as RxD (receive) pin:

```
wire RxD; // Physial PIN 38, GPIO_D33 - 3.3-V LVTTL
assign RxD = GPIO[33];
```

and using PIN GPIO_D35 as TxD (transmit)

```
async_transmitter TX(
		.clk(clock_25mhz), 
		.TxD_start(RxD_data_ready),
		.TxD_data(RxD_data),
		.TxD(GPIO[35]),
		.TxD_busy(TxD_busy)
	);
```

In the snippet above, GPIO[35] is not assigned to a wire but it is directly passed into the UART tranmitter.

The Pinout of the GPIO header on the DE10-Standard is given here: https://www.rocketboards.org/foswiki/pub/Documentation/DE10Standard/DE10-Standard_Schematic.pdf
It can be seen that the physical pin 38 matches the GPIO name GPIO_D33 in the pin planner.
The physical pin 40 matches the PIN Name: GPIO_D35.

Both pins are on the right side, at the very bottom and they are directly on top of each other (not next to each other).

## Running the Code 

Use the Pin planner to make sure that the correct pins are in place:

Compile this code:

```

//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module uart(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// GPIO, GPIO connect to GPIO Default //////////
	inout 		    [35:0]		GPIO,
	
	// after adding this entry, recompile so that these pins show up in the pin planner.
	output [3:0] LED
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

	wire clock;
    assign clock = CLOCK_50;
	
	wire clock_25mhz;
	
	wire locked;
	
	baudrate_pll b_pll (
		clock, //input  wire  refclk,   //  refclk.clk
		0, //input  wire  rst,      //   reset.reset
		clock_25mhz, //output wire  outclk_0, // outclk0.clk
		locked // output wire  locked    //  locked.export
	);
	
	counter ctr(1, clock_25mhz, LED[0]);
		
	// SOURCE: https://www.fpga4fun.com/SerialInterface5.html
	
	wire RxD; // Physial PIN 38, GPIO_D33 - 3.3-V LVTTL
	assign RxD = GPIO[33];
		
	wire TxD_busy;
	
	wire RxD_data_ready;
	wire [7:0] RxD_data;
	wire [7:0] TxD_data;
	
	async_receiver RX(
		.clk(clock_25mhz), 
		.RxD(RxD), 
		.RxD_data_ready(RxD_data_ready), 
		.RxD_data(RxD_data)
	);
	
	async_transmitter TX(
		.clk(clock_25mhz), 
		.TxD_start(RxD_data_ready),
		.TxD_data(RxD_data),
		.TxD(GPIO[35]),
		.TxD_busy(TxD_busy)
	);

	// Quartus Prime MenuBar > Assignments > PIN Planner
	
	// Uploading the design:
	// 1. Open Tools > Programmer
	// Info: The chip on the DE10 Standard is: 5CSXFC6D6F31   (SE 5CSXFC6D6F31C6N)
	//       Mode: JTAG
	// 2. Processing > Auto Detect > Select: 5CSXFC6D6
	// 3. There is a warning, ignore it

//=======================================================
//  Structural coding
//=======================================================

endmodule
```

You also need the modules:

* async_transmitter.v (from the tutorial: https://www.fpga4fun.com/SerialInterface1.html)
* async_receiver.v (from the tutorial: https://www.fpga4fun.com/SerialInterface1.html)
* baudrate_pll.qip + .sip (Generate inside QuartusPrime. Reference Clock 50Mhz, Output Clock: 25 Mhz)

Use the Tools > Programmer dialog to program the compiled file onto the DE10-Standard board.

Connect the TX and RX lines of your TTL adapter to the GPIO pins GPIO_D35, GPIO_D33.
Make sure RX of the adapter goes to TX on the DE10-Standard.
Make sure TX of the adapter goes to RX on the DE10-Standard.
Ground is not even hooked up.

Plug the TTL adapter into your PC and check using the windows device manager, which COM Port is assigned to the adapter.
Download and install the YAT terminal tool. Connect to the COM Port using YAT and establish a connection of type text (not binary)
using 8 data bits (8), No parity (N) and 1 stop bit (1) == 8N1

The idea of the top-level design is that whenever a byte is received, the exact same byte is then echoed back to the terminal
by transmitting that exact byte out.

Problems: Try to send the text Hello World, but do not send each individual character but paste both words (Hello and World) into
the text input field and send the entire text at once.

You can see that only every second character is returned to the terminal. HloWrd
I think that the characters do arrive so fast at the receive that the transmitter will send the input buffer,
which is already override with the following character. I think there needs to be a receive buffer in which incoming
data is stored until the incoming data is collected by another component.








# Using RAM with the FPGA fabric

https://www.reddit.com/r/FPGA/comments/x5x4a8/stuck_on_simple_fpga_sdram_controller_dropped/
C:\Users\U5353\Documents\Aschaffenburg\FPGA\DE10_Standard\ISSI_32Mx16_SDRAM_Controller.v

https://www.youtube.com/watch?v=FjuZ3IGNur0
https://fpga.seanwrall.com/lessons/

https://www.youtube.com/watch?app=desktop&v=euw0ILLTEhM
https://github.com/AntonZero/SDRAM-and-FIFO-for-DE1-SoC

https://stackoverflow.com/questions/57525000/altera-de10-standard-writing-to-ddr-using-fpga
https://www.reddit.com/r/FPGA/comments/x5x4a8/stuck_on_simple_fpga_sdram_controller_dropped/
https://ftp.intel.com/Public/Pub/fpgaup/pub/Intel_Material/18.1/Computer_Systems/DE10-Standard/DE10-Standard_Computer_NiosII.pdf


Synchronous Dynamic RAM (SDRAM)


In case you just need to access ddr, instantiate the ddr sdram controller available from intel 
(beware, there's a lot of options related to memory chips used), 
and access it through avalon-mm interface (= Avalon Memory Mapped Interface), like any other peripheral.

Does the SDRAM controller exist as an IP Block or can it only be used via QSys/Platform Designer?
In this video (https://www.youtube.com/watch?app=desktop&v=euw0ILLTEhM), the SDRAM controller is instantiated using QSys/Platform

'DE10 standard' has sdram on the fpga side, and ddr3 sdram on the HPS side. 

* 64MB SDRAM <-> FPGA
* 1GB DDR3 SDRAM <-> HPS

Do you want to access the fpga-side dedicated sdram (not ddr), 
or the memory that's connected to hard processor system? The approach will be very different.

The generic way - download the "SystemBuilder" sw from Terasic site (the manufacturer of the DE10 boards). 
https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=165&No=1081&PartNo=4#contents
https://github.com/Insper/DE10-Standard-v.1.3.0-SystemCD
C:\aaa_se\fpga\DE10-Standard_v.1.3.0_SystemCD
Find your board, open "Resources" section and download needed stuff.

SystemBuilder is contained on the SystemCD.
https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=165&No=1081&PartNo=4#contents
https://github.com/Insper/DE10-Standard-v.1.3.0-SystemCD
C:\aaa_se\fpga\DE10-Standard_v.1.3.0_SystemCD
The SystemBuilder application actually really has an option for SDRAM, 32MB




## Example Using SDRAM test in verilog

This example is part of the System CD: https://github.com/Insper/DE10-Standard-v.1.3.0-SystemCD/tree/master/Demonstration/FPGA/DE10_Standard_DRAM_RTL_Test
The example is described in the PDF documentation: https://www.mouser.com/datasheet/2/598/E10-Standard_User_manual-1128206.pdf

Manufacturer Part Number (ISSI) IS42S16320F-7TL

The overall idea is that the 64Mb SDRAM, which is connected to the FPGA is filled with a test sequence, and the test sequence is read back.
Based on if the correct data is read back, a led shows success or failure. If incorrect data is read back, the SDRAM chip is broken.



According to the datasheet of the ISSI SDRAM chip: https://www.issi.com/WW/pdf/42-45R-S_86400D-16320D-32160D.pdf
the SDRAM chip understands so called commands! Commands seem to be the interface to talk to the SDRAM chip.

The commands are listed in the datasheet:

### READ
The READ command selects the bank from BA0, BA1
inputs and starts a burst read access to an active row.
Inputs A0-An (For column addresses, n=A8 for x32, n=A9
for x16, n=A11 for x8), provides the starting column location. 
When A10 is HIGH, this command functions as an
AUTOPRECHARGE command. When the autoprecharge
is selected, the row being accessed will be precharged at
the end of the READ burst. The row will remain open for
subsequent accesses when AUTO PRECHARGE is not
selected. DQ’s read data is subject to the logic level on
the DQM inputs two clocks earlier. When a given DQM
signal was registered HIGH, the corresponding DQ’s will
be High-Z two clocks later. DQ’s will provide valid data
when the DQM signal was registered LOW.

### WRITE
A burst write access to an active row is initiated with the
WRITE command. BA0, BA1 inputs selects the bank, and
the starting column location is provided by inputs A0-An
(For column addresses, n=A8 for x32, n=A9 for x16, n=A11
for x8). AUTO-PRECHARGE is determined by A10.
The row being accessed will be precharged at the end of
the WRITE burst, if AUTO PRECHARGE is selected. If
AUTO PRECHARGE is not selected, the row will remain
open for subsequent accesses.
A memory array is written with corresponding input data
on DQ’s and DQM input logic level appearing at the same
time. Data will be written to memory when DQM signal is
LOW. When DQM is HIGH, the corresponding data inputs
will be ignored, and a WRITE will not be executed to that
byte/column location.

### PRECHARGE
The PRECHARGE command is used to deactivate the
open row in a particular bank or the open row in all banks.
BA0, BA1 can be used to select which bank is precharged
or they are treated as “Don’t Care”. A10 determined
whether one or all banks are precharged. After executing this 
command, the next command for the selected
bank(s) is executed after passage of the period tRP, which
is the period required for bank precharging. Once a bank
has been precharged, it is in the idle state and must be
activated prior to any READ or WRITE commands being
issued to that bank.

### AUTO PRECHARGE
The AUTO PRECHARGE function ensures that the precharge is 
initiated at the earliest valid stage within a burst.
This function allows for individual-bank precharge without 
requiring an explicit command. A10 to enable the AUTO
PRECHARGE function in conjunction with a specific READ
or WRITE command. For each individual READ or WRITE
command, auto precharge is either enabled or disabled.
AUTO PRECHARGE does not apply except in full-page
burst mode. Upon completion of the READ or WRITE
burst, a precharge of the bank/row that is addressed is
automatically performed.

### AUTO REFRESH COMMAND
This command executes the AUTO REFRESH operation.
The row address and bank to be refreshed are automatically 
generated during this operation. The stipulated period
(trc) is required for a single refresh operation, and no
other commands can be executed during this period. This
command is executed at least 8192 times for every Tref
period. During an AUTO REFRESH command, address
bits are “Don’t Care”. This command corresponds to CBR
Auto-refresh.

### BURST TERMINATE / BURST STOP (BST)
The BURST TERMINATE command forcibly terminates
the burst read and write operations by truncating either
fixed-length or full-page bursts and the most recently
registered READ or WRITE command prior to the BURST
TERMINATE.

### COMMAND INHIBIT
COMMAND INHIBIT prevents new commands from being
executed. Operations in progress are not affected, apart
from whether the CLK signal is enabled

### NO OPERATION (NOP)
When CS is low, the NOP command prevents unwanted
commands from being registered during idle or wait
states.

### LOAD MODE REGISTER / Mode register set (MRS)
During the LOAD MODE REGISTER command the mode
register is loaded from A0-A12. This command can only
be issued when all banks are idle.

### ACTIVE COMMAND / BANK ACTIVATE (ACT)
When the ACTIVE COMMAND is activated, BA0, BA1
inputs selects a bank to be accessed, and the address
inputs on A0-A12 selects the row. Until a PRECHARGE
command is issued to the bank, the row remains open
for accesses.

### DEVICE SELECT (DESL)




## Initialization of the SDRAM chip:

https://www.mouser.de/datasheet/2/198/42-45R-S_86400F-16320F-706495.pdf

FUNCTIONAL DESCRIPTION
The 512Mb SDRAMs are quad-bank DRAMs which operate at 3.3V or 2.5V and include a synchronous interface
(all signals are registered on the positive edge of the clock
signal, CLK).
Read and write accesses to the SDRAM are burst oriented;
accesses start at a selected location and continue for
a programmed number of locations in a programmed
sequence. Accesses begin with the registration of an ACTIVEcommandwhichisthenfollowedbyaREADorWRITE
command.The address bits registered coincident with the
ACTIVE command are used to select the bank and row to
be accessed (BA0 and BA1 select the bank, A0-A12 select the
row).The address bits A0-An; registered coincident with the
READ or WRITE command are used to select the starting
column location for the burst access.
Prior to normal operation, the SDRAM must be initialized. The following sections provide detailed information
covering device initialization, register definition, command
descriptions and device operation.

Initialization
SDRAMs must be powered up and initialized in a
predefined manner.
The 512Mb SDRAM is initialized after the power is applied
to Vdd and Vddq (simultaneously) and the clock is stable
with DQM High and CKE High.
A 100µs delay is required prior to issuing any command
other than a COMMAND INHIBIT or a NOP.The COMMAND
INHIBITorNOPmaybeappliedduringthe100usperiodand
should continue at least through the end of the period.
With at least one COMMAND INHIBIT or NOP command
having been applied, a PRECHARGE command should
be applied once the 100µs delay has been satisfied. All
banks must be precharged. This will leave all banks in an
idle state after which at least two AUTO REFRESH cycles
must be performed. After the AUTO REFRESH cycles are
complete, the SDRAM is then ready for mode register
programming.
The mode register should be loaded prior to applying
any operational command because it will power up in an
unknown state.


Notes by the author.
Overview of Initialization:
1. Power Up until the SDRAM is ready for Mode Register programming
	1. Apply power to the chip
	2. Wait for 100 microseconds (or send a COMMAND INHIBIT or NOP command which must be then kept active for 100 microsends)
	3. Send at least one COMMAND INHIBIT or NOP command
	4. SEND A PRECHARGE command to all banks -> Now all banks are in an idle state.
	5. perform at least two AUTO REFRESH commands
	6. The SDRAM is now ready for mode register programming
2. Mode register programming
3. READ, WRITE
	1. ACTIVE command (selects the bank and row)
	2. READ or WRITE command (selects the burst length)
	
	
# How to perform read and write

SDRAM read and write accesses are burst oriented starting at a selected location and continuing for a programmed number of locations in a programmed sequence.

The registration of an ACTIVE command begins accesses, followed by a READ or WRITE command. 

The ACTIVE command in conjunction with address bits registered are used to select the bank and row to be accessed 
(BA0, BA1 select the bank; A0-A12 select the row).

The READ or WRITE commands in conjunction with address bits registered are used to select the starting column location for the burst access.
Programmable READ or WRITE burst lengths consist of 1, 2, 4 and 8 locations or full page, with a burst terminate option.




## Signals / Pins

SDRAM RAS, Row Address Strobe Command
SDRAM CAS, Column Address Strobe Command
SDRAM WE_N, Write Enable




# Avalon, Avalon-MM

avalon-mm












# Programming from the command line

```
@ REM ######################################
@ REM # Variable to ignore <CR> in DOS
@ REM # line endings
@ set SHELLOPTS=igncr

@ REM ######################################
@ REM # Variable to ignore mixed paths
@ REM # i.e. G:/$SOPC_KIT_NIOS2/bin
@ set CYGWIN=nodosfilewarning

@set QUARTUS_BIN=%QUARTUS_ROOTDIR%\\bin
@if exist %QUARTUS_BIN%\\quartus_pgm.exe (goto DownLoad)

@set QUARTUS_BIN=%QUARTUS_ROOTDIR%\\bin64
@if exist %QUARTUS_BIN%\\quartus_pgm.exe (goto DownLoad)

:: Prepare for future use (if exes are in bin32)
@set QUARTUS_BIN=%QUARTUS_ROOTDIR%\\bin32

:DownLoad
%QUARTUS_BIN%\\quartus_pgm.exe -m jtag -c 1 -o "p;DE10_Standard_DRAM_RTL_Test.sof@2"
pause
```







# Compilation Errors

## Error (10137): Verilog HDL Procedural Assignment error at de10_standard_sdram.v(272): object "rowaddr" on left-hand side of assignment must have a variable data type

https://stackoverflow.com/questions/34028900/verilog-error-object-on-left-hand-side-of-assignment-must-have-a-variable-data

Solution: 

Change the datatype from wire to reg. Only reg can be assigned a value in a always block.

In addition to the input and output declaration, if you want a input/output/inout variable to be a reg, 
add an explicit declaration of that symbol to define it's datatype. Per default interface variables are interpreted to have "wire" type by the compiler,
you explicitly have to change it to reg.







# Programming Errors

## Device Chain in Chain description file does not match physical device chain -- expected 1 device(s) but found 2 device(s)

https://community.intel.com/t5/Intel-Quartus-Prime-Software/Programmer-Error-Message-quot-Device-Chain-does-not-match/m-p/146182

The JTAG chain in the programmer has to match all devices available on the PCB!
For the DE10-Standard, you have two JTAG devices: 

SOCVHPS and 5CSXFC6D6.

If you do not have a 5CSXFC6D6 JTAG node in the list, add it manually using the "?? to De ???" button. (My UI is cut of due to resolution issues)










## Seven Segment Display

The DE10 Standard has six 7-Segment displays.
The rightmost 7-Segment Display is HEX0
The leftmost 7-Segmeent Display is HEX5

Nomenclature for the segments on this board is:

          0
        -----
       |     |
      5|     | 1
       |  6  |
        -----
       |     |
      4|     | 2
       |     |
        ----- 
          3

Negative Logic:
Writing a zero to any of these bars will turn it ON
Writing a one will turn things OFF!

A function that turns bits into the corresponding 7-Segment digit representation can be found here:
https://github.com/ganz125/seven_segments/blob/main/drive_6dig_7segs.v

```
//
// Convert a hex nibble, i.e. 0 through F, to a 7 bit variable
// representing which segments on the 7 segment display should 
// be lit.
//
function automatic [6:0] segments ( input [3:0] i_nibble );

   begin
      
      //
      // Since DE10-Lite board 7 segment displays LEDs
      // are wired active low, the bit patterns below 
      // are negated.  
      //
      // Each 1 in the raw literal value represents 
      // a lit segment.  
      //
      // 'default' case not necessary since list is exhaustive,
      // but good practice to include to ensure avoiding unintentional
      // inferred latch.  Note that this is _combinational_ logic.
      //
      
      case (i_nibble)         // 654 3210 <----- Bit positions based on
         4'h0   : segments = ~7'b011_1111;   //  numbering in comments at
         4'h1   : segments = ~7'b000_0110;   //  top of this module.
         4'h2   : segments = ~7'b101_1011;
         4'h3   : segments = ~7'b100_1111;
         4'h4   : segments = ~7'b110_0110;
         4'h5   : segments = ~7'b110_1101;
         4'h6   : segments = ~7'b111_1101;
         4'h7   : segments = ~7'b000_0111;
         4'h8   : segments = ~7'b111_1111;
         4'h9   : segments = ~7'b110_1111;
         4'hA   : segments = ~7'b111_0111;
         4'hB   : segments = ~7'b111_1100;
         4'hC   : segments = ~7'b011_1001;
         4'hD   : segments = ~7'b101_1110;
         4'hE   : segments = ~7'b111_1001;
         4'hF   : segments = ~7'b111_0001;
         default: segments = ~7'b100_0000;
      endcase
      
   end

endfunction
```
