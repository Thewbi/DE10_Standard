# DE10_Standard
DE10 Standard projects



# Links

https://github.com/zangman/de10-nano
https://github.com/zangman/de10-nano/blob/master/docs/Configuring-the-Device-Tree.md

Avalon:
https://www.youtube.com/watch?v=Vw2_1pqa2h0



# Terasic DE 10

## General

DE stands for Development and Education (https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=163)



## Boards

DE0 Nano - small board without ethernet port
DE10 Nano - https://www.mouser.de/ProductDetail/Terasic-Technologies/P0496?qs=%2FacZuiyY%252B4ZdDLJqTxdJ5w%3D%3D
DE10 Standard - 

DE1-SoC - https://people.ece.cornell.edu/land/courses/ece5760/DE1_SOC/DE1-SoC_User_manualv.1.2.2_revE.pdf





# Terminology / Glossary

https://www.intel.com/content/www/us/en/programmable/quartushelp/17.0/reference/glossary/glosslist.htm

DE10_NANO_SoC_GHRD - Golden Hardware Reference Designs (GHRD) (see ug_soc_eds-19-1-standard-and-19-3-pro-683187-705474.pdf)
https://github.com/altera-opensource
Also Chapter: (6.2 Golden Hardware Reference Design (GHRD) and system circuit) of https://matheo.uliege.be/bitstream/2268.2/11612/7/Implementing%20the%20beta%20machine%20on%20a%20Terasic%20DE10%20SoC%20%2b%20FPGA%20development%20board.pdf

.sof - FPGA hardware SRAM Object File (.sof) file. A SRAM object file is used
.sof files can be converted to .rbf files using Quartus.
Quartus II project file (.qpf)
Quartus II setting file (.qsf)
Top-level design file (.v or .vhd)
Synopsis design constraints file (.sdc)
Pin assignment document (.htm)

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

The System Builder is an application that output Quartus projects based on options
that the user selects inside the system builder tool.

Additionally, developers can use the System Builder software utility to create their Quartus project.





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

Tools > programmer > Hardware Setup > Add Hardware > Auto Detect

The chip on the DE10 Standard is: 5CSXFC6D6F31   (SE 5CSXFC6D6F31C6N)
Mode: JTAG

Processing > Auto Detect > Select: 5CSXFC6D6

https://www.youtube.com/watch?v=erYag9zr0ek
There will be a warning about non-matching something, click OK and ignore it.

Select the FPGA in the graphical JTAG chain > On the left hand side, select "Change file" > Select the .sof file.
In the columns, set the checkbox called "Program/Configure" > Click "Start" on the left side


Device Manager > JTAG Cables





# Blink LEDs

Start Quartus

File > New > New Quartus Prime Project

On the Device Selection wizard, select Family: Cyclone V (E / GX / GT / SX / SE / ST)
Device: Cyclone V SX Extended edition features

In the available device list, select 5CSXFC6D6F31C6 > Finish the wizard.

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

Double click the empty area > Project > Under "Libraries" unfold the project node > Select the counter node > Click > OK.

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