# ULPI using DE10 Standard and the USB3300 from Microchip / SMSC

The waveshare breakout board is used to access the USB3300 ULPI Phy.
https://www.waveshare.com/usb3300-usb-hs-board.htm




## Notes

According to this post: https://forum.microchip.com/s/topic/a5C3l000000MehxEAC/t386536
it is a problem to connect the waveshare board using jumper wires since some signals 
might get lost. The solution outlined in the forum post is to design a PCB that directly
plugs into the GPIO headers (or maybe even a pmod).

I will try using the GPIO header and jumper wires since I do not have a special PCB board
and I do have the waveshare breakout board for the USB3300 chip.

A special board is available here by defparam:
https://github.com/defparam/de0-addons
https://oshpark.com/profiles/defparam





## Generating the Project

Use the DE10_Standard_SystemBuilder.exe to generate a project.
Use Verilog.
Add the features:

 - CLOCK
 - LED x10
 - Button x4
 - 7-Segment x6
 - Switch x10
 - GPIO Default (3v3)
 
 
 

## Phyiscal GPIO pin connections

The GPIO header is described in DE10-Standard_Schematic.pdf on sheet 13 of 33.
Here a graphical view of the header is given.
Only 36 out of the 40 pins are given names such as GPIO_D0, GPIO_D1, ...

When generating a project using the DE10_Standard_SystemBuilder.exe and activating
the GPIO headers, a variable GPIO is generated.

```
inout           [35:0]      GPIO
```

As you can see the GPIO variable only has 36 bits. I think the 36 bits correlate
to the 36 named pins in the DE10-Standard_Schematic.pdf on sheet 13 of 33.

The unnamed pins (3v3, 5V, GND) are not named and hence cannot be used as GPIO
pins. It makes no sense the use power and GND as GPIO pins, since power and ground
are no input output funcions!

### First Experiment, Only connect ULPI Pins! Ignore UTMI pins!

The pin names on the Waveshare board are printed to the silkscreen
on the backside of the Waveshare breakout board.

| Waveshare Board | DE10 Standard GPIO Header | GPIO Name | Cable/Jumper Wire Color Used |
| ---             | ---                       | ---       | ---                          |
| 3v3             | GPIO Pin 29               | VCC3p3    | Red                          |
| GND             | GPIO Pin 30 (GND)         | N/A       | Orange                       |
| STP             | GPIO Pin 27               | GPIO_D24  | Yellow                       |
| NXT             | GPIO Pin 25               | GPIO_D22  | Green                        |
| DIR             | GPIO Pin 23               | GPIO_D20  | Blue                         |
| CLK             | GPIO Pin 21               | GPIO_D18  | Purple                       |
| RST             | GPIO Pin 19               | GPIO_D16  | Gray                         |
| 5V              | GPIO Pin 11               | VCC5      | White                        |
| ---             | ---           |           | ---       | ---                          |
| DATA 0          | GPIO Pin 28               | GPIO_D25  | Black                        |
| DATA 1          | GPIO Pin 26               | GPIO_D23  | Brown                        |
| DATA 2          | GPIO Pin 24               | GPIO_D21  | Red                          |
| DATA 3          | GPIO Pin 22               | GPIO_D19  | Orange                       |
| DATA 4          | GPIO Pin 20               | GPIO_D17  | Yellow                       |
| DATA 5          | GPIO Pin 18               | GPIO_D15  | Green                        |
| DATA 6          | GPIO Pin 16               | GPIO_D13  | Blue                         |
| DATA 7          | GPIO Pin 14               | GPIO_D11  | Purple                       |
