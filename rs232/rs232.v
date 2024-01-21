module rs232(input clk, input rst);

	wire locked;
	wire outclk_0;
	
	baudrate_pll(clk, rst, outclk_0, locked);


endmodule