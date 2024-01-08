# DE10_Standard
DE10 Standard projects



= Terasic DE 10 =

== General ==

DE stands for Development and Education (https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=163)



== Boards ==

DE0 Nano - small board without ethernet port
DE10 Nano - https://www.mouser.de/ProductDetail/Terasic-Technologies/P0496?qs=%2FacZuiyY%252B4ZdDLJqTxdJ5w%3D%3D
DE10 Standard - 

DE1-SoC - https://people.ece.cornell.edu/land/courses/ece5760/DE1_SOC/DE1-SoC_User_manualv.1.2.2_revE.pdf





= Terminology / Glossary =
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




== golden_top Quartus project ==

See DE10-Standard_User_manual.pdf

Is a template project for Quartus to start projects for the DE10 standard from.
It is contained on the CD.

== DE10 Standard System Builder ==

See DE10-Standard_User_manual.pdf

The System Builder is an application that output Quartus projects based on options
that the user selects inside the system builder tool.

Additionally, developers can use the System Builder software utility to create their Quartus project.



== FPGA Startup/Configuration Mode ==

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


== Programming the FPGA ==

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






== NIOS ii, UART over JTAG ==

C:\intelFPGA_lite\22.1std\University_Program\Monitor_Program\amp\lib\src\niosII_jtag_uart.c




== UART over GPIO pins ==

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






== Error Upgrading ==

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



== Error compiling the DE10-Standard Computer ==

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
