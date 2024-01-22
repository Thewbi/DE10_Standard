# DE10_Standard_SDRAM

This example uses code from the SDRAM tester which is an official example from the SystemCD.

The extracted code will just write a single byte into the very first cell of the SDRAM and read it back.

The byte is written, when the push-button KEY[1] is pressed (KEY[0] is the rightmost button).
Another press of the KEY[1] button terminates the write operation.

The byte is read back, when the push-button KEY[2] is pressed.
Another push of KEY[2] then sets back the READA flag.

To start a write operation, the WRITEA flag is set to 1.
I think that WRITEA is means that first the activation command is executed which sets the column and bank
and then the WRITE operation is executed.
The second push of KEY[1] sets the WRITEA flag back to 0. This just resets internal state
so that another operation WRITEA or READA is correctly executed by the logic.
If WRITEA is not set back to 0, then both WRITEA and READA could be activated at the same time
and the system will not execute correctly.

To start a read operation, the KEY[2] is used.
KEY[2] sets the READA flag which executes the read operation.
The read byte is output as digit on the leftmost 7-Segment display.
Another push of the button resets the READA flag, so that the system does not activated two flags (READA and WRITEA)
at the same time which would lead to a system that does not correctly read or write.