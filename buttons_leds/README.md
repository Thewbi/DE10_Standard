# Links

https://www.youtube.com/watch?v=omVY5gHuTw8



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

While the counter.v is selected, File > Create / Update > Create Symbol files for current file >

Insert the counter module into the top-level block diagram.

Double click the empty area > Project > Under "Libraries" unfold the project node > Select the counter node > Click > OK.

Open the IP catalog to pull in a PLL clock into the top level design.

Select PLL Intel FPGA IP. >  The MegaWizard will load.
Reference Clock Frequency: 50 Mhz.
Desired Frequence 2 MHz.
Remove the checkbox at the lock output.
Finish.

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
