# What is this project about.

The purpose of this project is to test the mega wizard feature of generating a read-only memory ROM and to initialize the ROM using a intel .hex file.

This project does not use the SDRAM of the DE10-Standard.

This project was generated using the SystemBuilder and compiled with Quartus Prime Lite version 22.1.

The ROM was generated using the IP Catalog:
IP Catalog > Library > Basic Functions > On Chip Memory > ROM: 1-PORT
Filename: rom_1_port

Set the q output bus width to 8
Use 1024 words (1 KB) (= 1024 bytes in this case, word == byte here)
block type: auto
clocking: single

On the "Mem Init" step of the mega wizard, choose: "Yes, use this file for the memory content data" and browse to the .hex file you want to use.

To create a .hex file, you can use this editor:
https://www.sweetscape.com/download/010editor/download_010editor_win64.html

First, create a .txt file.
Change the edit mode to hex editing: View > Edit As > hex
Now, you can enter bytes in hex format. The advantage is that these bytes will be exported to the .hex file exactly as you type them here.

To export the data in the .hex format, use
File > Export Hex... 
Export Type: Intel 8-Bit Hex Code (*.hex)
Bytes Per Row: 16

1024 byte / 16 byte per line = 64 lines
For a 1024 byte payload .hex file, you have to enter 64 lines a 16 byte.

On the summary page of the mega wizard, select to generate the "Instantiation template file"